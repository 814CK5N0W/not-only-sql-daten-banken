CREATE KEYSPACE IF NOT EXISTS sport_event_db WITH REPLICATION = {
      'class' : 'SimpleStrategy', 'replication_factor' : 2 };

use sport_event_db;

create type if not exists score(
    team_a text,
    team_b text
);

drop table if exists teams;
create table teams (
    team_name text,
    team_id uuid,
    PRIMARY KEY (team_id)
);

insert into teams (team_name,team_id) VALUES ('Monkeys',uuid());
select * from teams;

-- truncate table championships;
drop table if exists championships;
create table championships (
    championship_id uuid,
    championship_name text,
    championship_start_date date,
    championship_end_date date,
    championship_discipline text,
    championship_stages text,
    primary key ( championship_name )
);

begin batch
insert into championships(championship_id, championship_name, championship_start_date, championship_end_date, championship_discipline, championship_stages) VALUES
                    (uuid(),'FA Cup','2022-10-10','2023-10-10','Football','Group Stage, Playoff');
insert into championships(championship_id, championship_name, championship_start_date, championship_end_date, championship_discipline, championship_stages) VALUES
                    (uuid(),'FA Cup','2023-10-10','2024-10-10','Football','Group Stage, Playoff');
insert into championships(championship_id, championship_name, championship_start_date, championship_end_date, championship_discipline, championship_stages) VALUES
                    (uuid(),'FA Cup','2024-10-10','2025-10-10','Football','Group Stage, Playoff');


apply batch;


select * from championships;

UPDATE championships SET championship_end_date='2024-10-10' WHERE championship_id=166b1527-05e8-428f-bd66-0323eb642393;
DELETE FROM championships where championship_id=166b1527-05e8-428f-bd66-0323eb642393;

SELECT * FROM championships WHERE championship_name='FA Cup' ALLOW FILTERING;

create materialized view fa_cups
as
select *
from championships
where championship_name = 'FA Cup' PRIMARY KEY ( championship_name );

select * from fa_cups;


create table games (
    game_id uuid,
    game_discipline text,
    game_stage text,
    game_team_host bigint,
    game_team_guest bigint,
    game_score score,
    game_championship_id bigint,
    primary key (game_id)
);



