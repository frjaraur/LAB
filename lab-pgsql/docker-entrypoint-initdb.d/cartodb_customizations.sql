CREATE USER "publicuser";
CREATE USER "tileuser";
CREATE DATABASE template_postgis OWNER postgres ENCODING 'UTF8' TEMPLATE template0;
CREATE OR REPLACE LANGUAGE plpgsql;
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;

