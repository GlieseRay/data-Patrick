BEGIN;

-- functions
CREATE FUNCTION road_class(class TEXT, type TEXT) RETURNS TEXT AS $$
DECLARE
	result TEXT;
BEGIN
    CASE
        WHEN class = 'highway' AND type IN ('motorway', 'motorway_link')
            THEN result := 'motorway';
        WHEN class = 'highway' AND type IN ('trunk', 'trunk_link')
            THEN result := 'trunk';
        WHEN class = 'highway' AND type IN ('primary', 'primary_link')
            THEN result := 'primary';
        WHEN class = 'highway' AND type IN ('secondary', 'secondary_link', 'tertiary', 'tertiary_link')
            THEN result := 'secondary';
        WHEN class = 'highway' AND type IN ('residential', 'unclassified', 'road', 'minor')
            THEN result := 'minor';
        WHEN class = 'highway' AND type IN ('path', 'track', 'living_street', 'service')
            THEN result := 'path';
        WHEN class = 'highway' AND type IN ('footway', 'bridleway', 'cycleway', 'pedestrian', 'steps')
            THEN result := 'pedestrian';
        WHEN class = 'highway' AND type IN ('construction', 'proposed')
            THEN result := 'proposed';
        WHEN class = 'railway' AND type = 'rail'
            THEN result := 'rail';
        WHEN class = 'railway' AND type IN ('subway', 'light_rail')
            THEN result := 'subway';
        WHEN class = 'railway' AND type IN ('monorail', 'tram', 'narrow_gauage', 'disused', 'preserved', 'funicular')
            THEN result := 'monorail';
        WHEN class = 'railway'
            THEN result := 'monorail';
        WHEN class = 'route' AND type IN ('ferry')
            THEN result := 'ferry';
        ELSE result := 'path';
    END CASE;
	RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE;


CREATE FUNCTION road_rank(class TEXT, type TEXT) RETURNS SMALLINT AS $$
DECLARE
	result SMALLINT;
BEGIN
    CASE
        WHEN type = 'motorway'
            THEN result := 0;
        WHEN type = 'trunk'
            THEN result := 20;
        WHEN class = 'railway'
            THEN result := 30;
        WHEN type = 'primary'
            THEN result := 40;
        WHEN type = 'secondary'
            THEN result := 50;
        WHEN type = 'tertiary'
            THEN result := 60;
        WHEN type IN ('residential', 'unclassified', 'road', 'minor')
            THEN result := 70;

        WHEN type = 'motorway_link'
            THEN result := 71;
        WHEN type = 'trunk_link'
            THEN result := 72;
        WHEN type = 'primary_link'
            THEN result := 73;
        WHEN type = 'secondary_link'
            THEN result := 74;
        WHEN type = 'tertiary_link'
            THEN result := 75;

        WHEN type IN ('path', 'track', 'living_street', 'service')
            THEN result := 80;
        WHEN type IN ('footway', 'bridleway', 'cycleway', 'pedestrian', 'steps')
            THEN result := 90;
        WHEN type IN ('construction', 'proposed')
            THEN result := 100;

        WHEN type = 'ferry'
            THEN result := 250;

        ELSE result := 255;
    END CASE;
	RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE;


CREATE FUNCTION road_link(class TEXT, type TEXT) RETURNS SMALLINT AS $$
DECLARE
	result SMALLINT;
BEGIN
    CASE
        WHEN type ~~ '%_link'
            THEN result := 1;
        ELSE result := 0;
    END CASE;
	RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE;


CREATE FUNCTION road_layer(layer INTEGER) RETURNS SMALLINT AS $$
DECLARE
	result SMALLINT;
BEGIN
    CASE
        WHEN layer IS NULL THEN result := 0;
        ELSE result := layer;
    END CASE;
	RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE;


CREATE FUNCTION road_dir(geom Geometry) RETURNS SMALLINT AS $$
DECLARE
    az  REAL;
	dir SMALLINT;
