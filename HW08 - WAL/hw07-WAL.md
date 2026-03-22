## Настройте выполнение контрольной точки раз в 30 секунд.
```sql
alter system set checkpoint_timeout = '30s';
select pg_reload_conf();
show checkpoint_timeout;
```
"checkpoint_timeout"
"30s"
## 10 минут c помощью утилиты pgbench подавайте нагрузку.
```sh
pgbench -i postgres
pgbench -c 2 -j 1 -P 10 -T 600 postgres
```
```sh
postgres@elena-VirtualBox:/mnt/Documents$ pgbench  -c 2 -j 1 -P 10 -T 600 postgres
pgbench (18.2 (Ubuntu 18.2-1.pgdg24.04+1))
starting vacuum...end.
progress: 10.0 s, 376.4 tps, lat 5.304 ms stddev 2.033, 0 failed
progress: 20.0 s, 387.1 tps, lat 5.165 ms stddev 1.842, 0 failed
progress: 30.0 s, 388.1 tps, lat 5.152 ms stddev 1.412, 0 failed
progress: 40.0 s, 391.7 tps, lat 5.105 ms stddev 1.693, 0 failed
progress: 50.0 s, 397.8 tps, lat 5.026 ms stddev 1.362, 0 failed
progress: 60.0 s, 384.1 tps, lat 5.206 ms stddev 2.302, 0 failed
progress: 70.0 s, 385.9 tps, lat 5.180 ms stddev 1.987, 0 failed
progress: 80.0 s, 398.0 tps, lat 5.024 ms stddev 1.411, 0 failed
progress: 90.0 s, 385.2 tps, lat 5.191 ms stddev 2.165, 0 failed
progress: 100.0 s, 374.2 tps, lat 5.342 ms stddev 1.887, 0 failed
progress: 110.0 s, 365.7 tps, lat 5.466 ms stddev 2.309, 0 failed
progress: 120.0 s, 361.0 tps, lat 5.539 ms stddev 3.011, 0 failed
progress: 130.0 s, 389.8 tps, lat 5.129 ms stddev 1.619, 0 failed
progress: 140.0 s, 396.5 tps, lat 5.043 ms stddev 1.379, 0 failed
progress: 150.0 s, 367.2 tps, lat 5.444 ms stddev 2.572, 0 failed
progress: 160.0 s, 376.1 tps, lat 5.316 ms stddev 1.961, 0 failed
progress: 170.0 s, 375.5 tps, lat 5.323 ms stddev 2.606, 0 failed
progress: 180.0 s, 371.6 tps, lat 5.380 ms stddev 1.748, 0 failed
progress: 190.0 s, 385.4 tps, lat 5.187 ms stddev 1.727, 0 failed
progress: 200.0 s, 374.7 tps, lat 5.333 ms stddev 1.743, 0 failed
progress: 210.0 s, 369.3 tps, lat 5.414 ms stddev 2.014, 0 failed
progress: 220.0 s, 380.2 tps, lat 5.259 ms stddev 1.958, 0 failed
progress: 230.0 s, 386.1 tps, lat 5.178 ms stddev 1.479, 0 failed
progress: 240.0 s, 368.1 tps, lat 5.429 ms stddev 2.096, 0 failed
progress: 250.0 s, 386.1 tps, lat 5.178 ms stddev 2.107, 0 failed
progress: 260.0 s, 376.0 tps, lat 5.316 ms stddev 1.815, 0 failed
progress: 270.0 s, 365.7 tps, lat 5.466 ms stddev 1.833, 0 failed
progress: 280.0 s, 354.2 tps, lat 5.643 ms stddev 2.349, 0 failed
progress: 290.0 s, 349.8 tps, lat 5.715 ms stddev 2.225, 0 failed
progress: 300.0 s, 351.3 tps, lat 5.691 ms stddev 2.315, 0 failed
progress: 310.0 s, 353.7 tps, lat 5.635 ms stddev 3.323, 0 failed
progress: 320.0 s, 384.3 tps, lat 5.200 ms stddev 1.735, 0 failed
progress: 330.0 s, 358.6 tps, lat 5.561 ms stddev 2.093, 0 failed
progress: 340.0 s, 382.9 tps, lat 5.218 ms stddev 1.738, 0 failed
progress: 350.0 s, 384.9 tps, lat 5.191 ms stddev 2.090, 0 failed
progress: 360.0 s, 341.2 tps, lat 5.858 ms stddev 10.936, 0 failed
progress: 370.0 s, 383.5 tps, lat 5.213 ms stddev 2.071, 0 failed
progress: 380.0 s, 402.2 tps, lat 4.971 ms stddev 1.612, 0 failed
progress: 390.0 s, 365.7 tps, lat 5.466 ms stddev 2.018, 0 failed
progress: 400.0 s, 371.3 tps, lat 5.384 ms stddev 2.255, 0 failed
progress: 410.0 s, 390.0 tps, lat 5.128 ms stddev 1.860, 0 failed
progress: 420.0 s, 381.5 tps, lat 5.236 ms stddev 1.983, 0 failed
progress: 430.0 s, 392.3 tps, lat 5.098 ms stddev 1.647, 0 failed
progress: 440.0 s, 385.9 tps, lat 5.182 ms stddev 2.007, 0 failed
progress: 450.0 s, 389.8 tps, lat 5.127 ms stddev 1.729, 0 failed
progress: 460.0 s, 401.1 tps, lat 4.987 ms stddev 1.553, 0 failed
progress: 470.0 s, 385.1 tps, lat 5.190 ms stddev 1.688, 0 failed
progress: 480.0 s, 390.4 tps, lat 5.121 ms stddev 2.081, 0 failed
progress: 490.0 s, 390.4 tps, lat 5.121 ms stddev 1.932, 0 failed
progress: 500.0 s, 391.2 tps, lat 5.111 ms stddev 1.730, 0 failed
progress: 510.0 s, 396.8 tps, lat 5.038 ms stddev 1.508, 0 failed
progress: 520.0 s, 376.1 tps, lat 5.312 ms stddev 1.782, 0 failed
progress: 530.0 s, 384.7 tps, lat 5.194 ms stddev 1.698, 0 failed
progress: 540.0 s, 381.2 tps, lat 5.244 ms stddev 2.309, 0 failed
progress: 550.0 s, 386.9 tps, lat 5.168 ms stddev 1.663, 0 failed
progress: 560.0 s, 395.2 tps, lat 5.058 ms stddev 1.459, 0 failed
progress: 570.0 s, 389.2 tps, lat 5.137 ms stddev 1.730, 0 failed
progress: 580.0 s, 385.8 tps, lat 5.184 ms stddev 2.361, 0 failed
progress: 590.0 s, 236.6 tps, lat 8.449 ms stddev 11.685, 0 failed
progress: 600.0 s, 382.5 tps, lat 5.225 ms stddev 1.931, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 2
number of threads: 1
maximum number of tries: 1
duration: 600 s
number of transactions actually processed: 226600
number of failed transactions: 0 (0.000%)
latency average = 5.293 ms
latency stddev = 2.672 ms
initial connection time = 12.869 ms
tps = 377.671839 (without initial connection time)
```
## Измерьте, какой объем журнальных файлов был сгенерирован за это время. Оцените, какой объем приходится в среднем на одну контрольную точку.
Смотрю номер записи в журнале до и после запуска pgbench:
```sql
SELECT pg_current_wal_insert_lsn(); 
```
Перед запуском lsn = 0/CFF69250
После запуска lsn = 0/E875F2E8
```sql
SELECT '0/E875F2E8'::pg_lsn - '0/CFF69250'::pg_lsn;
```
411000984 ~ 392 МБ - размер журнальной записи
За 10 минут должно было пройти 20 контрольных точек. 
Значит, на одну контрольную точку приходится примерно:
392 МБ / 20 = 19,6 МБ

