--Выбор таблицы для секционирования:

--Билеты
select *
from tickets
limit 100;

select count(*)
from tickets;
--21 095 265
--Данных много, но отсутствуют поля, которые можно привязать к диапазонам для секционирования. 

--Рейсы
select *
from flights
limit 100;

select count(*)
from flights;
--135 571

--Посадочные талоны
select *
from boarding_passes
limit 100;

select count(*)
from boarding_passes;
--26 299 160
--Можно секционировать по времени посадки (boarding_time) или по ИД рейса (flight_id)

--Места:
select count(*)
from seats;
--1741

--Аэропорты:
select count(*)
from airports_data;
--5501

--Самолеты:
select count(*)
from airplanes_data;
--10

--Бронирование билетов
select count(*)
from bookings;
--9 706 657 записей

select *
from bookings
limit 100;
--Записей много, основные запросы будут по дате бронирования
--Можно секционировать по дате бронирования (book_date)

select date_trunc('month', book_date), count(*)
from bookings
group by 1;
--25 секций по 400 тыс. записей
------------------------------------------------------------------------------------------------------------------
--Секционирование:
--Создаю схему и новую таблицу, идентичную bookings в ней
drop schema if exists bookings_copy cascade;
create schema bookings_copy;

CREATE TABLE IF NOT EXISTS bookings_copy.bookings
(
    book_ref character(6) COLLATE pg_catalog."default" NOT NULL,
    book_date timestamp with time zone NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    CONSTRAINT bookings_pkey PRIMARY KEY (book_ref, book_date)
) PARTITION BY RANGE (book_date);

--Ключ секционирования обязательно нужно добавить в PRIMARY KEY 

--Создание секций:
DO
$$
DECLARE
    v_start_date	date;
    v_end_date		date;
    v_year			smallint;
    v_month			smallint;
    query           text;
BEGIN
    FOR v_start_date, v_end_date, v_year, v_month
    IN (
		select distinct (date_trunc('month', book_date))::date as start_date, 
			(date_trunc('month', book_date) + interval '1 month')::date as end_date,
			extract(year from book_date) as nyear, 
			extract(month from book_date) as nmonth
		from bookings.bookings
		order by (date_trunc('month', book_date))::date
        )
    LOOP
    
        query = format  ($frmt$
                        CREATE TABLE bookings_copy.bookings_%s_%s 
                        PARTITION OF bookings_copy.bookings
                        FOR VALUES FROM ('%s') TO ('%s');
                        $frmt$,
                        v_year, v_month, v_start_date, v_end_date);

        RAISE NOTICE '%', query;
        EXECUTE query;

    END LOOP;
END;
$$;

--Таблица для значений,  не входящих ни в один диапазон:
CREATE TABLE bookings_copy.bookings_other PARTITION OF bookings_copy.bookings DEFAULT;


--Перенос данных циклом с коммитом после каждого шага:

DO
$$
DECLARE
    v_month_date date;
BEGIN
    FOR v_month_date 
	IN (
		select date_trunc('month', book_date) as month_date
		from bookings
		group by 1
		)
    LOOP
        INSERT INTO bookings_copy.bookings (book_ref, book_date, total_amount)
        SELECT book_ref, book_date, total_amount
        FROM bookings.bookings
		WHERE date_trunc('month', book_date) = v_month_date;

        COMMIT;

        RAISE NOTICE '%', v_month_date;       
    END LOOP; 
END
$$;

--Проверяю, что все данные правильно распределены по секциям
DO
$$
DECLARE
    v_year			smallint;
    v_month			smallint;
    query           text;
	v_min_date		date; 
	v_max_date		date;
	v_count			integer;
