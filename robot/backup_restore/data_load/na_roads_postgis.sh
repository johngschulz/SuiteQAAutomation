#!/usr/bin/env bash
createdb -h localhost -p $1 -U docker na_roads
psql -h localhost -p $1 -U docker -d na_roads -c "CREATE EXTENSION postgis"
for i in ./data_load/na_roads/*shp; do shp2pgsql -s 4326:4326 -c -g geom -I $i | psql -h localhost -p $1 -U docker -d na_roads; done

