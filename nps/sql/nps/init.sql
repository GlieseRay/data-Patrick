BEGIN;

CREATE SCHEMA nps;


CREATE TABLE nps.label_poi (
    gid                 SERIAL NOT NULL,
    feature_class       VARCHAR,
    feature_type        VARCHAR,
    name                VARCHAR,
    name_length         SMALLINT,
    name_abbr           VARCHAR,
    name_abbr_length    SMALLINT,
    scalerank           SMALLINT,
    size                REAL,
    geometry            GEOMETRY(POINT, 3857),

    pictograph          VARCHAR,

    PRIMARY KEY (gid)
);


CREATE TABLE nps.label_boundary (
    gid                 SERIAL NOT NULL,
    feature_class       VARCHAR,
    feature_type        VARCHAR,
    name                VARCHAR,
    name_length         SMALLINT,
    name_abbr           VARCHAR,
    name_abbr_length    SMALLINT,
    scalerank           SMALLINT,
    size                REAL,
    geometry            GEOMETRY(POINT, 3857),

    PRIMARY KEY (gid)
);


CREATE TABLE nps.boundary AS
    SELECT * FROM public.boundary;

CREATE TABLE nps.building AS
    SELECT * FROM public.building;

CREATE TABLE nps.parking_lot AS
    SELECT * FROM public.parking_lot;


COMMIT;
