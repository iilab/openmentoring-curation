help:
	@echo "Commands:"
	@echo "	make deploy				Deploys website to github pages"
	@echo "	make build				Builds website"
	@echo "	make validate			Builds books and validates for invalid HTML output"
	@echo "	make install			Installs latest GitBook and dependencies"
	@echo ""

default: prepare generate

prepare:
	git clone https://github.com/iilab/openmentoring-content content
	# TODO: check news/incident feeds.

generate: 
	# metalsmith --config mobile.json
	metalsmith --config web/metalsmith.json
	metalsmith --config print/metalsmith.json

deploy: web print # mobile

web:
	rev=$(git rev-parse --short HEAD)
	cd mobile/build
	git init
	git config user.name "Jun Matsushita"
	git config user.email "jun@iilab.org"
	git remote add upstream "https://$GH_TOKEN@github.com/iilab/openmentoring-web.git"
	git fetch upstream
	git reset upstream
	echo "openmentoring.io" > CNAME
	touch .
	git add -A .
	git commit -m "Rebuilt web at ${rev}"
	git push -q upstream HEAD:master

print:
	rev=$(git rev-parse --short HEAD)
	cd print/build
	git init
	git config user.name "Jun Matsushita"
	git config user.email "jun@iilab.org"
	git remote add upstream "https://$GH_TOKEN@github.com/iilab/openmentoring-print.git"
	git fetch upstream
	git reset upstream
	touch .
	git add -A .
	git commit -m "Rebuilt web at ${rev}"
	git push -q upstream HEAD:master