# StatisticalComputation2020
My project on statistical computation course at IIITD

This project uses Bayesian Networks for causal learning on the Cleveland Heart Disease dataset (https://archive.ics.uci.edu/ml/datasets/Heart+Disease)

Hill climbing - a score based heursitic algorithm is used for learning the structure of the network. I use three model scoring criterions BIC, AIC and simple log likelihood. The algorithm outputs the graph which has the best score(can output locally optimum structures, in terms of the scores used).

Once the structure is established, I use MLE for estimating the parameters of the graph. Please see the report for more details.

