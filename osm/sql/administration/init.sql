BEGIN;

CREATE SCHEMA administration;

-- place
CREATE TABLE administration.osm_place (
    id                      SERIAL NOT NULL,
    feature                 VARCHAR,
    osm_id                  BIGINT,
    osm_class               VARCHAR,
    osm_type                VARCHAR,
    name                    VARCHAR,
    population              INTEGER,
    is_capital              SMALLINT,
    geometry                GEOMETRY(Point, 3857),

    PRIMARY KEY (id)
);

COMMIT;
