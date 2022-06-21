
--YVES STATS VS ALL TOTTENHAM CM-DM--
SELECT FullTable.Player, FullTable.Pos, FullTable.Age, FullTable.Squad, FullTable.MP As MatchesPlayed, DefTable.[Tkl%] AS PercentageOfDribblersTackled, ROUND((DefTable.Succ/FullTable.[Min]),2) * 90 as SuccessfulPressesPer90, MiscTable.Recov AS Recoveries, PassTable.[Cmp%],
PassTable.PrgDist, DefTable.TklW AS TackleTurnovers FROM Top5League_2122.dbo.FullXG$ as FullTable
JOIN Top5League_2122.dbo.DefensiveActions$ AS DefTable ON FullTable.Player = DefTable.Player AND (FullTable.Squad = 'Tottenham' AND DefTable.Squad = 'Tottenham') 
JOIN Top5League_2122.dbo.Passing$ AS PassTable ON FullTable.Player = PassTable.Player AND (FullTable.Squad = 'Tottenham' AND PassTable.Squad = 'Tottenham')
JOIN Top5League_2122.dbo.MiscStats$ AS MiscTable ON FullTable.Player = MiscTable.Player AND (FullTable.Squad = 'Tottenham' AND MiscTable.Squad = 'Tottenham')
WHERE (FullTable.Pos = 'MF' OR FullTable.Pos ='DFMF') AND FullTable.MP > 3
UNION
SELECT FullTable.Player, FullTable.Pos, FullTable.Age, FullTable.Squad, FullTable.MP As MatchesPlayed , DefTable.[Tkl%], ROUND((DefTable.Succ/FullTable.[Min]),2) * 90 as SuccessfulPressesPer90, MiscTable.Recov AS Recoveries, PassTable.[Cmp%],
PassTable.PrgDist, DefTable.TklW AS TackleTurnovers FROM Top5League_2122.dbo.FullXG$ as FullTable
JOIN Top5League_2122.dbo.DefensiveActions$ AS DefTable ON FullTable.Player = DefTable.Player
JOIN Top5League_2122.dbo.Passing$ AS PassTable ON FullTable.Player = PassTable.Player
JOIN Top5League_2122.dbo.MiscStats$ AS MiscTable ON FullTable.Player = MiscTable.Player
WHERE FullTable.Player = 'Yves Bissouma'
ORDER BY SuccessfulPressesPer90 DESC;

--AGAINST PL TOP 6 COUNTERPARTS--
SELECT Top 6 Player, [90s], Squad, ROUND(([Tkl+Int]/[90s]),2) AS TacklesAndIntPer90, [Tkl%] AS PercentageOfDribblersTackled, ROUND(([Succ]/[90s]),2) AS SuccessfulPressesPer90, TklW As PossessionWinningTackles
FROM Top5League_2122.dbo.DefensiveActions$
WHERE ((Squad = 'Manchester City' OR Squad = 'Manchester Utd' OR Squad = 'Chelsea' OR Squad = 'Liverpool' OR Squad = 'Arsenal') OR Player = 'Yves Bissouma')
AND (Pos = 'MF' OR Pos ='DFMF') 
AND [Tkl%] > 30 
AND [90s] > 20
ORDER BY TacklesAndIntPer90 DESC;

--AGAINST EUROPEAN COUNTERPARTS--
SELECT TOP 7 Player, [90s], Squad, ROUND(([Tkl+Int]/[90s]),2) AS TacklesAndIntPer90, [Tkl%] AS PercentageOfDribblersTackled, ROUND(([Succ]/[90s]),2) AS SuccessfulPressesPer90, TklW As PossessionWinningTackles 
FROM Top5League_2122.dbo.DefensiveActions$
WHERE ((Squad = 'Bayern Munich' OR Squad = 'Paris S-G' OR Squad = 'Milan' OR Squad = 'Inter' OR Squad = 'Barcelona' OR Squad = 'Real Madrid') OR Player = 'Yves Bissouma')
AND (Pos = 'MF' OR Pos ='DFMF') 
AND [Tkl%] > 30 AND [Tkl+Int] > 30
AND [90s] > 20
ORDER BY TacklesAndIntPer90 DESC;
