
SELECT
'League Average' as Team_Name,
ROUND(AVG(CAST (Age as float)), 2) as AvgAge
FROM DataProjects.dbo.HUDD_BRI_PL_STATS_1718

SELECT
'League Average' as Team_Name,
ROUND(AVG(CAST (HB1617.Age as float)), 1) as CH_League_Avg_Age,
ROUND(AVG(CAST (HB1718.Age as float)), 1) as PL_League_Avg_Age,
ROUND(AVG(CAST (HB1819.Age as float)), 1) as PL_League_Avg_Age
FROM DataProjects.dbo.HUDD_BRI_CH_STATS_1617 AS HB1617
INNER JOIN DataProjects.dbo.HUDD_BRI_PL_STATS_1718 AS HB1718 ON HB1617.Squad = HB1718.Squad
INNER JOIN DataProjects.dbo.HUDD_BRI_PL_STATS_1819 AS HB1819 ON HB1617.Squad = HB1819.Squad
WHERE HB1617.Squad = 'Huddersfield';

CREATE TABLE DataProjects.dbo.TestAvgTable
(ID int NOT NULL IDENTITY(1,1),
Team_Name varchar(100),
First_Season_Poss float,
League_Avg_Poss float,
Difference_Poss float,
First_Season_Age float,
League_Avg_Age float,
Difference_Age float);

CREATE TABLE #TestAvgTable
(ID int NOT NULL IDENTITY(1,1),
Team_Name varchar(100),
First_Season_Poss float,
League_Avg_Poss float,
Difference_Poss float,
First_Season_Age float,
League_Avg_Age float,
Difference_Age float);

SELECT * FROM DataProjects.dbo.TestAvgTable;
DELETE FROM DataProjects.dbo.TestAvgTable WHERE ID = '5';
--

--SELECT FROM TEST TABLE--
SELECT * FROM #TestAvgTable;
--UPDATING SINGULAR ROWS--
UPDATE #TestAvgTable 
SET First_Season_Poss = CASE
						WHEN Team_Name = 'Brighton' THEN (SELECT HB1617.Poss FROM DataProjects.dbo.HUDD_BRI_CH_STATS_1617 AS HB1617 WHERE HB1617.Squad = 'Brighton')
						WHEN Team_Name = 'Huddersfield' THEN (SELECT HB1617.Poss FROM DataProjects.dbo.HUDD_BRI_CH_STATS_1617 AS HB1617 WHERE HB1617.Squad = 'Huddersfield')
						END

UPDATE #TestAvgTable
SET League_Avg_Poss = (SELECT ROUND(AVG(CAST(Poss as float)), 1)FROM DataProjects.dbo.HUDD_BRI_CH_STATS_1617)
WHERE Team_Name = 'Huddersfield' OR Team_Name = 'Brighton'

UPDATE DataProjects.dbo.TestAvgTable
SET First_Season_Poss = (SELECT HB1617.Poss FROM DataProjects.dbo.HUDD_BRI_CH_STATS_1617 as HB1617 WHERE HB1617.Squad = 'Huddersfield')
WHERE Team_Name = 'Huddersfield'
