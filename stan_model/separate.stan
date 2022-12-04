data {
  int<lower=0> N;       // number of observations
  int<lower=0> J;       // number of countries
  int<lower=0> id[N];   // group indicator
  vector[N] y;
  vector[N] x;           // Unemployment rate
}

parameters {
  vector[J] beta0;
  vector[J] beta1;
  vector<lower=0>[J]  sigma;  
  
}

model {
  // priors
  for (j in 1:J){
    beta0[j] ~ normal(1.89, 20);
    beta1[j] ~ normal(0, 2.5);
    sigma[j] ~ cauchy(0, 10);
  }
  
  // likelihood
  for (n in 1:N) {
    y[n] ~ normal(x[n]*beta1[id[n]] + beta0[id[n]], sigma[id[n]]);
  }
}

generated quantities {
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(y[n] | x[n] * beta1[id[n]] + beta0[id[n]], sigma[id[n]]);
  }
}
