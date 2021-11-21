BUILD = build
WSLIB = ../wslib
SED = gsed
ASSEMBLE = wsc
COMPILE = nebula-compile

WSF = $(patsubst ./%,%,$(shell find . -type f -name '*.wsf'))
WS = $(patsubst %.wsf,$(BUILD)/%.ws,$(WSF))

.PHONY: all
all: $(WS) $(BUILD)/euler/14

$(BUILD)/%.ws: $(BUILD)/%.wsa
	$(ASSEMBLE) -f asm -t -o $@ $<

.PRECIOUS: $(BUILD)/%.wsa
$(BUILD)/%.wsa: %.wsf $(WSLIB)/wsf.sed
	@mkdir -p $(@D)
	$(SED) -Ef $(WSLIB)/wsf.sed $(filter %.wsf,$^) > $@

$(BUILD)/euler/1.wsa: $(WSLIB)/math/math.wsf
$(BUILD)/euler/6.wsa: $(WSLIB)/math/math.wsf
$(BUILD)/euler/16.wsa: $(WSLIB)/math/exp.wsf
$(BUILD)/euler/48.wsa: $(WSLIB)/math/exp.wsf

$(BUILD)/euler/14: $(BUILD)/euler/14.ws
	$(COMPILE) $< $@ '' '-heap 1000000'

$(WSLIB)/%:
	$(error No wslib installation found at WSLIB=$(WSLIB))

.PHONY: clean
clean:
	@rm -rf $(BUILD)/
