BEGIN;

CREATE VIEW hypsography.label_gnis_elevation_view AS
	SELECT *
    FROM
        hypsography.gnis_elevation a
    ORDER BY
        rank ASC,
        elev_in_ft DESC,
        ST_X(geometry) DESC,
        gid;

COMMIT;
