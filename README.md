<div align="center">

# 🧮 4-Bit Mini ALU

**A hierarchical Arithmetic Logic Unit, designed and verified from the gate level up in Verilog HDL**

[![Verilog](https://img.shields.io/badge/Language-Verilog-blue.svg)](#)
[![Simulator](https://img.shields.io/badge/Simulator-Icarus%20Verilog-orange.svg)](#)
[![Waveform](https://img.shields.io/badge/Viewer-GTKWave-green.svg)](#)
[![Tests](https://img.shields.io/badge/Arithmetic%20Tests-1024%2F1024%20Passing-brightgreen.svg)](#)
[![Status](https://img.shields.io/badge/Status-Complete-brightgreen.svg)](#)

*Two 4-bit operands. Six logic operations. One fully verified processing core.*

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Learning Objectives](#-learning-objectives)
- [Prerequisites](#-prerequisites)
- [Features](#-features)
- [Supported Operations](#-supported-operations)
- [ALU Interface](#-alu-interface)
- [Architecture](#-architecture)
- [Arithmetic Unit](#-arithmetic-unit)
- [Logic Unit](#-logic-unit)
- [Hierarchical Design](#-hierarchical-design)
- [Project Structure](#-project-structure)
- [Verification](#-verification)
- [Verification Lessons](#-important-verification-lessons)
- [Getting Started](#️-getting-started)
- [Current Status](#-current-status)
- [Future Expansion](#-future-expansion)
- [Key Concepts Learned](#-key-concepts-learned)
- [Reflections](#-reflections)
- [Interview Questions](#-interview-questions)
- [What's Next](#-whats-next)
- [Author](#-author)

---

## 📖 Overview

The **4-Bit Mini ALU** is a modular, self-contained arithmetic and logic processing core built entirely from first principles. It accepts two 4-bit operands and a set of control signals, then performs either an arithmetic operation (addition/subtraction with carry/borrow) or one of six bitwise logic operations, based on the selected mode.

Rather than implementing the ALU with a handful of high-level operators, this project builds it **hierarchically** — starting from individual logic gates and full adders/subtractors, composing them into ripple-carry datapaths, and routing the results through multiplexers. Every block is independently designed, instantiated structurally, and verified in isolation before being integrated into the final unit.

**In this project, you'll find:**

- ✅ A fully hierarchical RTL design, built bottom-up from logic gates
- ✅ Structural instantiation across nested module directories
- ✅ Self-checking testbenches with automatic PASS/FAIL reporting
- ✅ **Exhaustive verification** — all 1024 arithmetic input combinations tested
- ✅ Documented design pitfalls and how they were resolved
- ✅ Waveform-level analysis of carry/borrow propagation

---

## 🎯 Learning Objectives

| # | Concept |
|---|---------|
| 1 | Hierarchical / bottom-up RTL design |
| 2 | Full Adder and Full Subtractor design |
| 3 | Ripple Carry Adder and Ripple Borrow Subtractor datapaths |
| 4 | Structural module instantiation across directories |
| 5 | MUX-based operation and result selection |
| 6 | Multi-bit combinational logic unit design |
| 7 | Self-checking testbenches and reference models |
| 8 | Exhaustive functional verification |
| 9 | Signal concatenation and bit-ordering (`{flag, result}`) |
| 10 | Waveform-level debugging with GTKWave |

---

## 📚 Prerequisites

- Verilog module declaration and continuous assignment (`assign`)
- Basic logic gates (AND, OR, XOR, NAND, NOR, XNOR) — see [01 – NOT Gate](../01_not_gate)
- Full Adder / Full Subtractor logic
- Multiplexer (MUX) fundamentals
- Testbench development and procedural blocks (`initial`, `always`)
- Binary arithmetic: two's complement, carry, and borrow

---

## ✨ Features

<table>
<tr>
<td valign="top" width="50%">

**Datapath**
- 4-bit arithmetic datapath
- 4-bit addition
- 4-bit subtraction
- Carry-in / Borrow-in support
- Carry-out / Borrow-out flag
- Six 4-bit logic operations

</td>
<td valign="top" width="50%">

**Engineering**
- Hierarchical RTL design
- Modular Verilog implementation
- Structural module instantiation
- MUX-based operation selection
- Self-checking testbenches
- Exhaustive arithmetic verification
- VCD waveform generation & GTKWave analysis

</td>
</tr>
</table>

---

## 🔀 Supported Operations

### Arithmetic Operations

| `s_mux` | Operation |
|:---:|---|
| `0` | Addition |
| `1` | Subtraction |

### Logic Operations

| `s[2:0]` | Operation |
|:---:|---|
| `000` | AND |
| `001` | OR |
| `010` | XOR |
| `011` | NAND |
| `100` | NOR |
| `101` | XNOR |
| `110` | Reserved |
| `111` | Reserved |

> The two reserved logic selections currently output `4'b0000`.

---

## 🔌 ALU Interface

The Mini ALU is designed as an independent hardware block with clearly defined external pins.

```text
                     4-BIT MINI ALU
                ┌────────────────────────┐
                │                        │
      A[3:0] ──►│                        │──► RESULT[3:0]
      B[3:0] ──►│                        │
       CB_IN ──►│        MINI ALU        │──► FLAG
       S_MUX ──►│                        │
          S ───►│                        │──► LOGIC RESULT
                │                        │
                └────────────────────────┘
```

### Inputs

| Signal | Width | Description |
|---|:---:|---|
| `a` | 4-bit | First operand |
| `b` | 4-bit | Second operand |
| `cb_in` | 1-bit | Carry-in during addition / Borrow-in during subtraction |
| `s_mux` | 1-bit | Selects ADD or SUB |
| `s` | 3-bit | Selects the logic operation |

### Outputs

| Signal | Width | Description |
|---|:---:|---|
| `result` | 4-bit | Selected arithmetic result |
| `flag` | 1-bit | Carry-out during addition / Borrow-out during subtraction |
| `y` | 4-bit | Selected logic operation result |

---

## 🏗️ Architecture

The Mini ALU splits cleanly into two independent functional sections, unified at the top level.

```text
                         MINI ALU
                            │
             ┌──────────────┴──────────────┐
             │                             │
             ▼                             ▼
      ARITHMETIC UNIT                  LOGIC UNIT
             │                             │
       ┌─────┴─────┐              ┌───────┴───────┐
       │           │              │       │       │
       ▼           ▼              ▼       ▼       ▼
      ADD         SUB            AND     OR      XOR
       │           │              │       │       │
       │           │              ├───────┼───────┤
       │           │              │       │       │
       │           │              ▼       ▼       ▼
       │           │             NAND    NOR    XNOR
       │           │              │       │       │
       │           │              └───────┴───────┘
       │           │                      │
       │           │                      ▼
       │           │                  Logic MUX
       │           │                      │
       │           │                      ▼
       │           │                 Logic Result
       │           │
       └─────┬─────┘
             │
             ▼
           2:1 MUX
             │
             ▼
      Arithmetic Result
```

---

## ➕ Arithmetic Unit

The Arithmetic Unit is built from two independent, always-active datapaths, with a multiplexer selecting the final result.

```text
                    ARITHMETIC UNIT
                           │
             ┌─────────────┴─────────────┐
             │                           │
             ▼                           ▼
      Ripple Carry Adder        Ripple Borrow Subtractor
             │                           │
             ▼                           ▼
        ADD RESULT                  SUB RESULT
             │                           │
             └─────────────┬─────────────┘
                           │
                           ▼
                         2:1 MUX
                           │
                           ▼
                   ARITHMETIC RESULT
```

Both the adder and subtractor run **structurally and unconditionally** — the multiplexer, not conditional logic, decides which result is used. *(More on why this matters in [Verification Lessons](#-important-verification-lessons).)*

### 4-Bit Ripple Carry Adder

Built from four cascaded Full Adders, with carry propagating LSB → MSB.

```text
        A[0] B[0]        A[1] B[1]        A[2] B[2]        A[3] B[3]
          │   │            │   │            │   │            │   │
          ▼   ▼            ▼   ▼            ▼   ▼            ▼   ▼
        ┌───────┐        ┌───────┐        ┌───────┐        ┌───────┐
Cin ───►│  FA0  │──C1───►│  FA1  │──C2───►│  FA2  │──C3───►│  FA3  │
        └───┬───┘        └───┬───┘        └───┬───┘        └───┬───┘
            │                │                │                │
           S0               S1               S2               S3
                                                                │
                                                                ▼
                                                              Cout
```

`cb_in` supplies the carry-in for addition.

### 4-Bit Ripple Borrow Subtractor

Built from four cascaded Full Subtractors, with borrow propagating LSB → MSB.

```text
        A[0] B[0]        A[1] B[1]        A[2] B[2]        A[3] B[3]
          │   │            │   │            │   │            │   │
          ▼   ▼            ▼   ▼            ▼   ▼            ▼   ▼
        ┌───────┐        ┌───────┐        ┌───────┐        ┌───────┐
Bin ───►│  FS0  │──B1───►│  FS1  │──B2───►│  FS2  │──B3───►│  FS3  │
        └───┬───┘        └───┬───┘        └───┬───┘        └───┬───┘
            │                │                │                │
           D0               D1               D2               D3
                                                                │
                                                                ▼
                                                              Bout
```

`cb_in` supplies the borrow-in for subtraction.

### Arithmetic MUX

```text
                         ADD RESULT
                             │
                             ▼
                         ┌───────┐
                         │ 2 : 1 │──────► RESULT
                         │  MUX  │
                         └───────┘
                             ▲
                             │
                         SUB RESULT
                             ▲
                             │
                           S_MUX
```

| `s_mux` | `result` | `flag` |
|:---:|---|---|
| `0` | ADD result | Carry-out |
| `1` | SUB result | Borrow-out |

---

## 🔣 Logic Unit

Six independent 4-bit logic modules feed a 6:1 multiplexer.

```text
                         LOGIC UNIT

      A[3:0] ──────────────┐
                            │
      B[3:0] ──────────────┤
                            │
                            ▼
                ┌────────────────────┐
                │   Logic Operations │
                └─────────┬──────────┘
                          │
       ┌────────┬─────────┼─────────┬────────┬────────┐
       ▼        ▼         ▼         ▼        ▼        ▼
      AND       OR        XOR       NAND     NOR      XNOR
       │        │         │         │        │        │
       └────────┴─────────┴─────────┴────────┴────────┘
                          │
                          ▼
                       6:1 MUX
                          │
                          ▼
                    Logic Result
```

### Logic Equations

| Operation | Verilog |
|---|---|
| AND  | `assign y = a & b;` |
| OR   | `assign y = a \| b;` |
| XOR  | `assign y = a ^ b;` |
| NAND | `assign y = ~(a & b);` |
| NOR  | `assign y = ~(a \| b);` |
| XNOR | `assign y = ~(a ^ b);` |

### Selection Map

```text
s[2:0]
000 → AND        100 → NOR
001 → OR         101 → XNOR
010 → XOR        110 → Reserved (y = 0000)
011 → NAND       111 → Reserved (y = 0000)
```

---

## 🧬 Hierarchical Design

The project follows a strict bottom-up RTL design approach — every block above is built from verified blocks below it.

```text
Logic Gates
     │
     ├──────────────────────┐
     │                      │
     ▼                      ▼
 Full Adder           Full Subtractor
     │                      │
     ▼                      ▼
Ripple Carry Adder   Ripple Borrow Subtractor
     │                      │
     └──────────┬───────────┘
                ▼
         Arithmetic Unit
                │
                ├───────────────┐
                │               │
                ▼               ▼
           Logic Unit       Arithmetic Unit
                │               │
                └───────┬───────┘
                        ▼
                     Mini ALU
```

This makes every module **independently reusable and independently testable** — a defining principle of the project (see [Design Philosophy](#design-philosophy)).

---

## 📂 Project Structure

```text
Mini_alu/
│
├── rtl/
│   │
│   └── alu_unit/
│       │
│       ├── 4_bit_adder/
│       │   ├── full_adder.v
│       │   └── ripple_carry_adder.v
│       │
│       ├── 4_bit_subtractor/
│       │   ├── full_subtractor.v
│       │   └── ripple_carry_sub.v
│       │
│       ├── logic_unit/
│       │   ├── and_g.v
│       │   ├── or_g.v
│       │   ├── xor_g.v
│       │   ├── nand_g.v
│       │   ├── nor_g.v
│       │   ├── xnor_g.v
│       │   └── logic_unit.v
│       │
│       └── alu_unit.v
│
├── tb/
│   ├── alu_unit_tb.v
│   ├── logic_unit_tb.v
│   └── ...
│
├── .gitignore
├── .gitattributes
└── README.md
```

---

## 🧪 Verification

The project uses **self-checking Verilog testbenches**. Each testbench automatically:

1. Generates input combinations
2. Applies the inputs to the DUT
3. Calculates the expected output from a reference model
4. Compares the expected output against the DUT output
5. Reports **PASS** or **FAIL** per test case
6. Tallies failed test cases
7. Prints a final verification summary

This removes the need to manually inspect every test case.

### Exhaustive Arithmetic Verification

The Arithmetic Unit was tested across **every possible combination** of its input and control signals:

| Signal | Combinations |
|---|:---:|
| `A` | 16 |
| `B` | 16 |
| `CB_IN` | 2 |
| `S_MUX` | 2 |
| **Total** | **16 × 16 × 2 × 2 = 1024** |

**Result**

```text
Total Test Cases : 1024
Passed           : 1024
Failed           : 0
```

✅ The Arithmetic Unit passed **all 1024 test cases**.

### Testbench Reference Model

| Mode | Expected Value |
|---|---|
| Addition | `A + B + Carry-In` |
| Subtraction | `A - B - Borrow-In` |

The testbench checks the **combined** signal `{flag, result}` rather than the 4-bit result alone — this ensures both the arithmetic result *and* the carry/borrow status are verified together.

---

## 🔍 Important Verification Lessons

A few real design and verification issues surfaced during development. Each one taught a broader RTL lesson.

<details>
<summary><strong>Structural vs. procedural logic</strong> — conditionally instantiating modules</summary><br>

An early attempt tried to conditionally instantiate the adder or subtractor using an `if` statement. Module instantiations are **structural** and cannot be conditionally instantiated inside a procedural block.

**Fix:**
```text
Instantiate both datapaths
        ↓
Generate both outputs
        ↓
Use a MUX to select the required output
```
</details>

<details>
<summary><strong>Carry and borrow propagation</strong> — dedicated internal wires</summary><br>

Internal carry/borrow chains need their own wires — reusing operand signals for propagation causes incorrect behavior.

```verilog
wire [2:0] br;
```

Borrow chain: `FS0 → br[0] → FS1 → br[1] → FS2 → br[2] → FS3`
</details>

<details>
<summary><strong>Hierarchical connections across directories</strong></summary><br>

Modules can be instantiated even when their source files live in different directories — the compiler just needs every required file at compile time. Folder layout is for project organization; **module names** define the actual Verilog hierarchy.
</details>

<details>
<summary><strong>Testbench reference model must match the datapath width</strong></summary><br>

A single-bit Full Subtractor equation cannot be reused directly as the expected result for the full 4-bit Ripple Borrow Subtractor. The testbench must model the **complete** multi-bit operation (`A - B - Borrow-In`), not just one bit-slice of it.
</details>

<details>
<summary><strong>Width handling in the reference model</strong></summary><br>

When calculating an expected borrow, operands must be zero-extended to avoid unintended overflow in the comparison:

```verilog
({1'b0,a} < ({1'b0,b} + cb_in))
```
</details>

<details>
<summary><strong>Output bit ordering matters</strong></summary><br>

```verilog
{flag, result}   // flag=1, result=1010 → 11010
{result, flag}   // same values, different bit order → different value entirely
```

Concatenation order must match between DUT and reference model, or verification will silently compare the wrong bits.
</details>

---

## 🛠️ Simulation Tools

| Tool | Purpose |
|---|---|
| Verilog HDL | RTL design |
| Icarus Verilog | Simulation |
| GTKWave | Waveform analysis |
| Visual Studio Code | Development |
| Git | Version control |
| GitHub | Repository management |

---

## ▶️ Getting Started

```powershell
# 1. Compile the design and testbench (from the project root)
iverilog -o alu_unit.out tb\alu_unit_tb.v rtl\alu_unit\alu_unit.v rtl\alu_unit\4_bit_adder\ripple_carry_adder.v rtl\alu_unit\4_bit_adder\full_adder.v rtl\alu_unit\4_bit_subtractor\ripple_carry_sub.v rtl\alu_unit\4_bit_subtractor\full_subtractor.v

# 2. Run the simulation
vvp alu_unit.out

# 3. Open the waveform (if the testbench dumps waveform_alu_unit.vcd)
gtkwave waveform_alu_unit.vcd
```

In GTKWave, inspect:

- Input operands (`a`, `b`)
- Operation selection (`s_mux`, `s`)
- Carry/borrow propagation
- Arithmetic result and status flag
- Logic outputs

---

## ✅ Current Status

```text
[✓] Basic logic gates
[✓] Full Adder
[✓] 4-bit Ripple Carry Adder
[✓] Full Subtractor
[✓] 4-bit Ripple Borrow Subtractor
[✓] Arithmetic Unit
[✓] ADD/SUB 2:1 MUX
[✓] Logic Unit
[✓] Logic operation selection
[✓] Self-checking testbench
[✓] Exhaustive arithmetic verification
[✓] 1024/1024 arithmetic test cases passed
[✓] Waveform generation
[✓] Waveform analysis
[✓] GitHub repository structure
```

**Current capabilities:**

```text
ARITHMETIC          LOGIC              STATUS
───────────         ─────              ──────
ADD                 AND                Carry-out
SUB                 OR                 Borrow-out
                     XOR                Carry-in
                     NAND               Borrow-in
                     NOR
                     XNOR
```

---

## 🚧 Future Expansion

The current project is intentionally scoped as a compact 4-bit ALU core. Planned directions include:

- Zero, Sign/Negative, and Overflow flags
- Increment / Decrement operations
- Comparator
- Shift operations
- Wider ALU (8-bit / 16-bit / 32-bit)
- Register file
- Instruction decoder & control unit
- Full CPU datapath and FPGA implementation

```text
Mini ALU → Datapath (Registers + ALU + MUXes) → Control Unit → CPU
```

---

## 🎓 Key Concepts Learned

<table>
<tr>
<td valign="top" width="33%">

**Design**
- Hierarchical RTL design
- Full Adder / Full Subtractor
- Ripple carry & ripple borrow
- MUX-based selection
- Structural instantiation

</td>
<td valign="top" width="33%">

**Verification**
- Self-checking testbenches
- Exhaustive test generation
- Reference models
- Signal concatenation & bit order
- Width extension in comparisons

</td>
<td valign="top" width="33%">

**Toolflow**
- Icarus Verilog compilation
- Multi-file / multi-directory builds
- VCD waveform generation
- GTKWave analysis
- Git & GitHub workflow

</td>
</tr>
</table>

---

## 📝 Reflections

This project marked the shift from writing individual logic gates to designing a genuine **hardware processing core** — one built entirely from smaller, independently verified pieces rather than a handful of high-level operators.

The most valuable lessons weren't in the arithmetic itself, but in the verification discipline around it: understanding *why* module instantiation is structural and can't be conditional, why internal carry/borrow chains need dedicated wires, and why bit-ordering in a concatenation like `{flag, result}` can silently break a comparison if it's inconsistent between DUT and testbench.

Reaching **1024/1024** passing test cases on the arithmetic path was the moment the hierarchical approach really proved itself — every layer (gates → full adder/subtractor → ripple datapath → MUX-selected unit) held up under exhaustive testing, which gave real confidence in the design rather than just a handful of spot checks.

---

## 💼 Interview Questions

<details>
<summary><strong>1. Why can't a module be conditionally instantiated inside an if-statement?</strong></summary><br>

Module instantiation is a structural, compile-time construct describing hardware that physically exists — it isn't a runtime decision. Both datapaths must be instantiated unconditionally, with a multiplexer selecting between their outputs.
</details>

<details>
<summary><strong>2. Why does the Arithmetic Unit instantiate both an adder and a subtractor instead of reusing one datapath?</strong></summary><br>

Addition and subtraction are structurally different circuits (carry vs. borrow propagation). Rather than conditionally reconfiguring one datapath, both are built in parallel and a 2:1 MUX selects the required result — keeping the hardware description purely structural.
</details>

<details>
<summary><strong>3. What is the difference between a Ripple Carry Adder and a Ripple Borrow Subtractor?</strong></summary><br>

A Ripple Carry Adder chains Full Adders, propagating a **carry** from LSB to MSB. A Ripple Borrow Subtractor chains Full Subtractors, propagating a **borrow** from LSB to MSB. Both are structurally similar but use different single-bit cells and propagate a different status signal.
</details>

<details>
<summary><strong>4. Why does the testbench check <code>{flag, result}</code> instead of just <code>result</code>?</strong></summary><br>

Checking only the 4-bit result would miss bugs in carry-out/borrow-out generation. Concatenating the flag with the result and comparing them together verifies the complete arithmetic outcome, including status.
</details>

<details>
<summary><strong>5. Why must operands be zero-extended when calculating an expected borrow?</strong></summary><br>

Without zero-extension, comparing 4-bit values directly can overflow or wrap incorrectly. Extending both operands by one bit (e.g., <code>{1'b0, a}</code>) gives enough width for the comparison against <code>b + cb_in</code> to be evaluated correctly.
</details>

<details>
<summary><strong>6. Why does bit order matter in a concatenation like <code>{flag, result}</code>?</strong></summary><br>

Concatenation order determines which bits occupy which positions in the resulting value. <code>{flag, result}</code> and <code>{result, flag}</code> produce different numeric values even with identical inputs — so the DUT and the testbench's reference model must use the exact same order to compare correctly.
</details>

<details>
<summary><strong>7. Why is the Logic Unit implemented as six separate modules feeding a MUX, rather than one module with a case statement?</strong></summary><br>

Both are valid, but building each operation as an independent module keeps every logic function isolated, individually reusable, and independently testable — consistent with the project's bottom-up, modular design philosophy.
</details>

<details>
<summary><strong>8. What does "exhaustive verification" mean, and why does it matter here?</strong></summary><br>

It means testing **every possible input combination** rather than a representative sample — in this case, all 1024 combinations of `A`, `B`, `CB_IN`, and `S_MUX`. For a small enough input space, this proves correctness completely rather than just building confidence.
</details>

<details>
<summary><strong>9. Why can modules be instantiated across different directories without issue?</strong></summary><br>

Verilog hierarchy is determined by module names, not file paths. As long as every required source file is passed to the compiler, files can be organized into any folder structure without affecting how modules connect.
</details>

---

## 🚀 What's Next

<div align="center">

### ➡️ Expanding the Mini ALU into a Datapath + Control Unit

*Register file · Instruction decoder · Control signals · Toward a custom CPU architecture*

</div>

---

<div align="center">

## 👨‍💻 Author

**Padma Charan S S**
Electrical and Electronics Engineering · PSG College of Technology

**Repository:** Verilog Fundamentals · **Approach:** Project-Driven Learning

### Roadmap

```text
Basic Verilog → Logic Gates → Combinational Circuits → Mini ALU
      → RTL Design → FPGA Design → Computer Architecture
      → Datapath + Control Unit → CPU Design
```

---

<a id="design-philosophy"></a>
*"The goal isn't just an ALU built from a few operators — it's a hierarchy of small, verified blocks: gates → adders/subtractors → arithmetic datapath → MUX-selected unit → complete ALU. This is how larger digital systems get built, one verified layer at a time."*

</div>