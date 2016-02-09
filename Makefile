clean:
	rm -rf build

build: clean
	$(MAKE) -C src/ build
