# Influence of Unemployment Rate on Suicide

## Problem Description
Our goal is to investigate in the relationship between unemployment rate and suicide rate, trying to make
predictions based on unemployment rate for each country.

## Data Description: 
Our data consists of two datasets retrieved from kaggle.com. The first dataset contains suicide information
by year and country from 1985-2016 with 12 variables (country, year, sex, age group, count of suicides,
population, suicide rate, country-year composite key, HDI for year, gdp for year $, gdp per capita, generation).
The other dataset includes the unemployment rates by country from 1991-2021.

Since the two datasets have a different time range, we first took their intersection by year and kept only rows
whose year are common to both, from 1991-2015. Furthermore, some of the countries do not have complete
data for every years in the selected time range, therefore we decided to focus on those European countries
that have complete suicide information from 1991-2015. Because of the limited data, we also decided to ignore
the year attribute. Finally, the remaining variables that are of interest are country, suicide rate (suicide
per 100k), and unemployment rate. In addition, we fit the model using data until 2014, and leave 2015 for
predictive performance assessment.

The preprocessing can be seen in the file `suicide_preprocess.ipynb` and the output data is in `data/suicide_with_unemploy.csv`


## Main modelling idea:

A quick look at the data suggests that there are no overall trend between the unemployment rate and the
suicide rate. However, upon a closer look, we can see that the unemployment rate and the suicide rate of
individual countries follows a linear trend. Thus, we decide that we would implement two models: a linear
separate model and a linear hierarchical model.

In more detail, denote the suicide rate of country $j$ as $y_j$, and the corresponding unemployment rate as $x_j$.
We want to fit the following model:

$$
y_j = β_{0_j} + x_j · β_{1_j}
$$

In other words, we can rewrite $y_j$ as:

$$
y_j \sim N(β_{0_j} + x_j · β_{1_j}, \sigma_j)
$$

We want to simulate the value of $\beta_{0_j}$, $\beta_{1_j}$, and $\sigma_j$ using two kinds of models: a separate pirors for all of them and a hierachical prior where $\beta_{1_j}$ generated from a population distribution. Below is the description of the priors. The detailed reasoning on how to derive the prior can be seen in `project_report.pdf`.

## Separate model:
The prior distritions for the parameters are as follow:

$$
\begin{aligned}
\beta_{0_j} &\sim N(1.89, 20) \\
\beta_{1_j} &\sim N(0, 2.5) \\
   \sigma_j &\sim Half-Cauchy(0, 10) \\
        y_j &\sim N(\beta_{0_j} + x_j \cdot \beta_{1_j}, \sigma_j)
\end{aligned}
$$

## Hierachical model:
The prior distributions for the parameters are as follow:

$$
\begin{aligned}
   \mu_{1_j} &\sim N(0, 10) \\
\sigma_{1_j} &\sim Half-Cauchy(0, 10) \\
 \beta_{1_j} &\sim N(\mu_{1_j}, \sigma_{1_j}) \\
     \beta_0 &\sim N(1.89, 20) \\
      \sigma &\sim Half-Cauchy(0, 10) \\
      y_{ij} &\sim N(\beta_0 + \beta_{1_j} \cdot x_{ij}, \sigma)
\end{aligned}
$$


## Experiments:
For the experiment, we used the aforementioned priors to generate the posterior distributions of $\beta_0$, $\beta_1$, and $\sigma$ and use those value to predict $y_j$ as shown above. The code for the experiment can be seen in the file `Models.Rmd`. The results and discussions can be seen in `project_report.pdf`.

