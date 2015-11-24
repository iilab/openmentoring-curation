REV:=$(shell git rev-parse --short HEAD)

default: prepare generate

help:
	@echo "Commands:"
	@echo "	make 							Builds targets from source catalogue"
	@echo "	make serve 				Builds targets with debug output and serve web build"
	@echo "	make install			Installs latest GitBook and dependencies"
	@echo ""

modules:
	npm install 

content:
	git clone https://github.com/iilab/openmentoring-content content

prepare: modules content
	cd content;	\
	git pull
	# TODO: clone all catalogue entries.
	# TODO: check news/incident feeds.

gitbook: web/build/_book/gitbook
	cd web/build; gitbook install .

serve: gitbook
	# metalsmith --config mobile/metalsmith.json
	DEBUG=metalsmith:* metalsmith --config web/metalsmith.json
	DEBUG=metalsmith:* metalsmith --config print/metalsmith.json
	cd web/build; gitbook serve .

generate: 
	# metalsmith --config mobile/metalsmith.json
	# profile=hrd metalsmith --config web/metalsmith.json
	profile=journo metalsmith --config web/metalsmith.json
	mv web/build web/build-journo
	profile=hrd metalsmith --config web/metalsmith.json
	mv web/build web/build-hrd
	metalsmith --config web/metalsmith.json
	mv web/build web/build-citizen
	mkdir web/build
	mv web/build-journo web/build/journo
	mv web/build-hrd web/build/hrd
	mv web/build-citizen web/build/citizen
	cp -R web/src/citizen web/build/citizen
	cp web/src/book.json web/build/citizen
	cp -R web/src/journo web/build/journo
	cp web/src/book.json web/build/journo
	cp -R web/src/hrd web/build/hrd
	cp web/src/book.json web/build/hrd
	cp web/src/.nojekyll web/build
	cp web/src/.travis.yml web/build
	cp web/src/Makefile web/build
	cp web/src/LANGS.md web/build
	cp web/src/versions web/build
	cp web/src/README.md web/build
	profile=journo metalsmith --config print/metalsmith.json


deploy-web: 
	cd web/build; \
	git init; \
	git config --local user.name "Travis CI"; \
	git config --local user.email "ci@iilab.org"; \
	git remote add upstream "https://${GH_TOKEN}@github.com/iilab/openmentoring-web.git"; \
	git fetch upstream; \
 	git reset upstream/master; \
	git add -A .; \
	git commit -m "Rebuilt website source at ${REV}"; \
	git push -q upstream HEAD:master

deploy-print: 
	cd print/build; \
	git init; \
	git config --local user.name "Travis CI"; \
	git config --local user.email "ci@iilab.org"; \
	git remote add upstream "https://${GH_TOKEN}@github.com/iilab/openmentoring-print.git"; \
	git fetch upstream; \
	git reset upstream/master; \
	touch .; \
	git add -A .; \
	git commit -m "Rebuilt book source at ${REV}"; \
	git push -q upstream HEAD:master

install: deploy-web deploy-print