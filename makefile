TARGET_DIR=docs

all: clean main reference api postprocess
#	rm -rf api_docs_raw

main:
	cd main; hugo -d ../$(TARGET_DIR)
	echo "phase.blog" > $(TARGET_DIR)/CNAME

reference:
	cd reference; hugo -d ../$(TARGET_DIR)/reference

api:
	cd api; crystal docs src/ph-core.cr -o ../api_docs_raw

postprocess: api
	./postprocess/postprocess

clean:
	rm -rf $(TARGET_DIR)

watch: 
	find . -not -path '*/\.*' -not -path './docs/*' -not -path './api_docs_raw/*' -type f | entr make

serve:
	cd $(TARGET_DIR); python -m http.server 8080


.PHONY: all main reference api serve watch postprocess