BEGIN

    az := Pi() / 2 - ST_Azimuth(ST_StartPoint(geom), ST_EndPoint(geom));

    CASE
        WHEN Sin(az) > 0
            THEN dir := 1;
        ELSE dir := (-1);
    END CASE;
	RETURN dir;

END;
$$ LANGUAGE plpgsql IMMUTABLE;


CREATE FUNCTION road_ref(ref TEXT) RETURNS text AS $$
DECLARE
	result TEXT;
BEGIN
    CASE
        WHEN ref ~ '^I ?\d+'
            THEN result := regexp_replace(ref, '^I ?(\d+).*', 'I \1');
        WHEN ref ~ '^US ?\d+'
            THEN result := regexp_replace(ref, '^US ?(\d+).*', 'US \1');
        WHEN ref ~ '^[[:alpha:]]+ ?\d+'
            THEN result := regexp_replace(ref, '^([[:alpha:]]+) ?(\d+).*', '\1 \2');
        WHEN ref ~ '^[[:alpha:]]+-\d+'
            THEN result := regexp_replace(ref, '^([[:alpha:]]+)-(\d+).*', '\1 \2');
        ELSE result := ref;
    END CASE;
	RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE;


CREATE FUNCTION road_name_abbr(name TEXT) RETURNS text AS $$
DECLARE
	abbr TEXT;
BEGIN
	CASE
	    WHEN name ~* '\mavenue$'::text
	        THEN abbr := regexp_replace("name", '\m(ave)nue$'::text, '\1'::text, 'i'::text);
	    WHEN name ~* '\mboulevard$'::text
	        THEN abbr := regexp_replace("name", '\m(b)oulevard$'::text, '\1lvd'::text, 'i'::text);
	    WHEN name ~* '\mexpressway$'::text
	        THEN abbr := regexp_replace("name", '\m(E)xpressway$'::text, '\1xpwy'::text, 'i'::text);
	    WHEN name ~* '\mfreeway$'::text
	        THEN abbr := regexp_replace("name", '\m(F)reeway$'::text, '\1wy'::text, 'i'::text);
	    WHEN name ~* '\mhighway$'::text
	        THEN abbr := regexp_replace("name", '\m(h)ighway$'::text, '\1wy'::text, 'i'::text);
	    WHEN name ~* '\mparkway$'::text
	        THEN abbr := regexp_replace("name", '\m(p)arkway$'::text, '\1kwy'::text, 'i'::text);
	    WHEN name ~* '\mcourt$'::text
	        THEN abbr := regexp_replace("name", '\m(c)ourt$'::text, '\1t'::text, 'i'::text);
	    WHEN name ~* '\mdrive$'::text
	        THEN abbr := regexp_replace("name", '\m(dr)ive$'::text, '\1'::text, 'i'::text);
	    WHEN name ~* '\mplace$'::text
	        THEN abbr := regexp_replace("name", '\m(pl)ace$'::text, '\1'::text, 'i'::text);
	    WHEN name ~* '\mlane$'::text
	        THEN abbr := regexp_replace("name", '\m(l)ane$'::text, '\1n'::text, 'i'::text);
	    WHEN name ~* '\mroad$'::text
	        THEN abbr := regexp_replace("name", '\m(r)oad$'::text, '\1d'::text, 'i'::text);
	    WHEN name ~* '\mstreet$'::text
	        THEN abbr := regexp_replace("name", '\m(st)reet$'::text, '\1'::text, 'i'::text);
	    WHEN name ~* '\mtrail$'::text
	        THEN abbr := regexp_replace("name", '\m(tr)ail$'::text, '\1'::text, 'i'::text);
	    WHEN name ~* '\mway$'::text
	        THEN abbr := regexp_replace("name", '\m(w)ay$'::text, '\1y'::text, 'i'::text);
	    ELSE abbr := name;
	END CASE;
	RETURN abbr;
END;
$$ LANGUAGE plpgsql IMMUTABLE;


COMMIT;
