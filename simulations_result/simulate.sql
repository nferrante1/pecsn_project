--VIEW FOR RUN PARAMETERS

CREATE VIEW runConfig AS

SELECT rp1.runId, CAST(rp1.paramValue as INT) as clients,
	SUBSTR(rp2.paramValue,2,2) as scenario, 
	SUBSTR(rp3.paramValue,2,2) as config 
FROM runParam rp1
		LEFT OUTER JOIN runParam rp2 on rp1.runId = rp2.runId
		LEFT OUTER JOIN runParam rp3 on rp1.runId = rp3.runId
WHERE rp1.paramKey = "**.clients" AND
	rp2.paramKey = "**.scenario" AND
	rp3.paramKey = "**.serviceTimeConfig"
	
--THROUGHPUT

SELECT clients, scenario, config, AVG(statCount) / 3800.0 as throughput 
FROM runConfig NATURAL JOIN statistic
WHERE scenario = "s1" AND
		statName = "completedTransactions:stats" 
GROUP BY config, clients, moduleName
ORDER BY clients
--RESPONSE TIME

SELECT clients, scenario, config, moduleName, AVG(statMean) as responseTime 
FROM runConfig NATURAL JOIN statistic
WHERE scenario = "s1" AND
		statName = "responseTimeStat:stats" AND
		moduleName = "Network"
GROUP BY config, clients, moduleName
ORDER BY clients

--UTILIZATION
SELECT clients, scenario, config, moduleName, AVG(statSum)/3800 as utilization 
FROM runConfig NATURAL JOIN statistic
WHERE scenario = "s1" AND
		statName = "workingStat:stats"
GROUP BY config, clients, moduleName
ORDER BY clients


--Throughput 2kr
SELECT clients, scenario, config, attrValue, statCount / 3800.0 as throughput 
FROM runAttr NATURAL JOIN runConfig NATURAL JOIN statistic
WHERE scenario = "s2" AND
		statName = "completedTransactions:stats" AND
		clients = 21 AND
		attrName = "repetition"
order by scenario, config, attrValue
--ResponseTime 2kr
SELECT clients, scenario, config, attrValue, statMean as responseTime 
FROM runAttr NATURAL JOIN runConfig NATURAL JOIN statistic
WHERE scenario = "s1" AND
		statName = "responseTimeStat:stats" AND
		clients = 21 AND
		attrName = "repetition" AND
		moduleName = "Network"
order by scenario, config, attrValue
