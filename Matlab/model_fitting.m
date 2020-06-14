%%Probabilities
p1_ = [0.34,0.60,0.25,0.15];
p2_ = [0.33,0.25,0.60,0.25];
p_ = [[ p1_;p2_];

mu_proc_ = [0.01, 0.01 ,0.01, 0.01, 0.1, 0.1, 0.1, 0.1]; 
mu_disk_ = [0.1 , 1.0  ,0.1 , 1.0 , 0.1, 1.0, 0.1, 1.0];
mu_remote_ = [0.1 , 1.0  ,1.0 , 0.1 , 0.1, 1.0, 1.0, 0.1];
mu_ = [mu_proc_ ; mu_disk_ ; mu_remote_];

throughput = zeros (4,8,49);
responseTime = zeros (4,8,49);

for scenario = 1:4
p1 = p_(1, scenario);
p2 = p_(2,scenario);

for config = 1:8
mu_proc = mu_proc_(config);
mu_disk = mu_disk_(config);
mu_remote = mu_remote_(config);

%%Buzen algorithm
for jobs = 1:49
mu = [mu_proc ; mu_disk ; mu_remote];  
K = jobs;

%%Service Times configurations (mu)

%%Algorithm
e_proc = 1 / mu_proc;
e_disk = p2 * (e_proc);
e_remote = (1-(p1+p2))*(e_proc);

rho_proc = e_proc/(1/mu_proc);
rho_disk = e_disk/(1/mu_disk);
rho_remote = e_remote/(1/mu_remote);
rho = [rho_proc, rho_disk, rho_remote];

[throughput(scenario, config,jobs),responseTime(scenario,config,jobs)] = buzen(3,jobs,rho,mu,p1);

end
end
end



