--CREATING TABLE TO HOLD DATA--
CREATE TABLE DataProjects.dbo.GoalStatsTable (
Team_Name varchar(100),
CH_GF float,
CH_GA float,
CH_GF_Diff float,
CH_GA_Diff float,
PL1_GF float,
PL1_GA float,
PL1_GF_Diff float,
PL1_GA_Diff float,
PL2_GF float,
PL2_GA float,
PL2_GF_Diff float,
PL2_GA_Diff float)

--INSERT STATEMENT FOR DATA WE ALREADY HAVE, LEAVING SPACES FOR CALCULATED CELLS--
INSERT INTO GoalStatsTable (Team_Name, CH_GF, CH_GA, PL1_GF, PL1_GA, PL2_GF, PL2_GA)

--GENERATING GF + GA STATS FOR SEASONS--
-- FOR BRI AND HUDD--
SELECT HB1617.Squad, 
HB1617.GF AS CH_GF, HB1617.GA AS CH_GA,
HB1718.GF AS PL1_GF, HB1718.GA AS PL1_GA,
HB1819.GF AS PL2_GF, HB1819.GA AS PL2_GA
FROM DataProjects.dbo.HUDD_BRI_CH_TABLE_1617 AS HB1617
INNER JOIN DataProjects.dbo.HUDD_BRI_PL_TABLE_1718 AS HB1718 ON HB1617.Squad = HB1718.Squad
INNER JOIN DataProjects.dbo.HUDD_BRI_PL_TABLE_1819 AS HB1819 ON HB1617.Squad = HB1819.Squad
WHERE HB1617.Squad = 'Brighton' 
	OR HB1617.Squad = 'Huddersfield'
GROUP BY HB1617.Squad, HB1617.GF, HB1617.GA, HB1718.GF, HB1718.GA, HB1819.GF, HB1819.GA

--GENERATING GF + GA STATS FOR SEASONS--
--FOR LUFC--
SELECT LU1920.Squad,
LU1920.GF AS CH_GF, LU1920.GA AS CH_GA,
LU2021.GF AS PL1_GF, LU2021.GA AS PL1_GA,
LU2122.GF AS PL2_GF, LU2122.GA AS PL2_GA
FROM DataProjects.dbo.LUFC_CH_TABLE_1920$ AS LU1920
INNER JOIN DataProjects.dbo.LUFC_PL_TABLE_2021$ AS LU2021 ON LU1920.Squad = LU2021.Squad
INNER JOIN DataProjects.dbo.LUFC_PL_TABLE_2122$ AS LU2122 ON LU1920.Squad = LU2122.Squad
WHERE LU1920.Squad = 'Leeds United'
GROUP BY LU1920.Squad, LU1920.GF, LU1920.GA, LU2021.GF, LU2021.GA, LU2122.GF, LU2122.GA

--GENERATING GF + GA STATS FOR SEASONS--
--FOR SUFC--
SELECT SU1819.Squad,
SU1819.GF AS CH_GF, SU1819.GA AS CH_GA,
SU1920.GF AS PL1_GF, SU1920.GA AS PL1_GA,
SU2021.GF AS PL2_GF, SU2021.GA AS PL2_GA
FROM DataProjects.dbo.SUFC_CH_TABLE_1819$ AS SU1819
INNER JOIN DataProjects.dbo.SUFC_PL_TABLE_1920$ AS SU1920 ON SU1819.Squad = SU1920.Squad
INNER JOIN DataProjects.dbo.SUFC_PL_TABLE_2021$ AS SU2021 ON SU1819.Squad = SU2021.Squad
WHERE SU1819.Squad = 'Sheffield Utd'
GROUP BY SU1819.Squad, SU1819.GF, SU1819.GA, SU1920.GF, SU1920.GA, SU2021.GF, SU2021.GA

--CALCULATING THE DIFFERENCES TO LEAGUE AVERAGE FOR--
--GF, GA FROM EVERY SEASON FOR EVERY TEAM--
--USING UPDATE FUNCTIONS--

