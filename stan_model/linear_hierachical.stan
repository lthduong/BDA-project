data {
  int<lower=0> N;           // Number of observation
  int<lower=0> J;           // Number of years for a country  
  vector[J] y[N];           // Suicide rate
  vector[J] x[N];           // Unemployment rate
}

parameters {
  vector[J] beta_0;               // Intercept
  vector[J] beta_1;               // The slope of the regression line
  real mu0;                       // Hyperprior 1 for beta0
  real<lower=0> sigma0;           // Hyperprior 2 for beta0
  real mu1;                       // Hyperprior 1 for beta1
  real<lower=0> sigma1;           // Hyperprior 2 for beta1
  real<lower=0> sigma;      
}


model {
  mu0 ~ cauchy(40, 2400);
  mu1 ~ cauchy(30, 1500);
  sigma0 ~ gamma(80, 10);
  sigma1 ~ gamma(80, 10);
  
  sigma ~ normal(500, 1500);
  
  for (j in 1:J) {
    beta_0[j] ~ normal(mu0, sigma0);
    beta_1[j] ~ normal(mu1, sigma1);
  }
  
  for (j in 1:J) {
    y[j] ~ normal(beta_0[j] + beta_1[j] * x[j], sigma);
  }
}
