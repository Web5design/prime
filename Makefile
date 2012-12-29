
output ?= './prime.wrup.js'
output_compress ?= './prime.min.js'
amd ?= ''

all: test build build-compress

clean:
	rm -rf prime.*.js
	rm -rf ./cov*

test: test-node test-promise

test-node:
	@./node_modules/mocha/bin/mocha \
		./test/es5/* \
		./test/util/* \
		./test/prime/* \
		./test/shell/*

test-promise:
	@./node_modules/promises-aplus-tests/lib/cli.js ./test/util/promise.js

build:
	@./node_modules/wrapup/bin/wrup.js -r prime ./ > $(output)
	@echo "File written to $(output)"

build-compress:
	@./node_modules/wrapup/bin/wrup.js -r prime ./ --compress yes > $(output_compress)
	@echo "File written to $(output_compress)"

convert-amd:
	@bash ./bin/convert-amd.sh $(amd)

docs:
	@./node_modules/.bin/procs -f ./doc/prime.md -t ./doc/layout.html

docs-watch:
	@./node_modules/.bin/procs -f ./doc/prime.md -t ./doc/layout.html --watch

coverage:
	rm -rf ./cov
	mkdir ./cov
	echo "{}" > ./cov.json
	cp -R test cov/test
	cp -R node_modules cov/node_modules
	cp Makefile cov/Makefile
	coverjs --recursive -o cov/ es5/ prime/ shell/ util/ --template node --result ./cov.json
	cd cov; make test; cd ..
	cat ./cov.json | coverjs-report -r html > cov.html
	echo "open cov.html"
