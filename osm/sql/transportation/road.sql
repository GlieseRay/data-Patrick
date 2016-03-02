BEGIN;


INSERT INTO transportation.osm_road (
    feature, osm_id, osm_class, osm_type, name, ref, rank, oneway, dir, layer,
    is_tunnel, is_bridge, is_link, is_toll, geometry)
    SELECT
        road_class(class, type),
        osm_id,
        class,
        type,
        name,
        road_ref(ref),
        road_rank(class, type),
        oneway,
        road_dir(geometry),
        road_layer(layer),
        is_tunnel,
        is_bridge,
        road_link(class, type),
        is_toll,
        geometry
    FROM public.osm_road;

CREATE INDEX ON transportation.osm_road
    USING gist
    (geometry);
CREATE INDEX ON transportation.osm_road
    (feature);
CREATE INDEX ON transportation.osm_road
    (layer, is_tunnel DESC NULLS LAST, is_bridge ASC NULLS FIRST, rank DESC, id);

INSERT INTO transportation.osm_road_gen0 (
    id, feature, osm_id, osm_class, osm_type, name, ref, rank, oneway, dir, layer,
    is_tunnel, is_bridge, is_link, is_toll, geometry)
    SELECT
        id,
        feature,
        osm_id,
        osm_class,
        osm_type,
        name,
        ref,
        rank,
        oneway,
        dir,
        layer,
        is_tunnel,
        is_bridge,
        is_link,
        is_toll,
        ST_SimplifyPreserveTopology(geometry, 10.0)
    FROM transportation.osm_road
    WHERE
        feature IN (
            'motorway',
            'motorway_link',
            'trunk',
            'trunk_link',
            'primary',
            'primary_link',
            'secondary',
            'secondary_link',
            'tertiary',
            'tertiary_link',
            'residential',
            'unclassified',
            'rail',
            'ferry');


CREATE INDEX ON transportation.osm_road_gen0
    USING gist
    (geometry);
CREATE INDEX ON transportation.osm_road_gen0
    (feature);
CREATE INDEX ON transportation.osm_road_gen0
    (layer, is_tunnel DESC NULLS LAST, is_bridge ASC NULLS FIRST, rank DESC, id);


INSERT INTO transportation.osm_road_gen1 (
    id, feature, osm_id, osm_class, osm_type, name, ref, rank, oneway, dir, layer,
    is_tunnel, is_bridge, is_link, is_toll, geometry)
    SELECT
        id,
        feature,
        osm_id,
        osm_class,
        osm_type,
        name,
        ref,
        rank,
        oneway,
        dir,
        layer,
        is_tunnel,
        is_bridge,
        is_link,
        is_toll,
        ST_SimplifyPreserveTopology(geometry, 150.0)
    FROM transportation.osm_road_gen0
    WHERE
        feature IN (
            'motorway',
            'trunk',
            'primary',
            'ferry');

CREATE INDEX ON transportation.osm_road_gen1
    USING gist
    (geometry);
CREATE INDEX ON transportation.osm_road_gen1
    (feature);
CREATE INDEX ON transportation.osm_road_gen1
    (layer, is_tunnel DESC NULLS LAST, is_bridge ASC NULLS FIRST, rank DESC, id);


CREATE VIEW transportation.osm_road_view AS
    SELECT * FROM transportation.osm_road
    ORDER BY
        layer,
        is_tunnel DESC NULLS LAST,
        is_bridge ASC NULLS FIRST,
        rank DESC,
        id;

CREATE VIEW transportation.osm_road_gen0_view AS
    SELECT * FROM transportation.osm_road_gen0
    ORDER BY
        layer,
        is_tunnel DESC NULLS LAST,
        is_bridge ASC NULLS FIRST,
        rank DESC,
        id;

CREATE VIEW transportation.osm_road_gen1_view AS
    SELECT * FROM transportation.osm_road_gen1
    ORDER BY
        layer,
        is_tunnel DESC NULLS LAST,
        is_bridge ASC NULLS FIRST,
        rank DESC,
        id;


COMMIT;
