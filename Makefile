BUILD = build
WSLIB = ../wslib
WSLIB_BUILD = $(WSLIB)/build
SED = gsed
ASSEMBLE = wsc
COMPILE = nebula-compile
WSPACE = wspace
AOCDL = aocdl

WSF = $(patsubst ./%,%,$(shell find . -not \( -type d -path ./$(BUILD) -prune \) -type f -name '*.wsf'))
WS = $(patsubst %.wsf,$(BUILD)/%.ws,$(WSF))
BINARIES = $(addprefix $(BUILD)/,euler/14 advent/2020/1 rosetta/palindrome_2_3)

.PHONY: all
all: $(WS) $(BINARIES)

$(BUILD)/%.ws: $(BUILD)/%.wsa
	$(ASSEMBLE) -f asm -t -o $@ $<

.PRECIOUS: $(BUILD)/%.wsa
$(BUILD)/%.wsa: %.wsf $(WSLIB)/wsf.sed $(WSLIB)/wsf-assemble
	@mkdir -p $(@D)
	$(WSLIB)/wsf-assemble $< $@

$(BINARIES): $(BUILD)/%: $(BUILD)/%.ws
	$(COMPILE) $< $@ '' '$(NEBULA_FLAGS)'
$(BUILD)/euler/14: NEBULA_FLAGS = -heap 1000000
$(BUILD)/advent/2020/1: NEBULA_FLAGS = -heap 201
$(BUILD)/rosetta/palindrome_2_3: NEBULA_FLAGS = -heap 1

# Manually-enumerated dependencies
CRYPTO = $(WSLIB)/crypto/module.wsf $(WSLIB)/crypto/caesar.wsf $(WSLIB)/crypto/luhn.wsf
MATH = $(WSLIB)/math/module.wsf $(WSLIB)/math/collatz.wsf $(WSLIB)/math/divmod.wsf $(WSLIB)/math/exp.wsf $(WSLIB)/math/gcd.wsf $(WSLIB)/math/math.wsf
ARRAY = $(WSLIB)/types/array/module.wsf $(WSLIB)/types/array/array.wsf $(WSLIB)/types/array/sort.wsf
BOOL = $(WSLIB)/types/bool.wsf
CHAR = $(WSLIB)/types/char/module.wsf $(WSLIB)/types/char/io.wsf $(WSLIB)/types/char/unicode.wsf
INT = $(WSLIB)/types/int/module.wsf $(WSLIB)/types/int/bits.wsf $(WSLIB)/types/int/int.wsf $(WSLIB)/types/int/print.wsf $(WSLIB)/types/int/read.wsf
MAP = $(WSLIB)/types/map.wsf
MATRIX = $(WSLIB)/types/matrix.wsf
STRING = $(WSLIB)/types/string/module.wsf $(WSLIB)/types/string/compare.wsf $(WSLIB)/types/string/print.wsf $(WSLIB)/types/string/read.wsf $(WSLIB)/types/string/store.wsf
INTCODE = $(WSLIB)/vm/intcode.wsf
$(BUILD)/euler/1.wsa: $(MATH)
$(BUILD)/euler/4.wsa: $(INT)
$(BUILD)/euler/6.wsa: $(MATH)
$(BUILD)/euler/16.wsa: $(MATH)
$(BUILD)/euler/22.wsa: $(MATH) $(ARRAY) $(BOOL) $(CHAR) $(STRING)
$(BUILD)/euler/25.wsa: $(MATH)
$(BUILD)/euler/36.wsa: $(INT)
$(BUILD)/euler/48.wsa: $(MATH)
$(BUILD)/advent/2019/2.wsa: $(INTCODE)
$(BUILD)/advent/2020/1.wsa: $(STRING)
$(BUILD)/advent/2020/2.wsa: $(MATH) $(ARRAY) $(BOOL) $(INT) $(STRING)
$(BUILD)/advent/2020/3.wsa: $(BOOL) $(MATRIX) $(STRING)
$(BUILD)/rosetta/99_bottles.wsa: $(STRING)
$(BUILD)/rosetta/binary_digits.wsa: $(INT)
$(BUILD)/rosetta/count_in_octal.wsa: $(INT)
$(BUILD)/rosetta/palindrome_2_3.wsa: $(INT)

$(WSLIB)/%:
	$(error $* not found at WSLIB=$(WSLIB))
$(WSLIB)/build/%.wsa: $(WSLIB)/%.wsf
	@$(MAKE) -C $(WSLIB) --no-print-directory $(@:$(WSLIB)/%=%)

TEST_INPUTS = $(patsubst ./%,%,$(shell find . -not \( -type d -path ./$(BUILD) -prune \) -type f -name '*.in'))
TEST_OUTPUTS = $(patsubst ./%,%,$(shell find . -not \( -type d -path ./$(BUILD) -prune \) -type f -name '*.out'))
TESTS = $(addprefix $(BUILD)/,$(TEST_OUTPUTS))
BINARY_TESTS = $(addsuffix .out,$(BINARIES))
WSPACE_TESTS = $(filter-out $(BINARY_TESTS),$(TESTS))
TESTS_WITH_INPUTS = $(filter $(patsubst %.in,$(BUILD)/%.out,$(TEST_INPUTS)),$(WSPACE_TESTS))
TESTS_WITHOUT_INPUTS = $(filter-out $(TESTS_WITH_INPUTS),$(WSPACE_TESTS))

.PHONY: run_tests
run_tests: $(TESTS) $(BINARY_TESTS)

$(TESTS_WITHOUT_INPUTS): $(BUILD)/%.out: $(BUILD)/%.ws
	$(WSPACE) $< > $@
$(TESTS_WITH_INPUTS): $(BUILD)/%.out: $(BUILD)/%.ws %.in
	$(WSPACE) $< < $*.in > $@
$(BINARY_TESTS): $(BUILD)/%.out: $(BUILD)/% %.in
	$< < $*.in > $@

ADVENT_WSF = $(shell find advent -type f -name '*.wsf')
ADVENT_IN = $(shell find advent -type f -name '*.in')
ADVENT_INPUTS = $(filter-out $(ADVENT_IN),$(patsubst %.wsf,%.in,$(ADVENT_WSF)))

.PHONY: advent_inputs
advent_inputs: $(ADVENT_INPUTS)

# Fetch Advent of Code inputs with aocdl
# https://github.com/GreenLightning/advent-of-code-downloader
advent/%.in:
	$(AOCDL) -year $(@D:advent/%=%) -day $(@F:%.in=%) -output $@

.PHONY: clean clean_all clean_tests
clean:
	@rm -rf $(BUILD)/
clean_all: clean
	@$(MAKE) -C $(WSLIB) --no-print-directory clean
clean_tests:
	@find $(BUILD) -type f -name '*.out' -delete
