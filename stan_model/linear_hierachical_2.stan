data {
  int<lower=0> N;             // number of observations
  int<lower=0> J;             // number of groups
  int<lower=0> id[N];         // group index
  vector[N] x;                // explanatory variables
  vector[N] y;                // response variables
}

parameters {
  vector[J] beta1;     // The slope
  real mu1;       // Mean hyperprior for beta1
  real<lower=0> sigma1;    // Variance hyperprior for beta1
  
  real beta0;          // The common intercept
  real<lower=0> sigma;          // The common variance
}

model {
  
  beta0 ~ normal(0, 200);
  mu1 ~ normal(0, 200);
  sigma1 ~ cauchy(0, 50);
  
  sigma ~ cauchy(0, 50);
  
  for(j in 1:J) {
    beta1[j] ~ normal(mu1, sigma1);
  }
  
  for (n in 1:N) {
    y[n] ~ normal(x[n]*beta1[id[n]] + beta0, sigma);
  }

}

generated quantities{
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(y[n] | x[n] * beta1[id[n]] + beta0, sigma);
  }
}
