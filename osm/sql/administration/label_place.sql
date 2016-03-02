BEGIN;

CREATE OR REPLACE VIEW administration.label_osm_place_lv0_view AS
    SELECT *
    FROM administration.osm_place
    WHERE
        feature IN (
            'country',
            'state',
            'county',
            'borough',
            'parish'
        )
    ORDER BY
        CASE
            WHEN feature = 'country' THEN 10
            WHEN feature = 'state' THEN 20
            WHEN feature = 'county' THEN 30
            WHEN feature = 'borough' THEN 40
            WHEN feature = 'parish' THEN 50
        END ASC, id;

CREATE OR REPLACE VIEW administration.label_osm_place_lv1_view AS
    SELECT *
    FROM administration.osm_place
    WHERE
        feature IN (
            'municipality',
            'city',
            'town',
            'village',
            'quarter'
        )
    ORDER BY
        CASE
            WHEN feature = 'municipality' THEN 10
            WHEN feature = 'city' THEN 20
            WHEN feature = 'town' THEN 30
            WHEN feature = 'village' THEN 40
            WHEN feature = 'quarter' THEN 50
        END ASC, id;

CREATE OR REPLACE VIEW administration.label_osm_place_lv2_view AS
    SELECT *
    FROM administration.osm_place
    WHERE
        feature IN (
            'suburb',
            'neighbourhood'
        )
    ORDER BY
        CASE
            WHEN feature = 'suburb' THEN 10
            WHEN feature = 'neighbourhood' THEN 20
        END ASC, id;


CREATE OR REPLACE VIEW administration.label_osm_place_lv3_view AS
    SELECT *
    FROM administration.osm_place
    WHERE
        feature IN (
            'hamlet',
            'locality',
            'isolated_dwelling',
            'farm'
        )
    ORDER BY
        CASE
            WHEN feature = 'hamlet' THEN 10
            WHEN feature = 'locality' THEN 20
            WHEN feature = 'isolated_dwelling' THEN 30
            WHEN feature = 'farm' THEN 40
        END ASC, id;


COMMIT;
