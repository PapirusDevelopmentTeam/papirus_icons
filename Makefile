DB_FILE ?= ./data.json
APPFILTER_FILE ?= ./app/src/main/res/xml/appfilter.xml
SRC_DIR ?= ./src

build: test generate_appfilter convert

convert:
	@env SRC_DIR=$(SRC_DIR) \
		bash scripts/convert_to_png.sh

generate_appfilter:
	@env DB_FILE=$(DB_FILE) APPFILTER_FILE=$(APPFILTER_FILE) \
		python scripts/generate_appfilter.py

__validate_json:
	## Validate '$(DB_FILE)' file
	@jq type $(DB_FILE) >/dev/null
PHONY: __validate_json

__find_missing_icons:
	## Find missing icons in '$(DB_FILE)' and '$(SRC_DIR)'
	@env DB_FILE=$(DB_FILE) SRC_DIR=$(SRC_DIR) \
		bash scripts/find_missing_icons.sh
PHONY: __find_missing_icons

test: __validate_json __find_missing_icons

PHONY: convert generate_appfilter test
