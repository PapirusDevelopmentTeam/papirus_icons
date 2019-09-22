DB_FILE ?= ./data.json
APPFILTER_FILE ?= ./app/src/main/res/xml/appfilter.xml
DRAWABLE_FILE ?= ./app/src/main/res/xml/drawable.xml
SRC_DIR ?= ./src
BITMAPS_DIR ?= ./app/src/main/res/drawable-nodpi

build: test generate_appfilter convert generate_drawable

delete_pngs:
	find $(BITMAPS_DIR) -name '*.png' -delete

convert:
	env SRC_DIR=$(SRC_DIR) DEST_DIR=$(BITMAPS_DIR) \
		bash scripts/convert_to_png.sh

generate_appfilter:
	env DB_FILE=$(DB_FILE) APPFILTER_FILE=$(APPFILTER_FILE) \
		python scripts/generate_appfilter.py

generate_drawable:
	env DRAWABLE_DIR=$(BITMAPS_DIR) DRAWABLE_FILE=$(DRAWABLE_FILE) \
		bash scripts/generate_drawable.sh

pretty:
	@rm -f $(DB_FILE).sorted
	@jq --sort-keys --raw-output '.' $(DB_FILE) > $(DB_FILE).sorted
	@mv -f $(DB_FILE).sorted $(DB_FILE)

__validate_json:
	## Validate '$(DB_FILE)' file
	@jq type $(DB_FILE) >/dev/null
.PHONY: __validate_json

__find_missing_icons:
	## Find missing icons in '$(DB_FILE)' and '$(SRC_DIR)'
	@env DB_FILE=$(DB_FILE) SRC_DIR=$(SRC_DIR) \
		bash scripts/find_missing_icons.sh
.PHONY: __find_missing_icons

__find_duplicates_activities:
	## Find duplicates activities in '$(DB_FILE)'
	@env DB_FILE=$(DB_FILE) \
		bash scripts/find_duplicates_activities.sh
.PHONY: __find_duplicates_activities

__find_keys_without_activities:
	## Find keys without any activities in '$(DB_FILE)'
	@env DB_FILE=$(DB_FILE) \
		bash scripts/find_keys_without_activities.sh
.PHONY: __find_keys_without_activities

__find_invalid_filenames:
	## Find icons with invalid filenames in '$(SRC_DIR)'
	@LC_ALL=C find $(SRC_DIR) -name '*.svg' -not -regex '.*/[_a-z0-9]+\.svg$$' -print \
		-exec false '{}' +
.PHONY: __find_invalid_filenames

test: __validate_json __find_invalid_filenames __find_missing_icons __find_duplicates_activities __find_keys_without_activities

.PHONY: build delete_pngs convert generate_appfilter generate_drawable test pretty
