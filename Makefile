.PHONY: all
all: $(patsubst %.wsf, build/%.ws, $(wildcard euler/*.wsf)) build/euler/14

build/%.ws: %.wsf
	wsf_assemble $^
	@mkdir -p build/euler && mv $(@:build/euler/%=%) build/euler/

build/euler/16.ws: euler/16.wsf ../wslib/math/exp.wsf
build/euler/48.ws: euler/48.wsf ../wslib/math/exp.wsf

build/euler/14: build/euler/14.ws
	nebula-compile $< $@ '' '-heap 1000000'

.PHONY: clean
clean:
	@rm -rf build/
