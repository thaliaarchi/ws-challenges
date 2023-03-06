# Whitespace, 68 bytes, [by Ephphatha](https://codegolf.stackexchange.com/questions/103182/significant-whitespace-cops/123333#123333)

- 68 bytes, 21 tabs: `LSSLSSTLSLSTLTSTTTSSSTSTSLTSSTSLSLTSLSSSTSTTSLTSSTLTSLSSLTTTTLSSLSLL`
- 71 bytes, 21 tabs: `LSSLSSLTLTSSSLTTTSSSTSTSLTSSTLTSLSSLTTTSSSTSSSSSLTSSTLTSLSSLTTTTLSSLSLL`
- 72 bytes, 21 tabs: `LSSLSSSTTTTTTLSLSTLTSTTTSLSSSSTSTSLTSSTLTSLSLSSSSTSSSSSLTSSTLTSLTLSSLSLL`
- 65 bytes, 15 tabs (too short): `LSSLSSLSLSTLTSTTTSLSSSSTSTSLTSSTLTSLSLSSSSTSSSSSLTSSTLTSLTLSSLSLL`

Since Whitespace only consists of space, tab, and LF characters (here annotated
as `S`, `T`, and `L`), the entire program needs to be reconstructed, with the
only constraint being that it have exactly 21 tabs to match the cops submission.

I start with a working program, but it's too short and needs 6 more tabs. It
beats the target by 9 bytes, so I could have submitted this as another cop
program, but I don't think it's interesting enough to warrant a second
Whitespace answer.

```wsa
# 65 bytes, 15 tabs
loop:                        # LSSL
    0 dup readc retrieve     # SSL SLS TLTS TTT
    dup 10 - jz loop         # SLS SSSTSTSL TSST LTSL
    dup 32 - jz loop         # SLS SSSTSSSSSL TSST LTSL
    printc                   # TLSS
    jmp loop                 # LSLL
```

The simplest way to add more tabs would be to use 63 (STTTTTT) as the address
for reading characters instead of 0 (empty).

```wsa
# 72 bytes, 21 tabs
loop:                        # LSSL
    63 dup readc retrieve    # SSSTTTTTTL SLS TLTS TTT
    …
```

That only adds bytes, though. If we `retrieve` before every usage, we can
eliminate three `dup`s, which have no tabs (SLS). (This is also the only of
these versions without a stack memory leak.)

```wsa
# 71 bytes, 21 tabs
loop:                        # LSSL
    0 readc                  # SSL TLTS
    0 retrieve 10 - jz loop  # SSL TTT SSSTSTSL TSST LTSL
    0 retrieve 32 - jz loop  # SSL TTT SSSTSSSSSL TSST LTSL
    0 retrieve printc        # SSL TTT TLSS
    jmp loop                 # LSLL
```

We can do better. If we compound the subtractions, 32 (STSSSSS) can be replaced
with 22 (STSTTS), which gains 2 tabs and saves 1 byte. Then, the second branch
doesn't `dup` and the print would obtain an unmodified value with `0 retrieve`,
which gains 3 tabs and adds 3 bytes. For the last tab, a negative sign is added
to one of the zeros.

```wsa
# 68 bytes, 21 tabs
loop:                        # LSSL
    -0 dup readc retrieve    # SSTL SLS TLTS TTT
    10 - dup jz loop         # SSSTSTSL TSST SLS LTSL
    22 - jz loop             # SSSTSTTSL TSST LTSL
    0 retrieve printc        # SSL TTT TLSS
    jmp loop                 # LSLL
```

These programs require an implementation, that allows the sign to be omitted for
zero, so will not work with the reference interpreter, which TIO uses.

For this solution and others in Whitespace, see [ws-challenges](https://github.com/thaliaarchi/ws-challenges).
