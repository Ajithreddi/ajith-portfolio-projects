DROP DATABASE IF EXISTS ipl_data;
CREATE DATABASE ipl_data;
USE ipl_data;

SELECT 
    *
FROM
    matches;
SELECT 
    *
FROM
    deliveries;

-- 1.How many matches were played in total for each season where the toss winner chose to bat and won the match?

SELECT 
    season, COUNT(*)
FROM
    matches
WHERE
    toss_decision = 'bat'
        AND toss_winner = winner
GROUP BY season;

-- 2. What is the maximum winning margin (by runs) achieved by each winning team in seasons from 2015 to 2018, inclusive?

SELECT 
    winner, MAX(result_margin) AS max_result_margin, result
FROM
    matches
WHERE
    result = 'runs'
        AND season BETWEEN 2015 AND 2018
GROUP BY winner
ORDER BY max_result_margin DESC;

-- 3. What is the minimum winning margin (by wickets) for matches played in cities whose names start with 'M', grouped by the winning team?
SELECT 
    winner, MIN(result_margin) AS win_margin_wickets
FROM
    matches
WHERE
    result = 'wickets' AND city LIKE 'M%'
GROUP BY winner
ORDER BY win_margin_wickets;

SELECT 
    winner, MIN(result_margin) AS min_win_margin_wickets
FROM
    matches
WHERE
    result = 'wickets' AND city LIKE 'M%'
GROUP BY winner
ORDER BY min_win_margin_wickets ASC;
    
-- 4. Count the number of matches played in either 'Chennai' or 'Mumbai' across seasons 2019 and 2020/21, grouped by city.
SELECT 
    city, COUNT(*) noof_matches
FROM
    matches
WHERE
    city IN ('Chennai' , 'Mumbai')
        AND season BETWEEN '2019' AND '2020/21'
GROUP BY city;

-- 5. What is the maximum winning margin (by runs) for matches where the winning team's name starts with 'Royal Challengers' or 'Deccan', grouped by the winning team?
SELECT 
    winner, MAX(result_margin) AS max_win_margin_by_runs
FROM
    matches
WHERE
    result = 'runs'
        AND winner LIKE 'Royal Challengers%'
        OR winner LIKE 'Deccan%'
GROUP BY winner
ORDER BY max_win_margin_by_runs DESC;

-- 6. Calculate the total sum of the target_runs (first innings score) for matches won by batting first (result = 'runs') in seasons between 2010 and 2015, grouped by the winning team.

SELECT 
    winner, SUM(target_runs) AS total_target_runs
FROM
    matches
WHERE
    result = 'runs'
        AND season BETWEEN 2010 AND 2015
GROUP BY winner
ORDER BY total_target_runs DESC;

-- 7. What is the minimum winning margin (runs) for matches played in seasons from 2018 to 2021, inclusive, grouped by venue?

SELECT 
    venue, MIN(result_margin) AS min_result_margin_runs
FROM
    matches
WHERE
    result = 'runs'
        AND season BETWEEN 2018 AND 2021
GROUP BY venue
ORDER BY min_result_margin_runs;

-- 8.Count the number of distinct players of the match for matches that had a 'D/L' method used, grouped by season.
SELECT 
    *
FROM
    matches;
SELECT 
    season, COUNT(DISTINCT player_of_match) AS player_of_match
FROM
    matches
WHERE
    method = 'D/L'
GROUP BY season
ORDER BY season;

-- 9.What is the maximum winning margin (by wickets) for matches played in venues containing the word 'Stadium' or 'Academy', grouped by the winning team?
SELECT 
    winner, MAX(result_margin) AS max_result_margin
FROM
    matches
WHERE
    result = 'wickets'
        AND venue LIKE '%Stadium%'
        OR venue LIKE '%Academy%'
GROUP BY winner
ORDER BY max_result_margin DESC;

-- 10. Count the number of matches that ended in a 'tie' or 'no result' where either 'Kings XI Punjab' or 'Delhi Daredevils' (or 'Delhi Capitals') was one of the playing teams (team1 or team2), grouped by the result type.
SELECT 
    result, COUNT(*)
FROM
    matches
WHERE
    result IN ('tie' , 'no result')
        AND team1 IN ('Kings XI Punjab' , 'Delhi Daredevils', 'Delhi Capitals')
        OR team2 IN ('Kings XI Punjab' , 'Delhi Daredevils', 'Delhi Capitals')
GROUP BY result;

SELECT 
    *
FROM
    matches;
-- 11. Find all matches where the winning result_margin (by runs) was greater than the average result_margin for all matches won by runs.

SELECT 
    *
FROM
    matches
WHERE
    result = 'runs'
        AND result_margin > (SELECT 
            AVG(result_margin)
        FROM
            matches
        WHERE
            result = 'runs');
            
-- 12. List the teams that won a match with a result_margin (by runs) greater than the maximum result_margin (by runs) achieved by 'Chennai Super Kings' in any of their wins.

SELECT 
    winner
FROM
    matches
WHERE
    result = 'runs'
        AND result_margin > (SELECT 
            MAX(result_margin)
        FROM
            matches
        WHERE
            result = 'runs'
                AND winner = 'Chennai Super Kings');
                
-- 13. Count the number of matches played in cities that have hosted at least one 'Final' match, grouped by city.

SELECT 
    city, COUNT(*) AS no_of_matches, match_type
FROM
    matches
WHERE
    match_type = 'Final'
GROUP BY city;

-- 14. Find the total number of matches won by teams that have a player_of_match whose name starts with 'J'.

SELECT 
    COUNT(*) AS Total_matches_won, winner
FROM
    matches
WHERE
    player_of_match LIKE 'J%'
GROUP BY winner
ORDER BY Total_matches_won DESC;

