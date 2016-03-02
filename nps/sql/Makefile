
.DEFAULT: all

.PHONY: all
all: build

.PHONY: build
build:
	@echo "PGHOST: $$PGHOST"
	@echo "PGPORT: $$PGPORT"
	@echo "PGUSER: $$PGUSER"
	@echo "PGDATABASE: $$PGDATABASE"
	
.PHONY: clean
clean:
	@find . -name '*.done' -delete;

include Makefile.init

THEMES = nps

include Makefile.defs