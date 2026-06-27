## 1. Создать индекс к какой-либо из таблиц БД
Создаю индекс к таблице boarding_passes на поле flight_id.

Таблица boarding_passes:
```
ticket_no     | flight_id | seat_no | boarding_no | boarding_time 
--------------+-----------+---------+-------------+------------------------------
0005432007794 |     39    |   36E   |     324     | 2025-10-01 09:53:03.887374+03
0005432003788 |     39    |   35F   |      50     | 2025-10-01 09:39:49.651496+03
0005432012756 |     39    |    5G   |     150     | 2025-10-01 09:44:41.55811+03
0005432003895 |     39    |   26B   |     165     | 2025-10-01 09:45:24.74352+03
0005432018476 |     39    |   29K   |      81     | 2025-10-01 09:41:17.913314+03
0005441785893 |   59246   |   11B   |      47     | 2026-09-01 03:00:04.05653+03
0005432033689 |     39    |   38B   |     152     | 2025-10-01 09:44:44.52662+03
0005432009302 |     39    |   13F   |     397     | 2025-10-01 09:56:35.315773+03
     ...      |    ...    |   ...   |     ...     |            ...
```
Создание индекса:
```sql
create index idx_boarding_passes_flight_id
on boarding_passes(flight_id);
```
План запроса:
```sql
EXPLAIN
select *
from boarding_passes
where flight_id = 1
```
Результат:
```
                          QUERY PLAN
-----------------------------------------------------------------------------------
Index Scan using idx_boarding_passes_flight_id on boarding_passes  (cost=0.44..16.64 rows=347 width=33)
   Index Cond: (flight_id = 1)
```

## 2. Реализовать индекс для полнотекстового поиска
Создаю индекс к таблице tickets на ФИО пассажира:
```sql
create index idx_tickets_passenger_name
on tickets
using gin (to_tsvector('english', passenger_name));
```
План запроса по поиску всех пассажиров с именем Maria:
```sql
EXPLAIN
select *
from tickets
where to_tsvector('english', passenger_name) @@ 'Maria'
```
Результат:
```
                          QUERY PLAN
-----------------------------------------------------------------------------------
Gather  (cost=1727.57..204436.19 rows=105476 width=52)
  Workers Planned: 2
  ->  Parallel Bitmap Heap Scan on tickets  (cost=727.57..192888.59 rows=43948 width=52)
        Recheck Cond: (to_tsvector('english'::regconfig, passenger_name) @@ '''Maria'''::tsquery)
        ->  Bitmap Index Scan on idx_tickets_passenger_name  (cost=0.00..701.20 rows=105476 width=0)
              Index Cond: (to_tsvector('english'::regconfig, passenger_name) @@ '''Maria'''::tsquery)
JIT:
  Functions: 2
  Options: Inlining false, Optimization false, Expressions true, Deforming true
```

## 3. Реализовать индекс на часть таблицы или индекс на поле с функцией
Создаю индекс к таблице boarding_passes на номер ряда, который определяется по номеру места seat_no:
```sql
create index idx_boarding_passes_func_seat_no
on boarding_passes(substr(seat_no, 1, length(seat_no) - 1));
```
План запроса:
```sql
EXPLAIN
select *
from boarding_passes
where substr(seat_no, 1, length(seat_no) - 1) = '19'	
```
Результат:
```
                          QUERY PLAN
-----------------------------------------------------------------------------------
Bitmap Heap Scan on boarding_passes  (cost=6707.65..237848.07 rows=602221 width=33)
  Recheck Cond: (substr(seat_no, 1, (length(seat_no) - 1)) = '19'::text)
  ->  Bitmap Index Scan on idx_boarding_passes_func_seat_no  (cost=0.00..6557.10 rows=602221 width=0)
        Index Cond: (substr(seat_no, 1, (length(seat_no) - 1)) = '19'::text)
JIT:
  Functions: 2
  Options: Inlining false, Optimization false, Expressions true, Deforming true
```

## 4. Создать индекс на несколько полей
Создаю индекс к таблице boarding_passes на поля flight_id и seat_no:
```sql
create index idx_boarding_passes_flight_id_seat_no
on boarding_passes(flight_id, seat_no);
```
Запрос:
```sql
EXPLAIN
select *
from boarding_passes
where flight_id = 1
	and seat_no like '19%'
```
Результат:
```
                          QUERY PLAN
-----------------------------------------------------------------------------------
Index Scan using idx_boarding_passes_flight_id on boarding_passes  (cost=0.44..17.60 rows=8 width=33)
  Index Cond: (flight_id = 1)
  Filter: (seat_no ~~ '19%'::text)
```
Видно, что использовался индекс на одно поле - flight_id. 
Чтобы запрос использовал индекс на два поля, меняю условие:
```sql
EXPLAIN
select *
from boarding_passes
where flight_id = 1
	and seat_no = '19A'
```
Результат:
```
                          QUERY PLAN
-----------------------------------------------------------------------------------
Index Scan using idx_boarding_passes_flight_id_seat_no on boarding_passes  (cost=0.44..8.46 rows=1 width=33)
  Index Cond: ((flight_id = 1) AND (seat_no = '19A'::text))
```
Теперь используется индекс на два поля - idx_boarding_passes_flight_id_seat_no.




