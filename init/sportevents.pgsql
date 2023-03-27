CREATE
OR REPLACE FUNCTION datediff (
    date_part VARCHAR(30),
    start_t TIMESTAMP,
    end_t TIMESTAMP
) RETURNS INT AS $diff$

  DECLARE
    years INT = 0;
    days INT = 0;
    hours INT = 0;
    minutes INT = 0;
  BEGIN

    years = DATE_PART('year', end_t) - DATE_PART('year', start_t);

    days = DATE_PART('day', DATE_TRUNC('day', end_t) - DATE_TRUNC('day', start_t));

    IF date_part IN ('day', 'days', 'd') THEN
      RETURN days;
    END IF;

    RETURN 0;
END;
$diff$ LANGUAGE plpgsql;

SET
    timezone = 'GMT-4';

create extension if not exists citext;

drop type if exists championship_stage cascade;

create type championship_stage as enum(
    'Group stage',
    '1/16',
    '1/8',
    'Quarter final',
    'Semi final',
    'Grand final'
);

drop type if exists discipline cascade;

create type discipline as enum(
    'Basketball',
    'Baseball',
    'Regbyball',
    'Cybersport',
    'Technopark'
);

drop type if exists player cascade;

create type player as (nickname citext, pos citext);

drop table if exists championships cascade;

create table if not exists
    championships (
        championship_id bigint primary key generated always as identity (
            start
            with
                1 increment by 1
        ),
        championship_name citext not null unique,
        championship_start_date date not null,
        championship_end_date date not null check (
            championship_end_date > championships.championship_start_date
        ),
        championship_disciplines discipline array not null,
        championship_stages championship_stage array not null
    );

insert into
    championships (
        championship_name,
        championship_start_date,
        championship_end_date,
        championship_disciplines,
        championship_stages
    )
values
    (
        'Technokubok',
        '10-10-2020',
        '12-12-2077',
        '{"Cybersport"}',
        '{"Group stage","Semi final","Grand final"}'
    ),
    (
        'World Cup 2030',
        '12-12-2021',
        '12-13-2023',
        '{"Cybersport"}',
        '{"Group stage","Semi final","Grand final"}'
    ),
    (
        'Wold Cup 3000',
        '10-10-2020',
        '10-10-3000',
        '{"Basketball","Baseball","Regbyball","Technopark"}',
        '{"1/16","1/8","Quarter final","Semi final","Grand final"}'
    ),
    (
        'Technopark SS 2021',
        '03-01-2021',
        '07-07-2021',
        '{"Cybersport"}',
        '{"Group stage","Grand final"}'
    ),
    (
        'Technopark FW 2021',
        '09-01-2021',
        '01-10-2022',
        '{"Cybersport"}',
        '{"Group stage","Grand final"}'
    ),
    (
        'Technopark SS 2022',
        '03-03-2022',
        '07-07-2022',
        '{"Cybersport"}',
        '{"Group stage","Grand final"}'
    ),
    (
        'Technopark FW 2022',
        '09-01-2022',
        '01-10-2023',
        '{"Cybersport"}',
        '{"Group stage","Grand final"}'
    );

select
    datediff (
        'days',
        championship_start_date,
        championship_end_date
    ),
    championship_name
from
    championships
where
    championship_name like 'Techno%';

--Команды
drop table if exists teams cascade;

create table if not exists
    teams (
        team_id bigint primary key generated always as identity (
            start
            with
                1 increment by 1
        ),
        team_name varchar(32) unique CHECK (teams.team_name ~ $$[A-Z]$$),
        team_founded_date date default now() not null check (team_founded_date < now()),
        team_stack player array not null
    );

insert into
    teams (team_name, team_founded_date, team_stack)
values
    (
        'Monkeys Legacy',
        '10-03-2019',
        ARRAY[
            '("Ilyagu", "Tarantool")'::player,
            '("4Mavrin2", "OpenCV")'::player,
            '("perlinleo", "Vuejs")'::player,
            '("semyon", "na zamene")'::player
        ]
    ),
    (
        'SaberDevs',
        '10-03-2019',
        ARRAY[
            '("Boriskoj", "Tarantool")'::player,
            '("Tr0ll3x", "Docker")'::player,
            '("M4x", "BoostBeast")'::player,
            '("vova_gold", "solo cookie boost")'::player
        ]
    ),
    (
        'Monkeys Senior',
        '01-01-2021',
        ARRAY[
            '("Ilyagu", "Lua")'::player,
            '("4Mavrin2", "Go")'::player,
            '("perlinleo", "TypeScript")'::player,
            '("vova_gold", "Go")'::player
        ]
    ),
    (
        'Kiru conspiracy',
        '01-01-2021',
        ARRAY[
            '("Ilyagu (evil twin)", "Redis")'::player,
            '("4Mavrin2 (evil twin)", "JavaScript")'::player,
            '("perlinleo (evil twin)", "Go")'::player,
            '("vova_gold (evil twin)", "JavaScript")'::player
        ]
    );

select
    *
from
    teams;

-- [23514] ERROR: new row for relation "teams" violates check constraint "teams_team_founded_date_check" Detail: Failing row contains (1, Kiru, 2025-10-10).
drop table if exists games cascade;

create table if not exists
    games (
        game_id bigint primary key generated always as identity (
            start
            with
                1 increment by 1
        ),
        game_start_time timestamp with time zone default now(),
        game_end_time timestamp with time zone default now() + (90 * interval '1 minute'),
        game_discipline discipline not null,
        game_stage championship_stage not null,
        game_team_host bigint not null,
        constraint fk_team_host foreign key (game_team_host) references teams (team_id),
        game_team_guest bigint not null,
        constraint fk_team_guest foreign key (game_team_guest) references teams (team_id),
        game_score int4 array default '{0,0}' check (array_length(game_score, 1) = 2),
        game_championship_id int not null,
        constraint fk_championship foreign key (game_championship_id) references championships (championship_id)
    );

insert into
    games
values
    (
        DEFAULT,
        DEFAULT,
        DEFAULT,
        'Cybersport',
        'Semi final',
        1,
        2,
        '{1,1}',
        4
    ),
    (
        DEFAULT,
        DEFAULT,
        DEFAULT,
        'Cybersport',
        'Semi final',
        2,
        1,
        '{1,3}',
        4
    ),
    (
        DEFAULT,
        DEFAULT,
        DEFAULT,
        'Cybersport',
        'Semi final',
        3,
        4,
        '{0,100}',
        7
    ),
    (
        DEFAULT,
        DEFAULT,
        DEFAULT,
        'Cybersport',
        'Semi final',
        3,
        4,
        '{1,10}',
        7
    );

select
    *
from
    games;