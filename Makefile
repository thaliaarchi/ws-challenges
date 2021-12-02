BUILD = build
WSLIB = ../wslib
WSLIB_BUILD = $(WSLIB)/build
SED = gsed
ASSEMBLE = wsc
COMPILE = nebula-compile
WSPACE = wspace
AOCDL = aocdl
TEST_TIMEOUT = 60

WSF = $(patsubst ./%,%,$(shell find . -not \( -type d -path ./$(BUILD) -prune \) -type f -name '*.wsf'))
WS = $(patsubst %.wsf,$(BUILD)/%.ws,$(WSF))
COMPILED_PROGRAMS = euler/14.wsf advent/2019/2.wsf rosetta/palindrome_2_3.wsf
BINARIES = $(patsubst %.wsf,$(BUILD)/%,$(COMPILED_PROGRAMS))

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
$(BUILD)/advent/2019/2: NEBULA_FLAGS = -heap 500
$(BUILD)/rosetta/palindrome_2_3: NEBULA_FLAGS = -heap 1

# Manually-enumerated dependencies
ARRAY = $(WSLIB)/array/module.wsf $(WSLIB)/array/array.wsf $(WSLIB)/array/sort.wsf
BOOL = $(WSLIB)/bool/module.wsf $(WSLIB)/bool/bool.wsf
CHAR = $(WSLIB)/char/module.wsf $(WSLIB)/char/io.wsf $(WSLIB)/char/unicode.wsf
CRYPTO = $(WSLIB)/crypto/module.wsf $(WSLIB)/crypto/caesar.wsf
HASH = $(WSLIB)/hash/module.wsf $(WSLIB)/hash/luhn.wsf
INT = $(WSLIB)/int/module.wsf $(WSLIB)/int/bits.wsf $(WSLIB)/int/int.wsf $(WSLIB)/int/print.wsf $(WSLIB)/int/read.wsf
MAP = $(WSLIB)/map/module.wsf $(WSLIB)/map/map.wsf
MATH = $(WSLIB)/math/module.wsf $(WSLIB)/math/collatz.wsf $(WSLIB)/math/divmod.wsf $(WSLIB)/math/exp.wsf $(WSLIB)/math/gcd.wsf $(WSLIB)/math/math.wsf
MATRIX = $(WSLIB)/matrix/module.wsf $(WSLIB)/matrix/matrix.wsf
MEM = $(WSLIB)/mem/module.wsf $(WSLIB)/mem/mem.wsf
STRING = $(WSLIB)/string/module.wsf $(WSLIB)/string/compare.wsf $(WSLIB)/string/print.wsf $(WSLIB)/string/read.wsf $(WSLIB)/string/store.wsf
$(BUILD)/euler/1.wsa: $(MATH)
$(BUILD)/euler/4.wsa: $(INT)
$(BUILD)/euler/6.wsa: $(MATH)
$(BUILD)/euler/16.wsa: $(MATH)
$(BUILD)/euler/22.wsa: $(ARRAY) $(BOOL) $(CHAR) $(MATH) $(STRING)
$(BUILD)/euler/25.wsa: $(MATH)
$(BUILD)/euler/36.wsa: $(INT)
$(BUILD)/euler/48.wsa: $(MATH)
$(BUILD)/advent/2019/2.wsa: $(INTCODE)
$(BUILD)/advent/2020/1.wsa: $(STRING)
$(BUILD)/advent/2020/2.wsa: $(ARRAY) $(BOOL) $(INT) $(MATH) $(STRING)
$(BUILD)/advent/2020/3.wsa: $(BOOL) $(MATRIX) $(STRING)
$(BUILD)/advent/2020/5.wsa: $(CHAR) $(MATH) $(STRING)
$(BUILD)/advent/2021/1.wsa: $(ARRAY) $(BOOL)
$(BUILD)/advent/2021/2.wsa: $(STRING)
$(BUILD)/rosetta/99_bottles.wsa: $(STRING)
$(BUILD)/rosetta/binary_digits.wsa: $(INT)
$(BUILD)/rosetta/count_in_octal.wsa: $(INT)
$(BUILD)/rosetta/palindrome_2_3.wsa: $(INT)
$(BUILD)/spoj/palin.wsa: $(BOOL) $(INT) $(MATH)

$(WSLIB)/%:
	$(error $* not found at WSLIB=$(WSLIB))
$(WSLIB)/build/%.wsa: $(WSLIB)/%.wsf
	@$(MAKE) -C $(WSLIB) --no-print-directory $(@:$(WSLIB)/%=%)

BINARY_TESTS = $(addsuffix .out,$(BINARIES))
TEST_IN = $(patsubst ./%,%,$(shell find . -not \( -type d -path ./$(BUILD) -prune \) -type f -name '*.in'))
TEST_OUT = $(patsubst ./%,%,$(shell find . -not \( -type d -path ./$(BUILD) -prune \) -type f -name '*.out'))
TESTS_WITH_IN = $(filter $(patsubst %.in,$(BUILD)/%.out,$(TEST_IN)),$(patsubst %.wsf,$(BUILD)/%.out,$(WSF)))
TESTS_WITH_OUT = $(filter $(patsubst %.out,$(BUILD)/%.out,$(TEST_OUT)),$(patsubst %.wsf,$(BUILD)/%.out,$(WSF)))
TESTS_WITHOUT_IN = $(filter-out $(TESTS_WITH_IN),$(TESTS_WITH_OUT))
TESTS_MISSING_OUT = $(patsubst $(BUILD)/%.out,%.out,$(filter-out $(TESTS_WITH_OUT),$(TESTS_WITH_IN)))

.PHONY: run_tests
run_tests: $(TESTS_MISSING_OUT) $(TESTS_WITH_IN) $(TESTS_WITH_OUT)

$(filter-out $(BINARY_TESTS),$(TESTS_WITH_IN)): $(BUILD)/%.out: $(BUILD)/%.ws %.in
	timeout $(TEST_TIMEOUT) $(WSPACE) $< < $*.in > $@ 2>&1
$(filter-out $(BINARY_TESTS),$(TESTS_WITHOUT_IN)): $(BUILD)/%.out: $(BUILD)/%.ws
	timeout $(TEST_TIMEOUT) $(WSPACE) $< > $@ 2>&1
$(filter $(BINARY_TESTS),$(TESTS_WITH_IN)): $(BUILD)/%.out: $(BUILD)/% %.in
	timeout $(TEST_TIMEOUT) $< < $*.in > $@ 2>&1
$(filter $(BINARY_TESTS),$(TESTS_WITHOUT_IN)): $(BUILD)/%.out: $(BUILD)/%
	timeout $(TEST_TIMEOUT) $< < $@ 2>&1
$(TESTS_MISSING_OUT):
	$(info Created $@)
	@echo "?" > $@

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
