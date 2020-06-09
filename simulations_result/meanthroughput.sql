SELECT AVG(v.vectorMax / 3600) as meanThroughput
FROM vector v NATURAL JOIN runAttr ra
WHERE v.moduleName = "Network.server.processor" AND
		v.vectorName = "completedTransactions:vector" AND 
		ra.attrName = "measurement"
GROUP BY ra.attrValue
ORDER BY v.runId;
