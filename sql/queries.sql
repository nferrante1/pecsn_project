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
	

--UTILIZATION
SELECT clients, scenario, config, moduleName, AVG(statSum)/3600 as utilization 
FROM runConfig NATURAL JOIN statistic
WHERE scenario = "s1" AND
		statName = "workingStat:stats"
GROUP BY config, clients, moduleName
ORDER BY clients


--Throughput 
SELECT clients, scenario, config, attrValue, statCount / 3600.0 as throughput 
FROM runAttr NATURAL JOIN runConfig NATURAL JOIN statistic
WHERE scenario = "s2" AND
		statName = "completedTransactions:stats" AND
		attrName = "repetition"
order by scenario, config, attrValue
--ResponseTime
SELECT clients, scenario, config, attrValue, statMean as responseTime 
FROM runAttr NATURAL JOIN runConfig NATURAL JOIN statistic
WHERE scenario = "s1" AND
		statName = "responseTimeStat:stats" AND
		attrName = "repetition" AND
		moduleName = "Network"
order by scenario, config, attrValue
