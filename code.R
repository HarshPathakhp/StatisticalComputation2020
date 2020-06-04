library(bnlearn)
set.seed(0)
heart_data = read.csv(file = 'processed.cleveland.data')

use_attributes = 7
discrete_attributes_index = c(2,3,6,7,9,11,12,13)
# use the first 7 attributes, 
# age,sex,cp,trestbps,chol,fbs,restecg 
# outcome variable is num
labels = heart_data[,14]
#set labels which are 1,2,3,4 to 1, we will distinguish between absence(0)
#and presence(1,2,3,4)
index = labels != 0
labels[index] = 1
labels = factor(labels)

heart_data = heart_data[,1:use_attributes]
heart_data$num = labels
#heart_data is a dataframe containing the following attributes
# age sex cp trestbps chol fbs restecg num

#since columns named sex, cp, fbs and restecg contain discrete values, 
#we need to call factor() on those columns
for(id in discrete_attributes_index){
  if(id > use_attributes){
    break
  }
  heart_data[,id] = factor(heart_data[,id])
}
#create train and test sets
#80/20 train test split
train_index <- sample(1:nrow(heart_data), 0.8 * nrow(heart_data))
test_index <- setdiff(1:nrow(heart_data), train_index)

x_train = heart_data[train_index, -use_attributes-2]
y_train = heart_data[train_index, "num"]
x_test = heart_data[test_index, -use_attributes-2]
y_test = heart_data[test_index, "num"]
#NOTE - the first 7 columns do not have missing values
#specify model selection criterions, loglik-cg will 
#output a maximal dag, since it has highest likelihood, but
#can overfit
#aic-cg and bic-cg will introduce penalisations(more in report)
model_selection = c("bic-cg", "aic-cg", "loglik-cg")

for(selection in model_selection){
	filename = paste(selection, "png", sep = ".")
	#use hill climbing for structure learning
	net = hc(x_train, score = selection)
	
	#plot the network
	png(filename = filename)
	plot(net)
	dev.off()
	
	#fit the network using MLE
	fitted = bn.fit(net, x_train)
	
	#predict on train and test to compute accuracy
	train_predict = predict(fitted, "num", x_train)
	test_predict = predict(fitted, "num", x_test)
	acc_train = sum(train_predict == y_train, na.rm = T) / length(train_predict) *100
	acc_test = sum(test_predict == y_test, na.rm = T) / length(test_predict) *100
	print(paste("train and test accuracy for", selection, sep = " "))
	print(acc_train)
	print(acc_test)
}


