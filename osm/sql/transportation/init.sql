BEGIN;

CREATE SCHEMA transportation;

-- airport
CREATE TABLE transportation.osm_airport (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    iata                    VARCHAR,
    icao                    VARCHAR,
    scalerank               SMALLINT,
    geometry                GEOMETRY(POINT, 3857),

    PRIMARY KEY (id)
);


-- road
CREATE TABLE transportation.osm_road (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_id                  BIGINT,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    ref                     VARCHAR,
    rank                    SMALLINT,
    oneway                  SMALLINT,
    dir                     SMALLINT,
    layer                   SMALLINT,
    is_tunnel               SMALLINT,
    is_bridge               SMALLINT,
    is_link                 SMALLINT,
    is_toll                 SMALLINT,
    geometry                GEOMETRY(LINESTRING, 3857),

    PRIMARY KEY (id)
);


CREATE TABLE transportation.osm_road_gen0 (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_id                  BIGINT,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    ref                     VARCHAR,
    rank                    SMALLINT,
    oneway                  SMALLINT,
    dir                     SMALLINT,
    layer                   SMALLINT,
    is_tunnel               SMALLINT,
    is_bridge               SMALLINT,
    is_link                 SMALLINT,
    is_toll                 SMALLINT,
    geometry                GEOMETRY(LINESTRING, 3857),

    PRIMARY KEY (id)
);


CREATE TABLE transportation.osm_road_gen1 (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_id                  BIGINT,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    ref                     VARCHAR,
    rank                    SMALLINT,
    oneway                  SMALLINT,
    dir                     SMALLINT,
    layer                   SMALLINT,
    is_tunnel               SMALLINT,
    is_bridge               SMALLINT,
    is_link                 SMALLINT,
    is_toll                 SMALLINT,
    geometry                GEOMETRY(LINESTRING, 3857),

    PRIMARY KEY (id)
);


-- label road name
CREATE TABLE transportation.label_osm_road (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    name_length             SMALLINT,
    name_abbr               VARCHAR,
    name_abbr_length        SMALLINT,
    rank                    SMALLINT,
    dir                     SMALLINT,
    is_tunnel               SMALLINT,
    is_bridge               SMALLINT,
    is_toll                 SMALLINT,
    geometry                GEOMETRY(LINESTRING, 3857),

    PRIMARY KEY (id)
);


CREATE TABLE transportation.label_osm_road_gen0 (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    name_length             SMALLINT,
    name_abbr               VARCHAR,
    name_abbr_length        SMALLINT,
    rank                    SMALLINT,
    dir                     SMALLINT,
    is_tunnel               SMALLINT,
    is_bridge               SMALLINT,
    is_toll                 SMALLINT,
    geometry                GEOMETRY(LINESTRING, 3857),

    PRIMARY KEY (id)
);


CREATE TABLE transportation.label_osm_road_gen1 (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    name_length             SMALLINT,
    name_abbr               VARCHAR,
    name_abbr_length        SMALLINT,
    rank                    SMALLINT,
    dir                     SMALLINT,
    is_tunnel               SMALLINT,
    is_bridge               SMALLINT,
    is_toll                 SMALLINT,
    geometry                GEOMETRY(LINESTRING, 3857),

    PRIMARY KEY (id)
);

-- label shield
CREATE TABLE transportation.label_osm_shield (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    sign_schema             VARCHAR,
    sign_type               VARCHAR,
    sign_num                VARCHAR,
    sign_num_length         SMALLINT,
    scalerank               SMALLINT,
    roadrank                SMALLINT,
    geometry                GEOMETRY(LINESTRING, 3857),

    PRIMARY KEY (id)
);


CREATE TABLE transportation.label_osm_shield_gen0 (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    sign_schema             VARCHAR,
    sign_type               VARCHAR,
    sign_num                VARCHAR,
    sign_num_length         SMALLINT,
    scalerank               SMALLINT,
    roadrank                SMALLINT,
    geometry                GEOMETRY(LINESTRING, 3857),

    PRIMARY KEY (id)
);


CREATE TABLE transportation.label_osm_shield_gen1 (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    sign_scheme             VARCHAR,
    sign_type               VARCHAR,
    sign_num                VARCHAR,
    sign_num_length         SMALLINT,
    scalerank               SMALLINT,
    roadrank                SMALLINT,
    geometry                GEOMETRY(LINESTRING, 3857),

    PRIMARY KEY (id)
);


COMMIT;
