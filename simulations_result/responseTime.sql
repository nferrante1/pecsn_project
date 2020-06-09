
--VIEW
SELECT vd.simtimeRaw as simTime, AVG(vd.value) as meanResponseTime, rp.paramValue as nClient
FROM vectorData vd NATURAL JOIN  vector v NATURAL JOIN runParam rp
WHERE v.moduleName = "Network" AND
		v.vectorName = "responseTimeStat:vector" AND 
		rp.paramKey = "**.clients"
GROUP BY vd.simtimeRaw, rp.paramValue
ORDER BY rp.paramValue;


--MEAN AND MAX RESPONSE TIMES
SELECT AVG(meanResponseTime), MAX(meanResponseTime), nCli
FROM meanResponseTime 
GROUP BY nClient
ORDER BY CAST(nClient as INT) 

--MEAN RESPONSE TIME ON 35 clients (for Warmup)
SELECT * 
FROM meanResponseTime
WHERE nClient = 35;