--CHAMPIONSHIP SEASON GF DIFFERENCE--
UPDATE DataProjects.dbo.GoalStatsTable
SET CH_GF_Diff = CASE
WHEN Team_Name = 'Brighton' OR Team_Name = 'Huddersfield' THEN (SELECT (ROUND(CH_GF- ((AVG(CAST (GF as float)))), 2)) FROM DataProjects.dbo.HUDD_BRI_CH_TABLE_1617)
WHEN Team_Name = 'Leeds United' THEN (SELECT (ROUND(CH_GF- ((AVG(CAST (GF as float)))), 2)) FROM DataProjects.dbo.LUFC_CH_TABLE_1920$)
WHEN Team_Name = 'Sheffield Utd' THEN (SELECT (ROUND(CH_GF - ((AVG(CAST (GF as float)))), 2)) FROM DataProjects.dbo.SUFC_CH_TABLE_1819$)
END
--CHAMPIONSHIP SEASON GA DIFFERENCE--
UPDATE DataProjects.dbo.GoalStatsTable
SET CH_GA_Diff = CASE
WHEN Team_Name = 'Brighton' OR Team_Name = 'Huddersfield' THEN (SELECT (ROUND(CH_GA- ((AVG(CAST (GA as float)))), 2)) FROM DataProjects.dbo.HUDD_BRI_CH_TABLE_1617)
WHEN Team_Name = 'Leeds United' THEN (SELECT (ROUND(CH_GA- ((AVG(CAST (GA as float)))), 2)) FROM DataProjects.dbo.LUFC_CH_TABLE_1920$)
WHEN Team_Name = 'Sheffield Utd' THEN (SELECT (ROUND(CH_GA - ((AVG(CAST (GA as float)))), 2)) FROM DataProjects.dbo.SUFC_CH_TABLE_1819$)
END
--FIRST PL SEASON GF DIFFERENCE--
UPDATE DataProjects.dbo.GoalStatsTable
SET PL1_GF_Diff = CASE
WHEN Team_Name = 'Brighton' OR Team_Name = 'Huddersfield' THEN (SELECT (ROUND(PL1_GF - ((AVG(CAST (GF as float)))), 2)) FROM DataProjects.dbo.HUDD_BRI_PL_TABLE_1718)
WHEN Team_Name = 'Leeds United' THEN (SELECT (ROUND(PL1_GF - ((AVG(CAST (GF as float)))), 2)) FROM DataProjects.dbo.LUFC_PL_TABLE_2021$)
WHEN Team_Name = 'Sheffield Utd' THEN (SELECT (ROUND(PL1_GF - ((AVG(CAST (GF as float)))), 2)) FROM DataProjects.dbo.SUFC_PL_TABLE_1920$)
END
--FIRST PL SEASON GA DIFFERENCE--
UPDATE DataProjects.dbo.GoalStatsTable
SET PL1_GA_Diff = CASE
WHEN Team_Name = 'Brighton' OR Team_Name = 'Huddersfield' THEN (SELECT (ROUND(PL1_GA- ((AVG(CAST (GA as float)))), 2)) FROM DataProjects.dbo.HUDD_BRI_PL_TABLE_1718)
WHEN Team_Name = 'Leeds United' THEN (SELECT (ROUND(PL1_GA- ((AVG(CAST (GA as float)))), 2)) FROM DataProjects.dbo.LUFC_PL_TABLE_2021$)
WHEN Team_Name = 'Sheffield Utd' THEN (SELECT (ROUND(PL1_GA - ((AVG(CAST (GA as float)))), 2)) FROM DataProjects.dbo.SUFC_PL_TABLE_1920$)
END
--SECOND PL SEASON GF DIFFERENCE--
UPDATE DataProjects.dbo.GoalStatsTable
SET PL2_GF_Diff = CASE
WHEN Team_Name = 'Brighton' OR Team_Name = 'Huddersfield' THEN (SELECT (ROUND(PL2_GF - ((AVG(CAST (GF as float)))), 2)) FROM DataProjects.dbo.HUDD_BRI_PL_TABLE_1819)
WHEN Team_Name = 'Leeds United' THEN (SELECT (ROUND(PL2_GF - ((AVG(CAST (GF as float)))), 2)) FROM DataProjects.dbo.LUFC_PL_TABLE_2122$)
WHEN Team_Name = 'Sheffield Utd' THEN (SELECT (ROUND(PL2_GF - ((AVG(CAST (GF as float)))), 2)) FROM DataProjects.dbo.SUFC_PL_TABLE_2021$)
END
--SECOND PL SEASON GA DIFFERENCE--
UPDATE DataProjects.dbo.GoalStatsTable
SET PL2_GA_Diff = CASE
WHEN Team_Name = 'Brighton' OR Team_Name = 'Huddersfield' THEN (SELECT (ROUND(PL2_GA- ((AVG(CAST (GA as float)))), 2)) FROM DataProjects.dbo.HUDD_BRI_PL_TABLE_1819)
WHEN Team_Name = 'Leeds United' THEN (SELECT (ROUND(PL2_GA- ((AVG(CAST (GA as float)))), 2)) FROM DataProjects.dbo.LUFC_PL_TABLE_2122$)
WHEN Team_Name = 'Sheffield Utd' THEN (SELECT (ROUND(PL2_GA - ((AVG(CAST (GA as float)))), 2)) FROM DataProjects.dbo.SUFC_PL_TABLE_2021$)
END

--CHECKING TABLE FOR EXPECTED OUTPUT--
SELECT * FROM DataProjects.dbo.GoalStatsTable;
