create keyspace if not exists sport_event_db with replication = {
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
    team_members_count int,
    PRIMARY KEY (team_name,team_members_count)
);

begin batch
insert into teams (team_name,team_id,team_members_count) VALUES ('Monkeys',uuid(),1);
insert into teams (team_name,team_id,team_members_count) VALUES ('Monkeys Senior',uuid(),2);
insert into teams (team_name,team_id,team_members_count) VALUES ('Monkeys Gosu',uuid(),3);
insert into teams (team_name,team_id,team_members_count) VALUES ('Monkeys Goku',uuid(),4);
insert into teams (team_name,team_id,team_members_count) VALUES ('Monkeys Goku',uuid(),10);
insert into teams (team_name,team_id,team_members_count) VALUES ('Monkeys Goku',uuid(),10);
insert into teams (team_name,team_id,team_members_count) VALUES ('Monkeys Goku',uuid(),11);
insert into teams (team_name,team_id,team_members_count) VALUES ('Monkeys Goku',uuid(),12);
insert into teams (team_name,team_id,team_members_count) VALUES ('Monkeys Goku',uuid(),13);
apply batch;

select * from teams;
select min(team_members_count),team_name from teams;
select cast(team_members_count as double) from teams;


select * from teams where team_name='Monkeys Goku' order by team_members_count DESC;


-- truncate table championships;
drop materialized view if exists fa_cups;
drop table if exists championships;
create table championships (
    championship_id uuid,
    championship_name text,
    championship_start_date date,
    championship_end_date date,
    championship_discipline text,
    championship_stages text,
    primary key ( championship_stages,championship_id )
);

begin batch
insert into championships(championship_id, championship_name, championship_start_date, championship_end_date, championship_discipline, championship_stages) VALUES
                    (uuid(),'FA Cup','2022-10-10','2023-10-10','Football','Group Stage, Playoff');
insert into championships(championship_id, championship_name, championship_start_date, championship_end_date, championship_discipline, championship_stages) VALUES
                    (uuid(),'FA Cup 2','2023-10-10','2024-10-10','Football','Group Stage, Playoff');
insert into championships(championship_id, championship_name, championship_start_date, championship_end_date, championship_discipline, championship_stages) VALUES
                    (uuid(),'FA Cup 3','2024-10-10','2025-10-10','Football','Group Stage, Playoff');


apply batch;


select * from championships;

-- UPDATE championships SET championship_end_date='2024-10-10';
-- DELETE FROM championships where championship_id=166b1527-05e8-428f-bd66-0323eb642393;

SELECT * FROM championships WHERE championship_name='FA Cup' ALLOW FILTERING;

create materialized view fa_cups
as
select *
from championships
where championship_stages is not null and championship_name is not null and championship_id is not null PRIMARY KEY ( championship_id,championship_stages );

create index ix_names on sport_event_db.championships(championship_start_date);

select * from fa_cups;


drop table if exists game;
create table if not exists games (
    game_id uuid,
    game_discipline text,
    game_stage text,
    game_team_host bigint,
    game_team_guest bigint,
    game_score score,
    game_championship_id bigint,
    primary key ((game_id,game_discipline))
) WITH default_time_to_live = 120 and clustering order by (game_discipline desc);


begin batch
insert into games(game_id, game_discipline, game_stage, game_team_host, game_team_guest, game_score, game_championship_id)
VALUES (uuid(),'Football','GroupStage',1,1,{team_a: '1 Goal',team_b: '0 Goals'},1);

insert into games(game_id, game_discipline, game_stage, game_team_host, game_team_guest, game_score, game_championship_id)
VALUES (uuid(),'Football','GroupStage',1,1,{team_a: '3 Goals',team_b: '0 Goals'},1);

insert into games(game_id, game_discipline, game_stage, game_team_host, game_team_guest, game_score, game_championship_id)
VALUES (uuid(),'Basketball','GroupStage',1,1,{team_a: '1 Point',team_b: '0 Points'},1);

insert into games(game_id, game_discipline, game_stage, game_team_host, game_team_guest, game_score, game_championship_id)
VALUES (uuid(),'Hockey','GroupStage',1,1,{team_a: '30 Points',team_b: '0 Points'},1) using ttl 15;
apply batch;

select * from games;

select * from games where game_discipline IN ('Football') allow filtering;

select * from games;

