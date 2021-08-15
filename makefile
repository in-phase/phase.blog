TARGET_DIR=docs

all: clean main reference api

main:
	cd main; hugo -d ../$(TARGET_DIR)

reference:
	cd reference; hugo -d ../$(TARGET_DIR)/reference

api:
	echo "TODO: API docs"
	cd api; crystal docs -o ../$(TARGET_DIR)/api

clean:
	rm -rf $(TARGET_DIR)

watch: 
	find . -not -path '*/\.*' -not -path './docs/*' -type f | entr make

serve:
	cd $(TARGET_DIR); python -m http.server 8080


.PHONY: all main reference api serve watch