## Проверьте данные статистики: все ли контрольные точки выполнялись точно по расписанию. Почему так произошло? 
```sh
sudo cat /var/log/postgresql/postgresql-18-main.log
2026-03-22 22:52:04.698 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:52:04.729 MSK [6771] LOG:  checkpoint complete: wrote 0 buffers (0.0%), wrote 3 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=0.008 s, sync=0.004 s, total=0.032 s; sync files=2, longest=0.002 s, average=0.002 s; distance=0 kB, estimate=0 kB; lsn=0/CFF692A8, redo lsn=0/CFF69250
2026-03-22 22:52:34.195 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:52:45.166 MSK [6771] LOG:  checkpoint complete: wrote 5 buffers (2.5%), wrote 5 SLRU buffers; 1 WAL file(s) added, 0 removed, 0 recycled; write=10.783 s, sync=0.073 s, total=10.971 s; sync files=14, longest=0.024 s, average=0.006 s; distance=17567 kB, estimate=17567 kB; lsn=0/D1EA0C90, redo lsn=0/D1091120
2026-03-22 22:53:04.078 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:53:14.924 MSK [6771] LOG:  checkpoint complete: wrote 6 buffers (3.0%), wrote 5 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=10.672 s, sync=0.134 s, total=10.846 s; sync files=16, longest=0.063 s, average=0.009 s; distance=20016 kB, estimate=20016 kB; lsn=0/D322FD60, redo lsn=0/D241D2D0
2026-03-22 22:53:34.042 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:53:42.456 MSK [6771] LOG:  checkpoint complete: wrote 5 buffers (2.5%), wrote 7 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=8.257 s, sync=0.112 s, total=8.414 s; sync files=6, longest=0.083 s, average=0.019 s; distance=19397 kB, estimate=19954 kB; lsn=0/D44127B8, redo lsn=0/D370EA68
2026-03-22 22:54:04.113 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:54:12.734 MSK [6771] LOG:  checkpoint complete: wrote 7 buffers (3.5%), wrote 6 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=8.462 s, sync=0.116 s, total=8.622 s; sync files=17, longest=0.061 s, average=0.007 s; distance=20084 kB, estimate=20084 kB; lsn=0/D5791548, redo lsn=0/D4AABC30
2026-03-22 22:54:34.179 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:54:42.286 MSK [6771] LOG:  checkpoint complete: wrote 4 buffers (2.0%), wrote 6 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=7.969 s, sync=0.099 s, total=8.108 s; sync files=6, longest=0.077 s, average=0.017 s; distance=19277 kB, estimate=20003 kB; lsn=0/D6A05040, redo lsn=0/D5D7F280
2026-03-22 22:55:04.119 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:55:15.248 MSK [6771] LOG:  checkpoint complete: wrote 8 buffers (4.0%), wrote 7 SLRU buffers; 1 WAL file(s) added, 0 removed, 0 recycled; write=10.888 s, sync=0.151 s, total=11.130 s; sync files=16, longest=0.082 s, average=0.010 s; distance=20044 kB, estimate=20044 kB; lsn=0/D7F499E0, redo lsn=0/D7112290
2026-03-22 22:55:34.020 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:55:42.412 MSK [6771] LOG:  checkpoint complete: wrote 4 buffers (2.0%), wrote 5 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=8.269 s, sync=0.078 s, total=8.392 s; sync files=6, longest=0.061 s, average=0.013 s; distance=19061 kB, estimate=19945 kB; lsn=0/D9062B68, redo lsn=0/D83AF758
2026-03-22 22:56:04.180 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:56:12.619 MSK [6771] LOG:  checkpoint complete: wrote 6 buffers (3.0%), wrote 6 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=8.258 s, sync=0.140 s, total=8.439 s; sync files=17, longest=0.080 s, average=0.009 s; distance=20061 kB, estimate=20061 kB; lsn=0/DA3FBD18, redo lsn=0/D9746D38
2026-03-22 22:56:34.079 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:56:44.705 MSK [6771] LOG:  checkpoint complete: wrote 5 buffers (2.5%), wrote 7 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=10.485 s, sync=0.097 s, total=10.627 s; sync files=6, longest=0.073 s, average=0.017 s; distance=19062 kB, estimate=19961 kB; lsn=0/DB7B9E28, redo lsn=0/DA9E4630
2026-03-22 22:57:04.127 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:57:15.260 MSK [6771] LOG:  checkpoint complete: wrote 5 buffers (2.5%), wrote 6 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=10.972 s, sync=0.119 s, total=11.133 s; sync files=15, longest=0.065 s, average=0.008 s; distance=19626 kB, estimate=19928 kB; lsn=0/DCAF4958, redo lsn=0/DBD0F1C0
2026-03-22 22:57:34.309 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:57:43.184 MSK [6771] LOG:  checkpoint complete: wrote 5 buffers (2.5%), wrote 6 SLRU buffers; 1 WAL file(s) added, 0 removed, 0 recycled; write=8.677 s, sync=0.103 s, total=8.876 s; sync files=6, longest=0.079 s, average=0.017 s; distance=18799 kB, estimate=19815 kB; lsn=0/DDC4CB48, redo lsn=0/DCF6B088
2026-03-22 22:58:04.180 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:58:15.150 MSK [6771] LOG:  checkpoint complete: wrote 6 buffers (3.0%), wrote 7 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=10.815 s, sync=0.123 s, total=10.970 s; sync files=16, longest=0.066 s, average=0.008 s; distance=19834 kB, estimate=19834 kB; lsn=0/DF078230, redo lsn=0/DE2C9B80
2026-03-22 22:58:34.352 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:58:41.966 MSK [6771] LOG:  checkpoint complete: wrote 5 buffers (2.5%), wrote 6 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=7.461 s, sync=0.109 s, total=7.614 s; sync files=7, longest=0.087 s, average=0.016 s; distance=19077 kB, estimate=19758 kB; lsn=0/E0149110, redo lsn=0/DF56B0B8
2026-03-22 22:59:04.165 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:59:12.208 MSK [6771] LOG:  checkpoint complete: wrote 8 buffers (4.0%), wrote 6 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=7.874 s, sync=0.132 s, total=8.044 s; sync files=16, longest=0.078 s, average=0.009 s; distance=20007 kB, estimate=20007 kB; lsn=0/E1565E08, redo lsn=0/E08F4F20
2026-03-22 22:59:34.149 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 22:59:42.953 MSK [6771] LOG:  checkpoint complete: wrote 4 buffers (2.0%), wrote 7 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=8.657 s, sync=0.104 s, total=8.804 s; sync files=6, longest=0.075 s, average=0.018 s; distance=19176 kB, estimate=19924 kB; lsn=0/E28BB3D0, redo lsn=0/E1BAF198
2026-03-22 23:00:04.245 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 23:00:15.211 MSK [6771] LOG:  checkpoint complete: wrote 6 buffers (3.0%), wrote 6 SLRU buffers; 1 WAL file(s) added, 0 removed, 0 recycled; write=10.766 s, sync=0.120 s, total=10.967 s; sync files=16, longest=0.073 s, average=0.008 s; distance=20185 kB, estimate=20185 kB; lsn=0/E3DA2F80, redo lsn=0/E2F65808
2026-03-22 23:00:34.104 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 23:00:41.951 MSK [6771] LOG:  checkpoint complete: wrote 4 buffers (2.0%), wrote 5 SLRU buffers; 1 WAL file(s) added, 0 removed, 0 recycled; write=7.661 s, sync=0.094 s, total=7.847 s; sync files=6, longest=0.073 s, average=0.016 s; distance=19199 kB, estimate=20087 kB; lsn=0/E4EC5368, redo lsn=0/E42256D8
2026-03-22 23:01:04.269 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 23:01:15.415 MSK [6771] LOG:  checkpoint complete: wrote 6 buffers (3.0%), wrote 7 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=10.973 s, sync=0.133 s, total=11.147 s; sync files=17, longest=0.074 s, average=0.008 s; distance=20113 kB, estimate=20113 kB; lsn=0/E63E7200, redo lsn=0/E55C9D30
2026-03-22 23:01:34.239 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 23:01:45.149 MSK [6771] LOG:  checkpoint complete: wrote 5 buffers (2.5%), wrote 6 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=10.664 s, sync=0.189 s, total=10.910 s; sync files=6, longest=0.156 s, average=0.032 s; distance=19085 kB, estimate=20010 kB; lsn=0/E7690700, redo lsn=0/E686D4A0
2026-03-22 23:02:04.063 MSK [6771] LOG:  checkpoint starting: time
2026-03-22 23:02:13.091 MSK [6771] LOG:  checkpoint complete: wrote 5 buffers (2.5%), wrote 5 SLRU buffers; 0 WAL file(s) added, 0 removed, 0 recycled; write=8.885 s, sync=0.098 s, total=9.028 s; sync files=14, longest=0.054 s, average=0.007 s; distance=19184 kB, estimate=19928 kB; lsn=0/E875F270, redo lsn=0/E7B29518
```
Видно, что все контрольные точки выполнялись ровно через 30 с, начиная с 22:52:04 до 23:02:04. 
Так как был задан параметр checkpoint_timeout = 30s
## Сравните tps в синхронном/асинхронном режиме утилитой pgbench. Объясните полученный результат.
В синхронном режиме tps = 377.671839
Настройка асинхронного режима:
```sql
ALTER SYSTEM SET synchronous_commit = off;
SELECT pg_reload_conf();
```
Запуск pgbench:
```sh
postgres@elena-VirtualBox:/mnt/Documents$ pgbench  -c 2 -j 1 -P 10 -T 60 postgres
pgbench (18.2 (Ubuntu 18.2-1.pgdg24.04+1))
starting vacuum...end.
progress: 10.0 s, 2132.0 tps, lat 0.936 ms stddev 0.642, 0 failed
progress: 20.0 s, 2077.0 tps, lat 0.962 ms stddev 0.561, 0 failed
progress: 30.0 s, 2097.7 tps, lat 0.952 ms stddev 0.521, 0 failed
progress: 40.0 s, 2000.0 tps, lat 0.999 ms stddev 0.578, 0 failed
progress: 50.0 s, 2021.8 tps, lat 0.987 ms stddev 0.734, 0 failed
progress: 60.0 s, 2138.0 tps, lat 0.934 ms stddev 0.496, 0 failed
transaction type: <builtin: TPC-B (sort of)>
scaling factor: 1
query mode: simple
number of clients: 2
number of threads: 1
maximum number of tries: 1
duration: 60 s
number of transactions actually processed: 124666
number of failed transactions: 0 (0.000%)
latency average = 0.961 ms
latency stddev = 0.594 ms
initial connection time = 11.199 ms
tps = 2078.100548 (without initial connection time)
```
В асинхронном режиме tps = 2078.100548 - в 5,5 раз больше, чем в синхронном. Причина - уменьшилось время отклика. Но следует учесть, что зафиксированные изменения могут пропасть.
## Создайте новый кластер с включенной контрольной суммой страниц. Создайте таблицу. Вставьте несколько значений. Выключите кластер. Измените пару байт в таблице. Включите кластер и сделайте выборку из таблицы. Что и почему произошло? как проигнорировать ошибку и продолжить работу? 
Для 18 версии postgresql контрольные суммы включены по умолчанию для всех новых кластеров. 

