function [U, throughput, res_time] = buzen(M,K,rho,mu,p1)
G = ones(M,K+1);

for i = 2:M
    for j=2:K+1
        G(i,j) = G(i-1, j) + rho(i)*G(i,j-1);
    end
end

E_N = K;

U = rho*(G(M,K)/G(M,K+1));
mu = mu';
gamma = U .* (1./mu(1,:));

throughput = p1*gamma(1,1);
res_time = E_N / throughput;
end

