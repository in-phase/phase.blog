TARGET_DIR=docs

all: clean main reference api

main:
	cd main; hugo -d ../$(TARGET_DIR)

reference:
	cd reference; hugo -d ../$(TARGET_DIR)/reference

api:
	echo "TODO: API docs"
	cd api; crystal docs -o ../$(TARGET_DIR)/api

serve:
	cd $(TARGET_DIR); python -m http.server 8080

clean:
	rm -rf $(TARGET_DIR)

.PHONY: all main reference api serve
