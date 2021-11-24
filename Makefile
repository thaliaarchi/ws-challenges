BUILD = build
WSLIB = ../wslib
WSLIB_BUILD = $(WSLIB)/build
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
$(BUILD)/%.wsa: %.wsf $(WSLIB)/wsf.sed $(WSLIB)/wsf-assemble
	@mkdir -p $(@D)
	$(WSLIB)/wsf-assemble $< $@

# Manually-enumerated dependencies
$(BUILD)/euler/1.wsa: $(WSLIB_BUILD)/math/math.wsa
$(BUILD)/euler/6.wsa: $(WSLIB_BUILD)/math/math.wsa
$(BUILD)/euler/16.wsa: $(WSLIB_BUILD)/math/exp.wsa
$(BUILD)/euler/25.wsa: $(WSLIB_BUILD)/math/exp.wsa
$(BUILD)/euler/48.wsa: $(WSLIB_BUILD)/math/exp.wsa
$(BUILD)/advent/2020/1.wsa: $(WSLIB_BUILD)/types/string.wsa
$(BUILD)/advent/2020/2.wsa: $(WSLIB_BUILD)/math/math.wsa $(WSLIB_BUILD)/types/array.wsa $(WSLIB_BUILD)/types/bool.wsa $(WSLIB_BUILD)/types/string.wsa

$(BUILD)/euler/14: $(BUILD)/euler/14.ws
	$(COMPILE) $< $@ '' '-heap 1000000'

$(WSLIB)/%:
	$(error $* not found at WSLIB=$(WSLIB))
$(WSLIB)/build/%.wsa: $(WSLIB)/%.wsf
	@$(MAKE) -C $(WSLIB) --no-print-directory $(@:$(WSLIB)/%=%)

.PHONY: clean clean_all
clean:
	@rm -rf $(BUILD)/
clean_all: clean
	@$(MAKE) -C $(WSLIB) --no-print-directory clean
