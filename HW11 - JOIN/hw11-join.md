## 1. Структура таблиц
```sql
CREATE TABLE IF NOT EXISTS contract (
    id integer NOT NULL,
    sign_date date,
    selfnumber text,
    status integer,
    id_juridical integer,
    CONSTRAINT contract_pkey PRIMARY KEY (id),
    CONSTRAINT contract_id_juridical_fkey FOREIGN KEY (id_juridical)
        REFERENCES registr.juridical (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS juridical (
    id integer NOT NULL,
    name text,
    inn text,
    id_juridical_type integer,
    CONSTRAINT juridical_pkey PRIMARY KEY (id),
    CONSTRAINT contract_id_juridical_fkey FOREIGN KEY (id_juridical)
        REFERENCES registr.juridical (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS juridical_type (
    id integer NOT NULL,
    name text,
    CONSTRAINT juridical_type_pkey PRIMARY KEY (id)
);
```
## 2. Реализовать прямое соединение двух или более таблиц
```sql
explain select *
from contract c
join juridical j on j.id = c.id_juridical
where c.sign_date >= '2020-01-01'::date
```
Выбраны все договоры, заключенные с 2020 года, и юридические лица по ним. 
Оптимизатор выбрал соединение хэшированием _Hash Join_. Сначала был выбран весь набор строк из таблицы juridical (3368 строки) и построена хэш-таблица. Затем Hash Join обращается ко второму дочернему узлу (Seq Scan on contract c) и соединяет строки, постепенно возвращая полученные результаты. 
```
Hash Join  (cost=383.78..838.02 rows=2311 width=1081)
  Hash Cond: (c.id_juridical = j.id)
  ->  Seq Scan on contract c  (cost=0.00..448.18 rows=2311 width=348)
        Filter: (sign_date >= '2020-01-01'::date)
  ->  Hash  (cost=341.68..341.68 rows=3368 width=733)
        ->  Seq Scan on juridical j  (cost=0.00..341.68 rows=3368 width=733)
```
## 3. Реализовать левостороннее (или правостороннее) соединение двух или более таблиц
```sql
explain select *
from juridical j
left join contract c on j.id = c.id_juridical
```
Выбраны все юридические лица и их договоры. Если с ЮЛ не заключались договоры, то в соответствующей строке в колонках из правой таблицы будут стоять null. Если договоров несколько, то в соответствующих строках значения из левой таблицы будут дублироваться. 
```
Hash Right Join  (cost=383.78..832.99 rows=8174 width=1081)
  Hash Cond: (c.id_juridical = j.id)
  ->  Seq Scan on contract c  (cost=0.00..427.74 rows=8174 width=348)
  ->  Hash  (cost=341.68..341.68 rows=3368 width=733)
        ->  Seq Scan on juridical j  (cost=0.00..341.68 rows=3368 width=733)
```
Здесь также было выполнено соединение хэшированием _Hash Join_. Но в результирующем наборе больше строк, чем в п.3, т.к. нет условия, ограничивающего выбор. 

## 4.Реализовать кросс соединение двух или более таблиц
```sql
explain select *
from juridical j
cross join contract c 
```
Каждая строка из таблицы juridical соединена с каждой строкой из таблицы contract. В результирующем наборе данных 27530032 строк. 
```
Nested Loop  (cost=0.00..344903.24 rows=27530032 width=1081)
  ->  Seq Scan on contract c  (cost=0.00..427.74 rows=8174 width=348)
  ->  Materialize  (cost=0.00..358.52 rows=3368 width=733)
        ->  Seq Scan on juridical j  (cost=0.00..341.68 rows=3368 width=733)
```
Соединение выполнено с помощью вложенного цикла _Nested Loop_. Для каждой строки набора Seq Scan on contract c выдаются все строки из набора Seq Scan on juridical j. 

## 5.Реализовать полное соединение двух или более таблиц
```
explain select 
from juridical j
full join contract c on j.id = c.id_juridical
```
Здесь, как в п.3, выбраны все юридические лица и их договоры. Если с ЮЛ не заключались договоры, то в соответствующей строке в колонках из правой таблицы будут стоять null. Также добавлены все договоры, по которым не указано юридическое лицо. Для соответствующей строки в колонках из левой таблицы будут стоять null. 
```
Hash Full Join  (cost=383.78..832.99 rows=8174 width=1081)
  Hash Cond: (c.id_juridical = j.id)
  ->  Seq Scan on contract c  (cost=0.00..427.74 rows=8174 width=348)
  ->  Hash  (cost=341.68..341.68 rows=3368 width=733)
        ->  Seq Scan on juridical j  (cost=0.00..341.68 rows=3368 width=733)
```
Соединение также выполнено с помощью хэширования. 

## 6.Реализовать запрос, в котором будут использованы разные типы соединений
```sql
explain select *
from juridical j
join juridical_type jt on jt.id = j.id_juridical_type
left join contract c on j.id = c.id_juridical
```
Выбраны все юридические лица (juridical). Для каждого указан тип (juridical_type). Для тех ЮЛ, с которыми есть договоры, указаны договоры. Если договора нет, то в соответствующих колонках указаны значения null. 

```
Hash Join  (cost=384.89..873.75 rows=8174 width=1117)
  Hash Cond: (j.id_juridical_type = jt.id)
  ->  Hash Right Join  (cost=383.78..832.99 rows=8174 width=1081)
        Hash Cond: (c.id_juridical = j.id)
        ->  Seq Scan on contract c  (cost=0.00..427.74 rows=8174 width=348)
        ->  Hash  (cost=341.68..341.68 rows=3368 width=733)
              ->  Seq Scan on juridical j  (cost=0.00..341.68 rows=3368 width=733)
  ->  Hash  (cost=1.05..1.05 rows=5 width=36)
        ->  Seq Scan on juridical_type jt  (cost=0.00..1.05 rows=5 width=36)
```        

Строятся две хеш-таблицы: одна - по таблице juridical, вторая - по таблице juridical_type. Сначала соединяются юридические лица (juridical) и договоры (contract). Затем получившийся набор строк соединяется с типами (juridical_type).


