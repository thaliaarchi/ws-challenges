.PHONY: all
all: $(patsubst %.wsf, %.ws, $(wildcard euler/*.wsf)) euler/14

%.ws: %.wsf
	wsf_assemble $<
	@mv $(@:euler/%=%) euler/

euler/14: euler/14.ws
	nebula-compile $< $@ '' '-heap 1000000'

.PHONY: clean
clean:
	@rm -f euler/*.ws euler/*.nir euler/*.ll euler/*.o euler/*.s euler/14
