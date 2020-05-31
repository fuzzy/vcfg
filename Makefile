VFLAGS=-stats

all: build

build: test
	@echo 'building shared library'
	v $(VFLAGS) -shared .

prod: test
	@echo 'building shared library (prod)'
	v $(VFLAGS) -shared -prod . 

clean:
	rm -fv vcfg.so

test: 
	v -stats test .
