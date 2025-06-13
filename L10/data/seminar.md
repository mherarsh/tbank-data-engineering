# Cassandra
Запускаем ноду Cassandra, используя Docker-compose
```yml
version: '3.8'

services:
  cassandra_db:
    image: cassandra:latest
    container_name: cassandra_db
    hostname: cassandra_db
    environment:
      - SEEDS=cassandra_db
      - START_RPC=false
      - CLUSTER_NAME=dse51_cluster
      - DC=DC1
      - RACK=RAC1
      - NUM_TOKENS=256
      - MAX_HEAP_SIZE=1G
      - HEAP_NEWSIZE=200M
      - CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch
    expose:
      - 9042
    ports:
      - "9042:9042"
    ulimits:
      memlock: -1
      nproc: 32768
      nofile: 10000
    networks:
      - sri-net

networks:
  sri-net:
    driver: bridge
```

Проверяем, что нода успешно запустилась

``docker exec -it cassandra_db nodetool status``

Подключаемс к контейнеру 

``docker exec -it cassandra_db cqlsh``

## Создаём KeySpace

```sql
CREATE KEYSPACE iot_data WITH replication = {
  'class': 'SimpleStrategy',
  'replication_factor': 1
};
```
**SimpleStrategy** - Стратегия репликации данных

**replication_factor** - Количество реплик, между которыми будут распределены данные (в нашем случае одна)

## Создаём таблицу

```sql
CREATE TABLE iot_data.sensor_readings (
  device_id TEXT, -- id сенсора
  device_type TEXT, -- тип сенсора ('POOR, 'GOOD', 'ADVANCED')
  reading_time TIMESTAMP, -- время снятия измерения
  temperature DOUBLE, -- температура
  humidity DOUBLE, -- влажность
  status TEXT, -- состояние сенсора на момент снятия показания ('OK', 'WARN', 'ERROR')
  PRIMARY KEY ((device_id), device_type, reading_time)
);
```
Обращаем внимание на **PRIMARY KEY** 

Первый ключ ``device_id`` определяет в какую ноду попадёт запись
Все остальные ключ после первого определяют ключи сортировки внутри ноды (в нашем случае это ``device_type`` и ``reading_time``)

Если необходим составной partition ключ, то их необходимо указать в скобках
Например:
```sql
PRIMARY KEY ((device_id, device_type), reading_time)
```
В данном случае определение ноды, на которую попадёт запись, будет осуществляться по двум ключам ``device_id, device_type`` 

## Делаем insert

Добавляем данные в нашу новую таблицу
```sql
CONSISTENCY ONE;
INSERT INTO iot_data.sensor_readings (device_id, device_type, reading_time, temperature, humidity, status)
VALUES ('device99', 'GOOD', toTimestamp(now()), 21.0, 50, 'OK')
USING TTL 86400;
```
В запросе `CONSISTENCY ONE` указывает на то, что запись будет считаться успешно записанной, когда придёт подтверждение от одной ноды. Также может быть `TWO` и `THREE`

Также может быть

`QUORUM` - должно быть подтверждение большинства реплик

`ALL` - от всех реплик

И другие

Также установлен TTL, который указывается в секундах (в данном случае 1 день)

Либо можно указать TTL на все записи
```sql
ALTER TABLE iot_data.sensor_readings WITH default_time_to_live = 86400;
```

## Делаем select

```sql
SELECT * FROM iot_data.sensor_readings
WHERE device_id = 'device99'
  AND device_type = 'GOOD'
  AND reading_time > '2025-06-01 00:00:00';
```

**Обязательно** при SELECT запросах в Cassandra необходимо указывать partition ключ, иначе Cassandra придётся искать запись по всем нодам, что с большой вероятностью приведёт к OutOfMemory

Также запрос выполняется по ключу сортировки `reading_time`

## Индексы

При необходимости выполнения запроса без partition ключа например 
```sql
SELECT * FROM iot_data.sensor_readings
WHERE status = 'FAIL';
```

Мы получим ошибку ``Cannot execute this query as it might involve data filtering and thus may have unpredictable performance. If you want to execute this query despite the performance unpredictability, use ALLOW FILTERING``

Чтобы этого избежать, необходимо добавить в запрос ``ALLOW FILTERING``

```sql
SELECT * FROM iot_data.sensor_readings
WHERE status = 'OK' ALLOW FILTERING;
```

Но в данном случае высока вероятность OOM и низкой производительность
Поэтому необходимо добавить индекс
```sql
CREATE INDEX ON iot_data.sensor_readings (status);
```
Также важно учитывать, что такие индексы хорошо себя показывают только если записи имеют низкую кардинальность.
Как в нашем варианте status может принмать значения `FAIL`, `WARN`, `OK`

При необходимости выполнения запроса по полям с высокой кардинальностью, как например `humidity` или `temperature`, стоит прибегать и денормализации таблиц





