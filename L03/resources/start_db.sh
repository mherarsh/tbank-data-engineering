#!/bin/bash

docker run -d \
  --name hse-db-indexes-with-data \
  --cpus="0.1" \
  --memory="512m" \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=postgres \
  -p 5432:5432 \
  postgres:15
