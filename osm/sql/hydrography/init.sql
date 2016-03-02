BEGIN;

CREATE SCHEMA hydrography;

-- ocean
CREATE TABLE hydrography.osm_ocean (
    id                      SERIAL NOT NULL,
    geometry                GEOMETRY(MultiPolygon, 3857),

    PRIMARY KEY (id)
);

-- waterbody
CREATE TABLE hydrography.osm_waterbody (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_id                  BIGINT,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    name_length             SMALLINT,
    water                   VARCHAR,
    is_salt                 SMALLINT,
    area                    REAL,
    geometry                GEOMETRY(MultiPolygon, 3857),

    PRIMARY KEY (id)
);

CREATE TABLE hydrography.osm_waterbody_gen0 (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_id                  BIGINT,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    name_length             SMALLINT,
    water                   VARCHAR,
    is_salt                 SMALLINT,
    area                    REAL,
    geometry                GEOMETRY(MultiPolygon, 3857),

    PRIMARY KEY (id)
);

CREATE TABLE hydrography.osm_waterbody_gen1 (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_id                  BIGINT,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    name_length             SMALLINT,
    water                   VARCHAR,
    is_salt                 SMALLINT,
    area                    REAL,
    geometry                GEOMETRY(MultiPolygon, 3857),

    PRIMARY KEY (id)
);

-- waterway
CREATE TABLE hydrography.osm_waterway (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_id                  BIGINT,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    is_intermittent         SMALLINT,
    is_salt                 SMALLINT,
    geometry                GEOMETRY(LineString, 3857),

    PRIMARY KEY (id)
);


CREATE TABLE hydrography.osm_waterway_gen0 (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_id                  BIGINT,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    is_intermittent         SMALLINT,
    is_salt                 SMALLINT,
    geometry                GEOMETRY(LineString, 3857),

    PRIMARY KEY (id)
);

CREATE TABLE hydrography.osm_waterway_gen1 (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_id                  BIGINT,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    is_intermittent         SMALLINT,
    is_salt                 SMALLINT,
    geometry                GEOMETRY(LineString, 3857),

    PRIMARY KEY (id)
);


-- label waterbody
CREATE TABLE hydrography.label_osm_waterbody_point (
    id                      INTEGER NOT NULL,
    geometry                GEOMETRY(POINT, 3857),

    PRIMARY KEY (id)
);


CREATE TABLE hydrography.label_osm_waterbody_line (
    id                      INTEGER NOT NULL,
    geometry                GEOMETRY(LINESTRING, 3857),

    PRIMARY KEY (id)
);


-- label waterway
CREATE TABLE hydrography.label_osm_waterway (
    id                      SERIAL NOT NULL,
    name                    VARCHAR,
    name_length             SMALLINT,
    rank                    SMALLINT,
    geometry                GEOMETRY(MULTILINESTRING, 3857),

    PRIMARY KEY (id)
);

CREATE TABLE hydrography.label_osm_waterway_gen0 (
    id                      SERIAL NOT NULL,
    name                    VARCHAR,
    name_length             SMALLINT,
    rank                    SMALLINT,
    geometry                GEOMETRY(MULTILINESTRING, 3857),

    PRIMARY KEY (id)
);

COMMIT;