-- 15.  Count the number of matches where the toss winner was not in the list of teams that have won any match by a result_margin (wickets) less than 2.

SELECT 
    COUNT(*)
FROM
    matches
WHERE
    toss_winner NOT IN (SELECT 
            DISTINCTS winner
        FROM
            matches
        WHERE
            result = 'wickets' AND result_margin < 2);

-- 16. For every match where "Royal Challengers Bangalore" was the winner, list the match_id, the date of the match, 
-- and the total batsman_runs scored by the batting_team in the first inning of that match.

SELECT 
    d.match_id, m.date, SUM(d.batsman_runs) AS total_runs
FROM
    matches m
        JOIN
    deliveries d ON m.id = d.match_id
WHERE
    m.winner = 'Royal Challengers Bangalore'
        AND d.inning = 1
GROUP BY d.match_id , m.date;

-- 17. List the match_id, batter, and bowler for deliveries where the batting_team was 'Chennai Super Kings', 
-- the bowling_team was 'Mumbai Indians', and the batsman_runs scored on that delivery were '6'.

SELECT 
    d.match_id, d.batter, d.bowler, batsman_runs
FROM
    deliveries d
        JOIN
    matches m ON d.match_id = m.id
WHERE
    d.batting_team = 'Chennai Super Kings'
        AND d.bowling_team = 'Mumbai Indians'
        AND d.ball = 6;

-- 18. List all matches (id, date, venue) from the matches table. 
-- For each match, also show the name of the player_dismissed if the dismissal_kind was 'bowled' in that match. 
-- If multiple 'bowled' dismissals occurred, list them. If no 'bowled' dismissal occurred, the dismissal details should be absent (NULL).

SELECT 
    m.id,
    m.date,
    m.venue,
    GROUP_CONCAT(d.player_dismissed) AS players_dismissed
FROM
    matches m
        LEFT JOIN
    deliveries d ON m.id = d.match_id
        AND dismissal_kind = 'bowled'
GROUP BY m.id , m.date , m.venue;

-- 19. List unique player names. For match_id = '335982', show the player's name if they were the batter on any delivery, 
-- and separately show their name if they were the player_of_match. 
-- A player could be both, one, or neither in these roles for this specific match.

SELECT DISTINCT
    d.batter, m.player_of_match
FROM
    matches m
        JOIN
    deliveries d ON m.id = d.match_id
WHERE
    match_id = '335982';

SELECT DISTINCT
    batter AS player_name
FROM
    deliveries
WHERE
    match_id = '335982' 
UNION SELECT DISTINCT
    player_of_match AS player_name
FROM
    matches
WHERE
    id = '335982';

-- 20. List all unique city names where a match was played in the '2019' season OR where 'MS Dhoni' was the player_of_match.

SELECT DISTINCT
    city, player_of_match, season
FROM
    matches
WHERE
    season = '2019'
        OR player_of_match = 'MS Dhoni';

-- 21. List all match_ids where 'Kolkata Knight Riders' was team1, and then list all match_ids where 'Kolkata Knight Riders' was team2. 
-- Include duplicates if a hypothetical match had them as both (though not possible in this dataset).

SELECT 
    d.match_id
FROM
    deliveries d
        JOIN
    matches m ON d.match_id = m.id
WHERE
    m.team1 = 'Kolkata Knight Riders' 
UNION ALL SELECT 
    d.match_id
FROM
    deliveries d
        JOIN
    matches m ON d.match_id = m.id
WHERE
    m.team2 = 'Kolkata Knight Riders';

-- 22. For each batting_team in matches played in the '2020/21' season, 
-- calculate the total extra_runs they benefited from (conceded by the opposition).
SELECT 
    d.batting_team, SUM(d.extra_runs) AS extra_runs
FROM
    deliveries d
        LEFT JOIN
    matches m ON d.match_id = m.id
WHERE
    m.season = '2020/21'
GROUP BY d.batting_team
ORDER BY extra_runs DESC;

-- 23.List the match_id, date, and venue for all matches 
-- where the toss_winner was one of the teams that also won a match in 'Sharjah'.

SELECT 
    id AS match_id, date, venue
FROM
    matches
WHERE
    toss_winner = winner
        AND venue LIKE '%Sharjah%';

-- 24.Find the bowling_team and the total total_runs conceded by them in matches where the venue was 'Eden Gardens'. 
-- Only show teams that conceded more than 1000 runs in total at this venue.

SELECT 
    bowling_team, SUM(total_runs) AS total_runs
FROM
    deliveries d
        JOIN
    matches m ON m.id = d.match_id
WHERE
    m.venue = 'Eden Gardens'
GROUP BY bowling_team
HAVING total_runs > 1000
ORDER BY total_runs DESC;


-- 25.Create a combined list showing:
-- (1) match_id and batter for all 'caught' dismissals.
-- (2) match_id and player_dismissed (aliased as batter) for all 'bowled' dismissals.

SELECT 
    match_id, batter, dismissal_kind
FROM
    deliveries
WHERE
    dismissal_kind = 'caught' 
UNION ALL SELECT 
    match_id, player_dismissed AS batter, dismissal_kind
FROM
    deliveries
WHERE
    dismissal_kind = 'bowled';



-- (Bonus question) Top 4 scorer in 2019 
SELECT 
    m.season, d.batter, SUM(d.batsman_runs) AS total_runs
FROM
    deliveries d
        JOIN
    matches m ON d.match_id = m.id
WHERE
    m.season = '2019'
GROUP BY d.batter , m.season
ORDER BY total_runs DESC
LIMIT 1 OFFSET 3;

SELECT 
    *
FROM
    deliveries;
SELECT 
    *
FROM
    matches; 