BEGIN
    FOR v_year, v_month
    IN (
		select distinct extract(year from book_date) as nyear, 
			extract(month from book_date) as nmonth
		from bookings.bookings
		order by nyear, nmonth
        )
    LOOP    
         query = format( $frmt$
                        SELECT min(book_date), max(book_date), count(*) 
						FROM bookings_copy.bookings_%s_%s;
                        $frmt$,
                        v_year, v_month);
        EXECUTE query into v_min_date, v_max_date, v_count;
        RAISE NOTICE 'bookings_copy.bookings_%_%: %	%	%', v_year, v_month, v_min_date, v_max_date, v_count;
    END LOOP;
END;
$$;
------------------------------------------------------------------------------------------------------------------

--Проверяю, как секционирование повлияло на производительность запросов:
--1. По ключевому столбцу:
EXPLAIN ANALYSE
SELECT * FROM bookings_copy.bookings WHERE book_date BETWEEN '2026-03-01'::date and '2026-03-31'::date;
--Execution Time: 118.817 ms

EXPLAIN ANALYSE
SELECT * FROM bookings.bookings WHERE book_date BETWEEN '2026-03-01'::date and '2026-03-31'::date;
--Execution Time: 1012.319 ms
--Запрос к секционированной таблице по ключевому столбцу с использованием Sec Scan по одной секции выполнился в 10 раз быстрее, чем к несекционированной таблице. 

--Если создать индекс
CREATE INDEX idx_bookings_book_date ON bookings_copy.bookings USING btree (book_date);
--то время выполнения запроса по всем записям секции не изменится, все равно будет использоваться Sec Scan 
EXPLAIN ANALYSE
SELECT * FROM bookings_copy.bookings WHERE book_date BETWEEN '2026-03-01'::date and '2026-03-31'::date;
--Execution Time: 118.817 ms

--Index Scan будет использоваться, если условие запроса сократить до части записей секции:
EXPLAIN ANALYSE
SELECT * FROM bookings_copy.bookings WHERE book_date BETWEEN '2026-03-01'::date and '2026-03-10'::date;
--Execution Time: 47.852 ms

--2. По неключевому столбцу:
EXPLAIN ANALYSE
SELECT * FROM bookings_copy.bookings WHERE total_amount > 30000;
--Execution Time: 1760.456 ms

EXPLAIN ANALYSE
SELECT * FROM bookings.bookings WHERE total_amount > 30000;
--Execution Time: 1488.857 ms
--Запрос к секционированной таблице по неключевому столбцу выполнялся дольше, чем к несекционированной, т.к. использовался Sec Scan по всем секциям. 

------------------------------------------------------------------------------------------------------------------

--Тестирование секционирования:
--1. Добавление новых записей:
INSERT INTO bookings_copy.bookings (book_ref, book_date, total_amount)
values ('ABCDEF', '2026-05-12'::date, 20000),
('GHIJK', '2030-05-12'::date, 30000);

select *
from bookings_copy.bookings_2026_5
where book_ref = 'ABCDEF';

--"ABCDEF"	"2026-05-12 00:00:00+03"	20000.00

select *
from bookings_copy.bookings_other;

--"GHIJK "	"2030-05-12 00:00:00+03"	30000.00

--Новые записи попали в правильные секции

select *
from bookings_copy.bookings_2026_2
limit 100;

--2. Обновление:
--Поменяю дату бронирования AAEBE2 на месяц вперед:
update bookings_copy.bookings set book_date = book_date + interval '1 month'
where book_ref = 'AAEBE2';

select *
from bookings_copy.bookings_2026_2
where book_ref = 'AAEBE2';


select *
from bookings_copy.bookings_2026_3
where book_ref = 'AAEBE2';
--"AAEBE2"	"2026-03-18 04:08:53.324813+03"	7500.00

--Бронирование AAEBE2 перенеслось из секции bookings_copy.bookings_2026_2 в секцию bookings_copy.bookings_2026_3

--3. Удаление записи:
select *
from bookings_copy.bookings
limit 100;

delete 
from bookings_copy.bookings
where book_ref = '2EW1SQ';

select *
from bookings_copy.bookings
where book_ref = '2EW1SQ';

--Запись успешно удалена
