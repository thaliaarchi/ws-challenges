BUILD = build
WSLIB = ../wslib
SED = gsed
ASSEMBLE = wsc
COMPILE = nebula-compile

SOURCES = $(shell find . -type f -name '*.wsf')

.PHONY: all
all: $(patsubst ./%.wsf,$(BUILD)/%.ws,$(SOURCES)) $(BUILD)/euler/14

$(BUILD)/%.ws: $(BUILD)/%.wsa
	$(ASSEMBLE) -f asm -t -o $@ $<

.PRECIOUS: $(BUILD)/%.wsa
$(BUILD)/%.wsa: $(WSLIB)/wsf.sed %.wsf
	@mkdir -p $(@D)
	$(SED) -Ef $^ > $@

$(BUILD)/euler/1.wsa: $(WSLIB)/math/math.wsf
$(BUILD)/euler/6.wsa: $(WSLIB)/math/math.wsf
$(BUILD)/euler/16.wsa: $(WSLIB)/math/exp.wsf
$(BUILD)/euler/48.wsa: $(WSLIB)/math/exp.wsf

$(BUILD)/euler/14: $(BUILD)/euler/14.ws
	$(COMPILE) $< $@ '' '-heap 1000000'

.PHONY: clean
clean:
	@rm -rf $(BUILD)/
