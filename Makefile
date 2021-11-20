BUILD = build
WSLIB = ../wslib
SED = gsed
ASSEMBLE = wsc
COMPILE = nebula-compile

.PHONY: all
all: $(patsubst %.wsf,$(BUILD)/%.ws,$(wildcard euler/*.wsf)) $(BUILD)/euler/14

$(BUILD)/%.ws: $(BUILD)/%.wsa
	$(ASSEMBLE) -f asm -t -o $@ $<

$(BUILD)/%.wsa: $(WSLIB)/wsf.sed %.wsf
	@mkdir -p $(dir $@)
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
