all: main reference api

main:
	cd main; hugo

reference:
	cd reference; hugo

api:
	echo "TODO: API docs"
	cd api; crystal docs -o ../public/api

serve:
	cd public; python -m http.server 8080

.PHONY: all main reference api serve
