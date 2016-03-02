BEGIN;

CREATE VIEW transportation.label_airport_view AS
    SELECT *, length(name) AS name_length
    FROM transportation.osm_airport
    ORDER BY
        id;


COMMIT;
