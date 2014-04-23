all: build

build:
	# make lint
	# make clean
	mkdir -p build
	./node_modules/browserify/bin/cmd.js src/main.coffee >> build/jsonbrowser.js
buildw:
	./node_modules/coffee-script/bin/coffee scripts/watch.coffee . make build

# test:
# 	make
# 	mkdir -p test/lib

clean:
	rm -rf build

lint:
	./node_modules/coffeelint/bin/coffeelint -f lint.config.json -r src

# dist:

.PHONY: build clean lint test

