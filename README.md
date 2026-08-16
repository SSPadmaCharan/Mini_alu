# Mini_alu
Design and verification of a 4-bit combinational Mini-ALU in Verilog HDL, featuring modular arithmetic and logic units, hierarchical RTL design, status flags, and automated self-checking testbenches.

<div align="center">

# ⚙️ Mini ALU — 4-Bit Combinational Arithmetic Logic Unit

### From Isolated Gates to an Integrated Processor Datapath

*A hierarchical RTL design project — [Verilog Fundamentals](#)*

[![Verilog](https://img.shields.io/badge/HDL-Verilog-1f6feb?style=flat-square)](#)
[![Design](https://img.shields.io/badge/Design-Hierarchical%20RTL-9b59b6?style=flat-square)](#)
[![Operations](https://img.shields.io/badge/Operations-8-e67e22?style=flat-square)](#)
[![Simulator](https://img.shields.io/badge/Simulator-Icarus%20Verilog-orange?style=flat-square)](#)
[![Waveform](https://img.shields.io/badge/Waveform-GTKWave-2ea44f?style=flat-square)](#)
[![Status](https://img.shields.io/badge/Status-In%20Development-yellow?style=flat-square)](#)

</div>

---

## 📖 Overview

This project designs and builds a **4-bit Combinational Arithmetic Logic Unit (ALU)** in Verilog HDL — the centerpiece project of this repository so far.

Every prior project modeled **one circuit**: a gate, an adder, a decoder. The Mini-ALU is different. It's an **integrated digital subsystem** — multiple functional units (logic, arithmetic, selection, status flags) composed together into a single reusable datapath component, exactly like the ALU sitting at the heart of every CPU.

> This project marks the shift from **circuit design** to **system design**: from writing one Boolean equation to architecting a hierarchy of modules that work together.

**This project will deliver:**

- 🔹 A dedicated **Logic Unit** (AND, OR, XOR, NAND, NOR, XNOR)
- 🔹 A dedicated **Arithmetic Unit** built on a 4-bit Ripple Carry Adder
- 🔹 Two's-complement **subtraction** reusing the same adder hardware
- 🔹 **Operation selection** via a 3-bit `sel` input
- 🔹 **Carry**, **Zero**, and **Parity** status flags
- 🔹 A fully **hierarchical, modular RTL architecture**
- 🔹 An automated **self-checking testbench** with an independent reference model

---

## 🎯 Objectives

- 🔹 Design a complete 4-bit combinational ALU
- 🔹 Apply previously learned combinational-logic concepts inside an integrated system
- 🔹 Learn **hierarchical RTL design** and module instantiation
- 🔹 Build reusable Verilog modules (full adder → ripple carry adder → arithmetic unit)
- 🔹 Integrate a logic unit and an arithmetic unit under one top-level module
- 🔹 Use multiplexed selection to choose between eight ALU operations
- 🔹 Generate arithmetic status flags (Carry, Zero, Parity)
- 🔹 Develop an automated, self-checking testbench with an independent reference model
- 🔹 Verify the complete design through simulation and GTKWave waveform analysis

---

## 📚 Prerequisites

| Topic | Why it matters |
|---|---|
| Logic Gates (AND, OR, XOR, NAND, NOR, XNOR) | Directly reused inside the Logic Unit |
| Full Adder / Half Adder | Core building block of the Ripple Carry Adder |
| Multiplexers | Powers operation selection |
| Parity Generator | Reused concept for the Parity flag |
| Reduction Operators (`&`, `|`, `^`) | Generate Zero and Parity flags |
| Module Instantiation & Hierarchy | Structure of the entire ALU |
| Self-Checking Testbenches | Verification methodology |

---

## 🧠 What Is an ALU?

An **Arithmetic Logic Unit (ALU)** is a digital circuit that performs arithmetic and logic operations on binary data — the computational core of every processor.

<table>
<tr>
<td valign="top" width="50%">

**Arithmetic Operations**
- Addition
- Subtraction

</td>
<td valign="top" width="50%">

**Logical Operations**
- AND · OR · XOR
- NAND · NOR · XNOR

</td>
</tr>
</table>

The Mini-ALU is a simplified, educational implementation of this concept — small enough to fully understand, structured enough to mirror real processor design.

---

## 🧾 Mini-ALU Specification

| Signal | Width | Description |
|---|:-:|---|
| `A` | 4 bits | First operand |
| `B` | 4 bits | Second operand |
| `sel` | 3 bits | Operation select |
| `result` | 4 bits | ALU output |
| `carry` | 1 bit | Carry-out flag |
| `zero` | 1 bit | Zero-result flag |
| `parity` | 1 bit | Parity of result |

### Operation Selection

| `sel[2:0]` | Operation | Type |
|:-:|:--|:-:|
| `000` | AND | Logic |
| `001` | OR | Logic |
| `010` | XOR | Logic |
| `011` | NAND | Logic |
| `100` | NOR | Logic |
| `101` | XNOR | Logic |
| `110` | **ADD** | Arithmetic |
| `111` | **SUBTRACT** | Arithmetic |

Eight operations, selected by a single 3-bit control signal.

---

## 🔌 Top-Level Block Diagram

```
                              MINI ALU
                                 │
              ┌───────────────────┴───────────────────┐
              │                                       │
              ▼                                       ▼
      ┌───────────────┐                       ┌───────────────┐
      │  LOGIC UNIT    │                       │  ARITHMETIC    │
      │  AND·OR·XOR    │                       │     UNIT       │
      │ NAND·NOR·XNOR  │                       │  ADD · SUB     │
      └───────┬────────┘                       └───────┬────────┘
              │                                       │
        Logic Results                        Arithmetic Results
              │                                       │
              └───────────────────┬───────────────────┘
                                 │
                                 ▼
                          ┌─────────────┐
                 sel ────▶│  SELECTOR   │
                          │   (MUX)     │
                          └──────┬──────┘
                                 │
                                 ▼
                          RESULT [3:0]
                                 │
                  ┌───────────────┼───────────────┐
                  ▼               ▼               ▼
               CARRY            ZERO           PARITY
```

---

## 🏗️ Hierarchical RTL Architecture

The defining goal of this project is **hierarchical RTL design** — composing a large system from small, independently verified modules rather than one monolithic block.

```
mini_alu
│
├── logic_unit
│   ├── and_gate
│   ├── or_gate
│   ├── xor_gate
│   ├── nand_gate
│   ├── nor_gate
│   └── xnor_gate
│
└── arithmetic_unit
    │
    ├── ripple_carry_adder
    │   ├── full_adder  (bit 0)
    │   ├── full_adder  (bit 1)
    │   ├── full_adder  (bit 2)
    │   └── full_adder  (bit 3)
    │
    └── subtraction logic  (two's complement)
```

Each leaf module is designed and tested **independently** before integration — the same bottom-up discipline used in real hardware design flows.

---

## 🔷 Logic Unit

The Logic Unit performs all six bitwise logic operations on `A[3:0]` and `B[3:0]` in parallel, each producing an independent 4-bit result:

```
                        LOGIC UNIT
                            │
         ┌──────────┬───────┼───────┬──────────┐
         ▼          ▼       ▼       ▼          ▼
        AND         OR     XOR    NAND        NOR
         │          │       │       │          │
         └──────────┴───────┼───────┴──────────┘
                            ▼
                          XNOR
```

**Example — AND operation:**

```
A = 1010
B = 1100
    ────
    1000
```

Every operation follows the same bit-by-bit pattern; the selector later picks which result reaches the output.

---

## 🔶 Arithmetic Unit

The Arithmetic Unit handles **addition** and **subtraction**, built on a **4-bit Ripple Carry Adder** composed of four reusable **Full Adder** modules.

### 4-Bit Ripple Carry Adder

```
       A0  B0
        │
        ▼
     ┌──────┐
Cin ▶│ FA0  │▶ S0
     └──┬───┘
        │ C1
        ▼
     ┌──────┐
A1 ▶│ FA1  │▶ S1
B1 ▶│      │
     └──┬───┘
        │ C2
        ▼
     ┌──────┐
A2 ▶│ FA2  │▶ S2
B2 ▶│      │
     └──┬───┘
        │ C3
        ▼
     ┌──────┐
A3 ▶│ FA3  │▶ S3
B3 ▶│      │
     └──┬───┘
        │
        ▼
      Cout
```

Each Full Adder passes its carry-out to the next stage's carry-in — the carry **ripples** through the chain, which gives the architecture its name.

### 4-Bit Addition & Carry

Adding two 4-bit numbers can produce a **5-bit** result:

```
      1111
    + 1111
    ──────
     11110
```

$$\{\text{Carry}, \text{Result}[3:0]\} = \{1, 1110\}$$

The ALU keeps a 4-bit main result and surfaces the extra bit through the **Carry flag**.

### Subtraction via Two's Complement

Subtraction reuses the *same* adder hardware:

$$A - B \;=\; A + (\overline{B}) + 1$$

Inverting `B` and injecting a carry-in of `1` turns the ripple carry adder into a subtractor — no separate subtractor circuit required.

---

## 🎛️ Operation Selection

Once the Logic Unit and Arithmetic Unit have both computed their results, a multiplexer driven by `sel[2:0]` picks the one that reaches the output:

```
        Logic Results ──┐
                        │
                        ▼
                    ┌───────┐
                    │  MUX  │──▶ RESULT
                    └───────┘
                        ▲
                        │
      Arithmetic Results┘
                        ▲
                        │
                       sel
```

This is the point where the Logic Unit and Arithmetic Unit stop being separate circuits and become **one ALU**.

---

## 🚦 Status Flags

<table>
<tr>
<td valign="top" width="33%">

**🔺 Carry Flag**

Captures the carry-out from arithmetic operations.

```
1111 + 0001
─────────
   10000

Result = 0000
Carry  = 1
```

Critical for unsigned arithmetic and multi-word addition.

</td>
<td valign="top" width="33%">

**⭕ Zero Flag**

HIGH whenever the result is `0000`. Built with a reduction NOR:

```verilog
zero = ~|result;
```

Used constantly in real CPUs for branch/compare logic.

</td>
<td valign="top" width="33%">

**➗ Parity Flag**

Reuses the Parity Generator concept via reduction XOR:

```verilog
parity = ^result;
```

Bridges an earlier project directly into this one.

</td>
</tr>
</table>

---

## 💡 New Verilog Concepts

This project is deliberately structured to introduce new concepts **as the design demands them**, rather than in isolation:

<table>
<tr>
<td valign="top" width="50%">

- Hierarchical RTL design
- Module instantiation & interfaces
- Reusable, multi-level module hierarchy
- Internal wires connecting sub-modules
- Structural **and** behavioral RTL in one design

</td>
<td valign="top" width="50%">

- `case`-based operation selection
- Reduction operators (`&`, `|`, `^`)
- Parameterization (where useful)
- Two's-complement arithmetic in hardware
- Integrated, self-checking verification

</td>
</tr>
</table>

---

## 🧪 Verification Strategy

The Mini-ALU is verified using an **automated, self-checking testbench** that exercises:

```
Logic Operations  ·  Arithmetic Operations  ·  Carry Generation
Subtraction  ·  Zero Detection  ·  Parity Generation  ·  Edge Cases
```

Every applied input is checked against an **independently calculated expected value** — not a copy of the DUT's own logic.

```
                        Inputs
                          │
              ┌───────────┴───────────┐
              ▼                       ▼
           DUT ALU              Reference Model
              │                       │
              ▼                       ▼
          Actual Output         Expected Output
              │                       │
              └───────────┬───────────┘
                          ▼
                       Compare
                          │
                    ┌─────┴─────┐
                    ▼           ▼
                  PASS        FAIL
```

A running failure counter and a final PASS/FAIL summary are produced at the end of simulation.

---

## 🌊 Waveform Verification

```verilog
$dumpfile("waveform.vcd");
$dumpvars(...);
```

Waveforms (viewed in GTKWave) will be used to confirm:

- Input transitions across `A`, `B`, and `sel`
- Correct operation selection
- Logic Unit and Arithmetic Unit results
- Carry behavior across operations
- Zero and Parity flag correctness
- Final ALU output timing

---

## 📂 Project Structure

```
Mini_ALU/
├── README.md
│
├── rtl/
│   ├── logic_unit/
│   │   ├── and.v
│   │   ├── or.v
│   │   ├── xor.v
│   │   ├── nand.v
│   │   ├── nor.v
│   │   ├── xnor.v
│   │   └── logic_unit.v
│   │
│   ├── arithmetic_unit/
│   │   ├── full_adder.v
│   │   ├── ripple_carry_adder.v
│   │   └── arithmetic_unit.v
│   │
│   └── mini_alu.v
│
├── tb/
│   ├── logic_unit_tb.v
│   ├── arithmetic_unit_tb.v
│   └── mini_alu_self_checking_tb.v
│
├── Images/
│   └── waveform.png
│
└── Docs/
    ├── architecture.md
    └── design_notes.md
```

> 🚧 Structure will evolve as the design develops — this is the current plan.

---

## 🔄 Design Flow

```
Individual Logic Modules
        ↓
     Logic Unit
        ↓
    Full Adder
        ↓
 Ripple Carry Adder
        ↓
  Arithmetic Unit
        ↓
 Operation Selector
        ↓
      Mini ALU
        ↓
    Status Flags
        ↓
Self-Checking Testbench
        ↓
  Waveform Analysis
```

### Development Methodology

Each module is designed and verified **independently** before integration:

```
Design → RTL Implementation → Testbench → Simulation
   → Self-Checking Verification → Waveform Analysis → Integration
```

This bottom-up approach mirrors real hardware development, keeps debugging tractable, and demonstrates a structured, professional RTL design methodology.

---

## 🌟 Applications

The concepts demonstrated here are foundational to nearly all of digital computing:

<table>
<tr>
<td valign="top" width="50%">

**Computing Systems**
- CPUs & microcontrollers
- Processor datapaths
- Computer architecture

</td>
<td valign="top" width="50%">

**Hardware Design**
- FPGA designs
- Embedded systems & controllers
- Digital signal processing systems

</td>
</tr>
</table>

Although this is a small educational ALU, its architecture captures the core idea behind every real processor: combining multiple functional units into a coherent datapath.

---

## 🎓 Learning Outcomes

<table>
<tr>
<td valign="top" width="50%">

**Architecture**
- 4-bit ALU architecture
- Hierarchical & structural RTL
- Ripple carry addition & propagation
- Two's-complement subtraction
- MUX-based operation selection

</td>
<td valign="top" width="50%">

**Verification & Practice**
- Module instantiation & reuse
- Reduction operators
- Status flag generation
- Self-checking, reference-model testbenches
- GTKWave waveform analysis

</td>
</tr>
</table>

---

## 🚀 Future Improvements

<table>
<tr>
<td valign="top" width="50%">

- Parameterized ALU width
- Increment / decrement operations
- Comparison operations
- Shift & rotate operations

</td>
<td valign="top" width="50%">

- Overflow detection
- Signed arithmetic support
- Additional status flags
- FPGA hardware implementation

</td>
</tr>
</table>

---

## ✅ Conclusion

The Mini-ALU marks the transition from designing **individual combinational circuits** to designing an **integrated digital subsystem**.

It draws together nearly everything this repository has built so far — logic gates, full adders, multiplexers, parity generation, and combinational RTL — into one hierarchical architecture, composed of a Logic Unit and an Arithmetic Unit under a single top-level module.

It also introduces a more rigorous verification methodology: automated, self-checking testbenches backed by an independent reference model, paired with waveform-level analysis.

```
Individual Components → Reusable Modules → Functional Units
        → Integrated ALU → Verification
```

This project is the bridge between basic Verilog combinational-circuit exercises and the larger RTL systems ahead — processor datapaths and full CPU architectures.

---

<div align="center">

## 👨‍💻 Author

**Padma Charan S S**

**Repository:** Mini ALU· **Approach:** Project- ALU FOR BASIC 

### 🧩 About This Project

Unlike the earlier projects in this repository — where each one introduced a single new concept in isolation — the **Mini-ALU is a capstone build**: it takes everything learned so far (logic gates, adders, multiplexers, parity generation, hierarchical RTL, self-checking verification) and combines it into one integrated system.

*This project doesn't teach a new concept — it proves the old ones can work together.*

### 🗺️ Repository Roadmap

```
Logic Gates
    ↓
Combinational Circuits
    ↓
Full Adder
    ↓
4-bit Ripple Carry Adder
    ↓
Logic Unit
    ↓
Arithmetic Unit
    ↓
MUX / Operation Selection
    ↓
4-bit Mini-ALU
    ↓
Status Flags
    ↓
Self-Checking Verification
    ↓
Hierarchical RTL Design
    ↓
FPGA Implementation
```

---

> *"The Mini-ALU is where isolated logic gates finally become a machine — the first project where the whole is genuinely more than the sum of its parts."*

</div>
