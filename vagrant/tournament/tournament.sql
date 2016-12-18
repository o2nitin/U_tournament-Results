-- Deletes the database if it exists to avoid any errors 
DROP DATABASE IF EXISTS tournament; 

-- Create the database tournament 
CREATE DATABASE tournament;

-- Connect to the database 
\c tournament;

-- creating table for players
CREATE TABLE players (
        p_id serial PRIMARY KEY,
        name varchar (25) NOT NULL
);

-- Creating table matches
CREATE TABLE matches (
        m_id serial PRIMARY KEY,
        winner integer REFERENCES players(p_id) NOT NULL,
        loser integer REFERENCES players(p_id) NOT NULL
);

-- Create view allwins
CREATE VIEW allwins AS
 SELECT players.p_id,players.name, count(matches.winner) as wins 
 FROM players
 LEFT JOIN matches on players.p_id = matches.winner
 GROUP BY players.p_id;


--  creating view allmatches
CREATE VIEW allmatches as
 SELECT players.p_id,players.name, count(matches.winner) as matches 
 FROM players
 LEFT JOIN matches on players.p_id = matches.winner or players.p_id = matches.loser
 GROUP BY players.p_id;

-- creating view for team standings
CREATE VIEW standings AS
SELECT allwins.p_id, allwins.name,allwins.wins,allmatches.matches FROM allwins,allmatches
where  allm.p_id = allw.p_id
order by win DESC;
