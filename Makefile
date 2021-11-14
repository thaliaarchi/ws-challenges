.PHONY: all
all: $(patsubst %.wsf, %.ws, $(wildcard euler/*.wsf))

%.ws: %.wsf
	wsf_assemble $<
	@mv $(@:euler/%=%) euler/

.PHONY: clean
clean:
	@rm -f euler/*.ws
