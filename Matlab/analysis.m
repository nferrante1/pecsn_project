%WARMUP TIME
statement_resTime = "select * from meanResponseTime WHERE nClient = 21";
conn = sqlite("../code/omnet/simulations/results/tuning.vec");
results = fetch(conn, statement_resTime);
time = cell2mat(results(:,1));
time = time*10^-12;
resTime = cell2mat(results(:,2));
plot(time(1:10000), resTime(1:10000));




