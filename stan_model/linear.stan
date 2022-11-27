data {
  int<lower=0> N;           // Number of observation
  vector[N] suicide_16;              // The population count
  vector[N] suicide_15;              // The population count
  vector[N] suicide_14;              // The population count
}

parameters {
  real beta_0;
  real beta_1;              // The slope of the regression line
  real beta_2;
  real<lower=0> sigma;      // Standard deviation of the model
}

model {
  beta_0 ~ normal(0, 1000);
  beta_1 ~ normal(0.01, 1000);
  beta_2 ~ normal(0.0001, 1000);
  sigma ~ normal(100, 1000);
  suicide_16 ~ normal(beta_0 + beta_1 * suicide_15 + beta_2 * suicide_14, sigma);
}


