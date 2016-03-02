BEGIN;


INSERT INTO nps.label_poi(
feature_class,
feature_type,
name,
name_length,
name_abbr,
name_abbr_length,
scalerank,
size,
geometry,
pictograph
)
SELECT
    class,
    type,
    name,
    length(name),
    NULL,
    NULL,
    CASE
        WHEN class IN (
            'airport',
            'visitor center'
            ) THEN 12
        WHEN class IN (
            'support',
            'information',
            'entrance'
            ) THEN 13
        WHEN class IN (
            'bus',
            'restroom',
            'lighthouse',
            'telephone',
            'showers',
            'shelter',
            'residential',
            'parking',
            'fuel',
            'food'
            ) THEN 14
        ELSE 15
    END,
    0,
    geometry,
    CASE
        WHEN class = $$airport$$ AND type = $$Airport$$ THEN $$Airport$$
        WHEN class = $$entertainment$$ AND type = $$Amphitheater$$ THEN $$Amphitheater$$
        WHEN class = $$all-terrain vehicle$$ AND type = $$All-Terrain Vehicle Trail$$ THEN $$All-terrain trail$$
        WHEN class = $$bench$$ AND type = $$Boat Launch$$ THEN $$Boat launch$$
        WHEN class = $$access$$ AND type = $$Bench$$ THEN $$Bicycle trail$$
        WHEN class = $$bus$$ AND type = $$Bus Stop / Shuttle Stop$$ THEN $$Bus stop_Shuttle stop$$
        WHEN class = $$camping$$ AND type = $$Campfire Ring$$ THEN $$Campfire$$
        WHEN class = $$camping$$ AND type = $$Campground$$ THEN $$Campground$$
        WHEN class = $$access$$ AND type = $$Canoe / Kayak Access$$ THEN $$Canoe access$$
        WHEN class = $$cross-country skiing$$ AND type = $$Cross-Country Ski Trail$$ THEN $$Cross-country ski trail$$
        WHEN class = $$dam$$ AND type = $$Dam$$ THEN $$Dam$$
        WHEN class = $$support$$ AND type = $$Fire Hydrant$$ THEN $$Fire extinguisher$$
        WHEN class = $$support$$ AND type = $$First Aid Station$$ THEN $$First aid$$
        WHEN class = $$fishing$$ AND type = $$Fishing$$ THEN $$Fishing$$
        WHEN class = $$food$$ AND type = $$Food Service$$ THEN $$Food service$$
        WHEN class = $$fuel$$ AND type = $$Gas Station$$ THEN $$Gas station$$
        WHEN class = $$golf$$ AND type = $$Golf Course$$ THEN $$Golfing$$
        WHEN class = $$horse$$ AND type = $$Horseback Riding$$ THEN $$Horseback riding$$
        WHEN class = $$support$$ AND type = $$Hospital$$ THEN $$Hospital$$
        WHEN class = $$information$$ AND type = $$Information$$ THEN $$Information$$
        WHEN class = $$lighthouse$$ AND type = $$Lighthouse$$ THEN $$Lighthouse$$
        WHEN class = $$residential$$ AND type = $$Lodging$$ THEN $$Lodging$$
        WHEN class = $$residential$$ AND type = $$Lodge$$ THEN $$Lodging$$
        WHEN class = $$boat$$ AND type = $$Marina$$ THEN $$Marina$$
        WHEN class = $$parking$$ AND type = $$Parking Lot$$ THEN $$Parking$$
        WHEN class = $$picnic$$ AND type = $$Picnic Area$$ THEN $$Picnic area$$
        WHEN class = $$playground$$ AND type = $$Playground$$ THEN $$Playground$$
        WHEN class = $$point of interest$$ AND type = $$Point of Interest$$ THEN $$Point of interest$$
        WHEN class = $$post$$ AND type = $$Post Office$$ THEN $$Post office$$
        WHEN class = $$camping$$ AND type = $$RV Campground$$ THEN $$RV campground$$
        WHEN class = $$waste$$ AND type = $$Recycling$$ THEN $$Recycling$$
        WHEN class = $$restroom$$ AND type = $$Restroom$$ THEN $$Restrooms$$
        WHEN class = $$scuba$$ AND type = $$Scuba Diving$$ THEN $$Scuba diving$$
        WHEN class = $$shelter$$ AND type = $$Shelter$$ THEN $$Shelter$$
        WHEN class = $$showers$$ AND type = $$Showers$$ THEN $$Showers$$
        WHEN class = $$sled$$ AND type = $$Sledding$$ THEN $$Sledding$$
        WHEN class = $$agricultural$$ AND type = $$Stable$$ THEN $$Stable$$
        WHEN class = $$shopping$$ AND type = $$Store$$ THEN $$Store$$
        WHEN class = $$swimming$$ AND type = $$Swimming Area$$ THEN $$Swimming$$
        WHEN class = $$telephone$$ AND type = $$Telephone$$ THEN $$Telephone$$
        WHEN class = $$trail$$ AND type = $$Trailhead$$ THEN $$Trailhead$$
        WHEN class = $$tunnel$$ AND type = $$Tunnel$$ THEN $$Tunnel$$
        WHEN class = $$view$$ AND type = $$Viewpoint$$ THEN $$Viewing area$$
        WHEN class = $$wheelchair accessible$$ AND type = $$Wheelchair Accessible$$ THEN $$Wheelchair-accessible$$
        ELSE $$Bob$$
    END
FROM
    public.poi;

CREATE INDEX ON nps.label_poi
    USING GIST(geometry);

CREATE INDEX ON nps.label_poi
    (scalerank ASC, size DESC, gid);


CREATE VIEW nps.label_poi_view AS
    SELECT *
    FROM
        nps.label_poi
    ORDER BY
        scalerank ASC,
        size DESC,
        gid;

COMMIT;
