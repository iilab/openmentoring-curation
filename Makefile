default: prepare generate

help:
	@echo "Commands:"
	@echo "	make 							Builds targets from source catalogue"
	@echo "	make debug 				Builds targets with debug output from source catalogue"
	@echo "	make install			Installs latest GitBook and dependencies"
	@echo ""

content:
	git clone https://github.com/iilab/openmentoring-content content

prepare: content
	cd content
	git pull
	# TODO: clone all catalogue entries.
	# TODO: check news/incident feeds.

debug: 
	# metalsmith --config mobile/metalsmith.json
	debug=metalsmith:* metalsmith --config web/metalsmith.json
	debug=metalsmith:* metalsmith --config print/metalsmith.json

generate: 
	# metalsmith --config mobile/metalsmith.json
	metalsmith --config web/metalsmith.json
	metalsmith --config print/metalsmith.json

install: web print # mobile

web:
	rev=$(git rev-parse --short HEAD)
	cd web/build
	git init
	git config user.name "Travis CI"
	git config user.email "ci@iilab.org"
	git remote add upstream "https://$GH_TOKEN@github.com/iilab/openmentoring-web.git"
	git fetch upstream
	git reset upstream
	echo "openmentoring.io" > CNAME
	cp ../*.* .
	git add -A .
	git commit -m "Rebuilt website source at ${rev}"
	git push -q upstream HEAD:master

print:
	rev=$(git rev-parse --short HEAD)
	cd print/build
	git init
	git config user.name "Travis CI"
	git config user.email "ci@iilab.org"
	git remote add upstream "https://$GH_TOKEN@github.com/iilab/openmentoring-print.git"
	git fetch upstream
	git reset upstream
	touch .
	git add -A .
	git commit -m "Rebuilt book source at ${rev}"
	git push -q upstream HEAD:master