BEGIN;

CREATE SCHEMA administration;

CREATE TABLE administration.sa1m_admin_0_boundary_line (
	gid SERIAL NOT NULL,
	geometry GEOMETRY(MULTILINESTRING, 3857),

	PRIMARY KEY (gid)
);

CREATE TABLE administration.sa1m_admin_1_boundary_line (
	gid SERIAL NOT NULL,
	geometry GEOMETRY(MULTILINESTRING, 3857),

	PRIMARY KEY (gid)
);

CREATE TABLE administration.sa1m_admin_0_boundary_line_label (
	gid SERIAL NOT NULL,
	name VARCHAR,
	name_length SMALLINT,
	geometry GEOMETRY(MULTILINESTRING, 3857),

	PRIMARY KEY (gid) );

CREATE TABLE administration.sa1m_admin_1_boundary_line_label (
	gid SERIAL NOT NULL,
	name VARCHAR,
	name_length SMALLINT,
	geometry GEOMETRY(MULTILINESTRING, 3857),

	PRIMARY KEY (gid)
);

COMMIT;