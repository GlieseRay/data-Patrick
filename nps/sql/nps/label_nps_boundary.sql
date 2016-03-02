BEGIN;


INSERT INTO nps.label_boundary(
feature_class,
feature_type,
name,
name_length,
name_abbr,
name_abbr_length,
scalerank,
size,
geometry
)
SELECT
    'nps',
    designatio,
    full_name,
    length(full_name),
    display_na,
    length(display_na),
    minzoompol,
    area,
    ST_PointOnSurface(ST_MakeValid(geometry))
FROM
    public.boundary;


CREATE INDEX ON nps.label_boundary
    USING GIST(geometry);

CREATE INDEX ON nps.label_boundary
    (scalerank ASC, size DESC, gid);

CREATE VIEW nps.label_boundary_view AS
    SELECT * FROM nps.label_nps_boundary
    ORDER BY
        scalerank ASC,
        size DESC,
        gid;


COMMIT;
