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
MATH = $(WSLIB)/math/module.wsf $(WSLIB)/math/collatz.wsf $(WSLIB)/math/divmod.wsf $(WSLIB)/math/exp.wsf $(WSLIB)/math/gcd.wsf $(WSLIB)/math/math.wsf
ARRAY = $(WSLIB)/types/array.wsf
BOOL = $(WSLIB)/types/bool.wsf
INT = $(WSLIB)/types/int/module.wsf $(WSLIB)/types/int/bits.wsf $(WSLIB)/types/int/print.wsf $(WSLIB)/types/int/read.wsf
MATRIX = $(WSLIB)/types/matrix.wsf
STRING = $(WSLIB)/types/string.wsf
$(BUILD)/euler/1.wsa: $(MATH)
$(BUILD)/euler/6.wsa: $(MATH)
$(BUILD)/euler/16.wsa: $(MATH)
$(BUILD)/euler/25.wsa: $(MATH)
$(BUILD)/euler/48.wsa: $(MATH)
$(BUILD)/advent/2020/1.wsa: $(STRING)
$(BUILD)/advent/2020/2.wsa: $(MATH) $(ARRAY) $(BOOL) $(INT) $(STRING)
$(BUILD)/advent/2020/3.wsa: $(BOOL) $(MATRIX) $(STRING)

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
