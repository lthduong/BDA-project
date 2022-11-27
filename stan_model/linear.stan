data {
  int<lower=0> N;           // Number of observation
  vector[N] y;              // Suicide rate
  vector[N] x;              // Unemployment rate
}

parameters {
  real beta_0;              // Intercept
  real beta_1;              // The slope of the regression line
  real<lower=0> sigma;      
}

transformed parameters {
  vector[N] mu = beta_0 + beta_1 * x;
}

model {
  beta_0 ~ normal(10, 800);
  beta_1 ~ normal(0.5, 800);
  sigma ~ normal(500, 700);
  y ~ normal(mu, sigma);
}

