BUILD = build
WSLIB = ../wslib
ASSEMBLE = wsf_assemble
COMPILE = nebula-compile

.PHONY: all
all: $(patsubst %.wsf, $(BUILD)/%.ws, $(wildcard euler/*.wsf)) $(BUILD)/euler/14

$(BUILD)/%.ws: %.wsf
	$(ASSEMBLE) $^
	@mkdir -p $(BUILD)/euler && mv $(@:$(BUILD)/euler/%=%) $(BUILD)/euler/

$(BUILD)/euler/16.ws: euler/16.wsf $(WSLIB)/math/exp.wsf
$(BUILD)/euler/48.ws: euler/48.wsf $(WSLIB)/math/exp.wsf

$(BUILD)/euler/14: $(BUILD)/euler/14.ws
	$(COMPILE) $< $@ '' '-heap 1000000'

.PHONY: clean
clean:
	@rm -rf $(BUILD)/
