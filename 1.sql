
--  0000
-- 00  00
-- 00  00
-- 00  00
--  0000
-- Через PgAdmin [3] соединиться с PostgreSQL [2] и создать базу данных. В
-- БД создать две-три связанные таблицы по теме, выданной преподавателем.
-- Открыть таблицы на редактирование и заполнить тестовыми данными.


drop table if exists wiki_links cascade;
create table if not exists wiki_links (
    wiki_link_id bigserial primary key,
    page_from bigint references page(page_id),
    page_to bigint references page(page_id)
);

drop table if exists page cascade;
create table page (
    page_id bigserial primary key,
    page_name varchar(32) unique,
    page_description citext,
    page_added timestamp default NOW()
);

insert into wiki_links values (1,1);
insert into page values (DEFAULT,'imya11','des22c',DEFAULT);

select * from wiki_links;
select * from page;

-- 1111
--   11
--   11
--   11
-- 111111
-- Создать скалярную функцию. Вызвать функцию из окна запроса.

CREATE OR REPLACE FUNCTION set_int_var(new_int integer)
RETURNS integer AS
$$
DECLARE
var_int integer;
BEGIN
var_int := new_int/2;
RETURN var_int;
END
$$
LANGUAGE plpgsql;
select set_int_var(10);

--  2222
-- 22  22
--    22
--   22
-- 222222
-- Создать табличную функцию (inline). Вызвать функцию из окна запроса.

CREATE OR REPLACE FUNCTION get_page_by_id (id int)
RETURNS TABLE(name varchar(32), product varchar) AS $$
 SELECT page_name,page_description FROM page where page.page_id=$1;
$$ LANGUAGE SQL;
select * from get_page_by_id(2);

--  3333
-- 33  33
--    333
-- 33  33
--  3333
-- Создать табличную функцию (multi-statement). Продемонстрировать
-- наполнение результирующего множества записей. Вызвать функцию из окна
-- запроса.
CREATE OR REPLACE FUNCTION get_pages_smaller_than_id (id int)
RETURNS TABLE(name varchar(32), product varchar) AS $$
 SELECT (page).page_name,(page).page_description FROM page where not page_id=id;
$$ LANGUAGE SQL;
select * from get_pages_bigger_than_id(3);


-- 44  44
-- 44  44
-- 444444
--     44
--     44
-- Создать хранимую процедуру, содержащую запросы, вызов и перехват
-- исключений. Вызвать процедуру из окна запроса. Проверить перехват и
-- создание исключений

create or replace procedure link_pages(
    page_from_id int,
    page_to_id int,
    link_id int
)
language plpgsql
as $$
    begin
        update wiki_links
        set page_from = page_from_id
        where wiki_link_id = link_id;


        update wiki_links
        set page_to = page_to_id
        where wiki_link_id = link_id;
exception
    when no_data_found  then
        raise exception 'link % not found', link_id;
end;$$;

call link_pages(1,1,1);


-- 555555
-- 55
-- 55555
--     55
-- 55555
-- Продемонстрировать в функциях и процедурах работу условных операторов
-- и выполнение динамического запроса.
CREATE OR REPLACE FUNCTION get_pages_smaller_than_id_dynamic (id int)
RETURNS TABLE(name varchar(32), product varchar) AS $$
 BEGIN
    EXECUTE 'SELECT * from pages where id=%1', id
 END
$$ LANGUAGE SQL;
select * from get_pages_bigger_than_id(3);

--  6666
-- 66
-- 66666
-- 66  66
--  6666
-- Продемонстрировать выполнение рекурсивного запроса.
-- 777777
--    77
--   77
--  77
-- 77

-- Продемонстрировать выполнение запроса на получение первых 3-х записей
-- из результата (limit). Продемонстрировать выполнение запроса на
-- добавление/изменение данных с отображением измененных строк
-- (returning).

--  8888
-- 88  88
--  8888
-- 88  88
--  8888

-- Продемонстрировать выполнение функций row_number(), Rank(),
-- dense_rank(), ntile(4).


--  9999
-- 99  99
--  99999
--     99
--  9999
-- Создать функцию, работающую с курсором. Вызвать функцию из окна
-- запроса

--
-- Продемонстрировать в функциях и процедурах обращение к встроенным и
-- системным функциям (строковые, работа с диском, работа со сложными
-- типами и т.д.)


-- 1111
--   11
--   11
--   11
-- 111111

-- 000000
-- 00  00
-- 00  00
-- 00  00
-- 000000



