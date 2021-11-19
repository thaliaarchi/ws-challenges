BUILD = build
WSLIB = ../wslib
SED = gsed
ASSEMBLE = wsc
COMPILE = nebula-compile

.PHONY: all
all: $(patsubst %.wsf,$(BUILD)/%.ws,$(wildcard euler/*.wsf)) $(BUILD)/euler/14

$(BUILD)/%.ws: $(BUILD)/%.wsa
	$(ASSEMBLE) -f asm -t -o $@ $<

$(BUILD)/%.wsa: %.wsf
	@mkdir -p $(dir $@)
	$(SED) -Ef $(WSLIB)/wsf.sed $^ > $@

$(BUILD)/euler/1.wsa: euler/1.wsf $(WSLIB)/math/math.wsf
$(BUILD)/euler/6.wsa: euler/6.wsf $(WSLIB)/math/math.wsf
$(BUILD)/euler/16.wsa: euler/16.wsf $(WSLIB)/math/exp.wsf
$(BUILD)/euler/48.wsa: euler/48.wsf $(WSLIB)/math/exp.wsf

$(BUILD)/euler/14: $(BUILD)/euler/14.ws
	$(COMPILE) $< $@ '' '-heap 1000000'

.PHONY: clean
clean:
	@rm -rf $(BUILD)/
