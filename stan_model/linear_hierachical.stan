data {
  int<lower=0> N;           // Total number of observation
  int<lower=0> J;           // Number of groups
  int id[N];                // Group index, 1 for male, 2 for female
  vector[N] x;              // The covariate
  vector[N] y;              // Burnout rate
}

parameters {
  
  // Hyperpriors
  real mu0;                   // Mean for the hyperprior for beta1
  real<lower=0> sigma0;       // Variance for the hyperprior for beta1
  
  real mu1;
  real<lower=0> sigma1;
  
  real beta0[J];               // Beta0 and beta1
  real beta1[J];
  
  real<lower=0> sigma;             // Variance of the regression 
}


model {
  vector[N] mu;  // The predictor
  
  // priors
  mu0 ~ normal(0, 500);
  sigma0 ~ gamma(10, 10);
  mu1 ~ normal(0.5, 100);
  sigma1 ~ gamma(10, 10);
  
  sigma ~ gamma(80, 10);

  for(j in 1:J) {
    beta0[j] ~ normal(mu0, sigma0);
    beta1[j] ~ normal(mu1, sigma1);
  }  
  
  for(n in 1:N) {
    mu[n] = beta0[id[n]] + x[n] * beta1[id[n]];
  }
  
  // likelihood
  y ~ normal(mu, sigma);
}
