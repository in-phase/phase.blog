TARGET_DIR=docs

all: clean main reference api

main:
	cd main; hugo -d ../$(TARGET_DIR)

reference:
	cd reference; hugo -d ../$(TARGET_DIR)/reference

api:
	cd api; crystal docs -o ../$(TARGET_DIR)/api

postprocess:
	echo "not implemented"

clean:
	rm -rf $(TARGET_DIR)

watch: 
	find . -not -path '*/\.*' -not -path './docs/*' -type f | entr make

serve:
	cd $(TARGET_DIR); python -m http.server 8080


.PHONY: all main reference api serve watch postprocess
