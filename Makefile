VFLAGS=-stats

all: build test

build:
	@echo 'building shared library'
	v $(VFLAGS) -shared .

prod:
	@echo 'building shared library (prod)'
	v $(VFLAGS) -shared -prod . 

clean:
	rm -fv vcfg.so

test: 
	v -stats test .
