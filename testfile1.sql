/*
The FootballMatch table shows the EPL matches played in 2024/25 season as of 16th March 2025
 
Important Columns
Date - Match Date (dd/mm/yy)
Time - Time of match kick off
HomeTeam- Home Team
AwayTeam - Away Team
FTHG -Full Time Home Team Goals
FTAG - Full Time Away Team Goals
FTR - Full Time Result (H=Home Win, D=Draw, A=Away Win)
 
Full details at https://zomalex.co.uk/datasets/football_match_dataset.html
*/
 


SELECT
    fm.Date
    , fm.HomeTeam
    , fm.AwayTeam
    , fm.FTHG
    , fm.FTAG
    , fm.FTR
FROM
    FootballMatch fm
 SELECT * FROM FootballMatch
/*
How many games have been played?.  
- In total = = 289
- By each team
- By Month
*/

SELECT count(*) As NumberOfGames FROM FootballMatch

SELECT 
     DATENAME(Year,Date) AS YearName
    ,DATENAME(MONTH,Date) AS MonthName
    ,MONTH([Date]) AS MonthNumber
    ,count(*) As NumberOfGames
FROM FootballMatch
GROUP BY MONTH(Date)
         ,DATENAME(MONTH,Date)
         ,DATENAME(Year,Date)
ORDER BY  YearName DESC
          ,MonthNumber DESC

---------------------------Sub Query Option----------------------
 SELECT
    Team
    ,SUM(TotalGoals)
FROM
(
 SELECT 
    fm.HomeTeam AS Team
    ,SUM(fm.FTHG) AS TotalGoals
 FROM FootballMatch fm    
 GROUP BY fm.HomeTeam     

UNION ALL

  SELECT 
    fm.AwayTeam
    ,SUM(fm.FTAG) 
 FROM FootballMatch fm    
 GROUP BY fm.AwayTeam 
) AS X 
GROUP BY X.Team


---------------------- CTE Option-----------------

;WITH CTE AS (
    SELECT 
    fm.HomeTeam AS Team
    ,SUM(fm.FTHG) AS TotalGoals
 FROM FootballMatch fm    
 GROUP BY fm.HomeTeam     

UNION ALL

  SELECT 
    fm.AwayTeam
    ,SUM(fm.FTAG) 
 FROM FootballMatch fm    
 GROUP BY fm.AwayTeam 
)

SELECT
    CTE.Team
    ,SUM(CTE.TotalGoals) AS TotoalGoals
FROM CTE 
GROUP BY CTE.TEAM 
ORDER BY CTE.Team
 

------------------------------temp table apporach-------------------

DROP TABLE IF EXISTS #LeagueTable;

    SELECT 
    fm.HomeTeam AS Team
   -- ,COUNT(HomeTeam) AS GamesPlayed
   -- ,SUM(CASE WHEN fm.FTR = 'H' THEN 1
   -- ELSE 0
   -- END) AS Won
    ,CASE WHEN fm.FTR = 'H' THEN 1
     ELSE 0
     END AS Won
    ,SUM(fm.FTHG) AS GF
    ,SUM(fm.FTAG) AS GA
 INTO #LeagueTable
 FROM FootballMatch fm    
 --GROUP BY fm.HomeTeam     

UNION ALL

  SELECT 
    fm.AwayTeam
  --  ,COUNT(AwayTeam)
   -- ,SUM(CASE WHEN fm.FTR = 'A' THEN 1
  --  ELSE 0
  --  END) AS Won
  ,CASE WHEN fm.FTR = 'A' THEN 1
  ELSE 0
  END AS Won
    ,SUM(fm.FTAG)
    ,SUM(fm.FTHG) 
 FROM FootballMatch fm    
-- GROUP BY fm.AwayTeam


SELECT 
     Team
   --  ,SUM(GamesPlayed) AS Played
     ,SUM(Won) AS Won
     ,SUM(GF) AS GF
     ,SUM(GA) AS GA
FROM #LeagueTable
GROUP BY Team
ORDER BY GF DESC

---------------------------------------------------------------------------------



DROP TABLE IF EXISTS #LeagueTable;
 
SELECT
    fm.HomeTeam AS Team
    ,CASE WHEN fm.FTR = 'H' THEN 1
    ELSE 0
    END AS Won
    ,CASE WHEN fm.FTR = 'A' THEN 1
    ELSE 0
    END AS Lost
     ,CASE WHEN fm.FTR = 'D' THEN 1
    ELSE 0
    END AS Draw
    ,fm.FTHG AS GF
    ,fm.FTAG AS GA
INTO #LeagueTable
    FROM FootballMatch fm
UNION ALL
SELECT
    fm.AwayTeam
    ,CASE WHEN fm.FTR = 'A' THEN 1
    ELSE 0
    END AS Won
    ,CASE WHEN fm.FTR = 'H' THEN 1
    ELSE 0
    END AS Lost
    ,CASE WHEN fm.FTR = 'D' THEN 1
    ELSE 0
    END AS Draw
    ,fm.FTAG
    ,fm.FTHG
FROM  FootballMatch fm
 
--SELECT * FROM #LeagueTable;
 
SELECT
    t.Team AS Team
    ,COUNT(*) AS Played
    ,SUM(Won) AS Wins
    ,SUM(Lost) AS Lost
    ,SUM(Draw) AS Drawn
    ,SUM(T.GF) AS GF    
    ,SUM(T.GA) AS GA
    ,SUM(T.GF) - SUM(T.GA) AS GD
    ,SUM(Won) * 3 + SUM(Draw) AS TotalPoints
FROM
    #LeagueTable t
GROUP BY t.Team
ORDER BY t.Team;
 









SELECT * FROM FootballMatch






















