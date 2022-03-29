--CREATING TABLE FOR TOTAL POINTS SO FAR--

--LISTING POINTS FROM EACH RACE PLUS SEASON TOTAL--
SELECT br.DRIVER, br.PTS AS Bahrain, jr.PTS AS Jeddah, SUM(br.pts + jr.pts) AS SeasonTotal
FROM BahrainRace as BR
	INNER JOIN JeddahRace as JR
ON BR.DRIVER = JR.DRIVER
GROUP BY BR.DRIVER, BR.PTS, JR.PTS
ORDER BY SeasonTotal DESC;

--CONSTRUCTOR POINTS CALCULATION--
SELECT 
DISTINCT br.CAR as CONSTRUCTOR, --COUNT(DISTINCT br.DRIVER) AS driver_count, --SUM(DISTINCT br.pts) as bahrain_team_points, SUM(DISTINCT jr.pts) as jeddah_team_points--
(SUM(DISTINCT br.pts) + SUM(DISTINCT jr.pts)) AS TOTALPOINTS
FROM BahrainRace as BR
	INNER JOIN JeddahRace as JR
ON BR.CAR = JR.CAR
GROUP BY BR.CAR
ORDER BY TOTALPOINTS DESC;