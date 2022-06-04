--TABLE TO HOLD AGE DATA--
CREATE TABLE DataProjects.dbo.AgeTable (
Team_Name varchar(100),
ChampAge float,
DiffToCHAgeAvg float,
FirstPLAge float,
DiffToPL1PossAvg float,
SecondPLAge float,
DiffToPL2AgeAvg float)

--STATEMENT USED WITH EACH SELECT TO INSERT VALUES INTO TABLE--
INSERT INTO DataProjects.dbo.AgeTable(Team_Name, ChampAge, FirstPLAge, SecondPLAge) 

--FINDING AVG AGE OF BRI AND HUDD FROM SEASONS--
SELECT HB1617.Squad,
HB1617.Age AS CH_Age,
HB1718.Age AS PL_First_Poss, 
HB1819.Age AS PL_Second_Poss
FROM DataProjects.dbo.HUDD_BRI_CH_STATS_1617 AS HB1617
INNER JOIN DataProjects.dbo.HUDD_BRI_PL_STATS_1819 AS HB1819 ON HB1617.Squad = HB1819.Squad
INNER JOIN DataProjects.dbo.HUDD_BRI_PL_STATS_1718 AS HB1718 ON HB1617.Squad = HB1718.Squad
WHERE HB1617.Squad = 'Brighton' 
	OR HB1617.Squad = 'Huddersfield'
GROUP BY HB1617.Squad, HB1617.Age, HB1718.Age, HB1819.Age;

--FINDING AVG AGE OF LUFC FROM SEASONS--
SELECT LU1920.Squad,
LU1920.Age AS CH_Age, 
LU2021.Age AS First_Age,
LU2122.Age AS Second_Age
FROM DataProjects.dbo.LUFC_CH_STATS_1920$ AS LU1920
INNER JOIN DataProjects.dbo.LUFC_PL_STATS_2021$ AS LU2021 ON LU1920.Squad = LU2021.Squad
INNER JOIN DataProjects.dbo.LUFC_PL_STATS_2122$ AS LU2122 ON LU1920.Squad = LU2122.Squad
WHERE LU1920.Squad = 'Leeds United'
GROUP BY LU1920.Squad, LU1920.Age, LU2021.Age, LU2122.Age

--FINDING AVG AGE OF SUFC FROM SEASONS-- 
SELECT SU1819.Squad,
SU1819.Age AS CH_Age,
SU1920.Age AS First_Age, 
SU2021.Age AS Second_Age
FROM DataProjects.dbo.SUFC_CH_STATS_1819$ AS SU1819
INNER JOIN DataProjects.dbo.SUFC_PL_STATS_1920$ AS SU1920 ON SU1819.Squad = SU1920.Squad
INNER JOIN DataProjects.dbo.SUFC_PL_STATS_2021$ AS SU2021 ON SU1819.Squad = SU2021.Squad
WHERE SU1819.Squad = 'Sheffield Utd'
GROUP BY SU1819.Squad, SU1819.Age, SU1920.Age, SU2021.Age

--INSERTING DIFFERENCES TO AVG IN EACH SEASON--
--CHAMPIONSHIP SEASON--
UPDATE DataProjects.dbo.AgeTable
SET DiffToCHAgeAvg = CASE
WHEN Team_Name = 'Brighton' OR Team_Name = 'Huddersfield' THEN (SELECT (ROUND(ChampAge - ((AVG(CAST (Age as float)))), 2)) FROM DataProjects.dbo.HUDD_BRI_CH_STATS_1617)
WHEN Team_Name = 'Leeds United' THEN (SELECT (ROUND(ChampAge - ((AVG(CAST (Age as float)))), 2)) FROM DataProjects.dbo.LUFC_CH_STATS_1920$)
WHEN Team_Name = 'Sheffield Utd' THEN (SELECT (ROUND(ChampAge - ((AVG(CAST (Age as float)))), 2)) FROM DataProjects.dbo.SUFC_CH_STATS_1819$)
END
--FIRST PREM SEASON--
UPDATE DataProjects.dbo.AgeTable
SET DiffToPL1PossAvg = CASE
WHEN Team_Name = 'Brighton' OR Team_Name = 'Huddersfield' THEN (SELECT (ROUND(FirstPLAge - ((AVG(CAST (Age as float)))), 2)) FROM DataProjects.dbo.HUDD_BRI_PL_STATS_1718)
WHEN Team_Name = 'Leeds United' THEN (SELECT (ROUND(FirstPLAge - ((AVG(CAST (Age as float)))), 2)) FROM DataProjects.dbo.LUFC_PL_STATS_2021$)
WHEN Team_Name = 'Sheffield Utd' THEN (SELECT (ROUND(FirstPLAge - ((AVG(CAST (Age as float)))), 2)) FROM DataProjects.dbo.SUFC_PL_STATS_1920$)
END
--SECOND PREM SEASON--
UPDATE DataProjects.dbo.AgeTable
SET DiffToPL2AgeAvg = CASE
WHEN Team_Name = 'Brighton' OR Team_Name = 'Huddersfield' THEN (SELECT (ROUND(SecondPLAge - ((AVG(CAST (Age as float)))), 2)) FROM DataProjects.dbo.HUDD_BRI_PL_STATS_1819)
WHEN Team_Name = 'Leeds United' THEN (SELECT (ROUND(SecondPLAge - ((AVG(CAST (Age as float)))), 2)) FROM DataProjects.dbo.LUFC_PL_STATS_2122$)
WHEN Team_Name = 'Sheffield Utd' THEN (SELECT (ROUND(SecondPLAge - ((AVG(CAST (Age as float)))), 2)) FROM DataProjects.dbo.SUFC_PL_STATS_2021$)
END

--VIEW TABLE RESULTS--
SELECT * FROM DataProjects.dbo.AgeTable
