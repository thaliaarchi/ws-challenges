.PHONY: all
all: $(patsubst %.wsf, build/%.ws, $(wildcard euler/*.wsf)) build/euler/14

build/%.ws: %.wsf
	wsf_assemble $<
	@mkdir -p build/euler && mv $(@:build/euler/%=%) build/euler/

build/euler/14: build/euler/14.ws
	nebula-compile $< $@ '' '-heap 1000000'

.PHONY: clean
clean:
	@rm -rf build/
