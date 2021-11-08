TARGET_DIR=docs

all: clean main reference api postprocess
	rm -rf api_docs_raw

main:
	cd main; hugo -d ../$(TARGET_DIR)

reference:
	cd reference; hugo -d ../$(TARGET_DIR)/reference

api:
	# cd api; crystal docs -o ../$(TARGET_DIR)/api
	cd api; crystal docs -o ../api_docs_raw

postprocess:
	crystal run postprocess/postprocess.cr

clean:
	rm -rf $(TARGET_DIR)

watch: 
	find . -not -path '*/\.*' -not -path './docs/*' -type f | entr make

serve:
	cd $(TARGET_DIR); python -m http.server 8080


.PHONY: all main reference api serve watch postprocess