Проверка:
```sql
show data_checksums;
```
"data_checksums"
"on"

Создание таблицы:
```sql
CREATE TABLE test_text(t text);
INSERT INTO test_text SELECT 'строка '||s.id FROM generate_series(1,500) AS s(id);
```
Определить файл, в котором содержится таблица:
```sql
SELECT pg_relation_filepath('test_text');
```
"pg_relation_filepath"
"base/5/32905"

Выключить кластер:
```sh
sudo pg_ctlcluster 18 main stop
```

Поменять несколько байт в странице (стереть из заголовка LSN последней журнальной записи):
```sh
sudo dd if=/dev/zero of=/mnt/data/18/main/base/5/32905 oflag=dsync conv=notrunc bs=1 count=8
```

Включить кластер:
```sh
sudo pg_ctlcluster 18 main start
```

Сделать выборку из таблицы:
```sql
SELECT * FROM test_text limit 10;

ERROR:  invalid page in block 0 of relation "base/5/32905" 

SQL state: XX001
```
Ошибка, т.к. файл с таблицей поврежден. Для просмотра данных можно отключить подсчет контрольных сумм. Можно это сделать в рамках одной транзакции:
```sql
set ignore_checksum_failure = on;
SELECT * FROM test_text limit 10;
```
"t"
"строка 2"
"строка 3"
"строка 4"
"строка 5"
"строка 6"
"строка 7"
"строка 8"
"строка 9"
"строка 10"
"строка 11"

