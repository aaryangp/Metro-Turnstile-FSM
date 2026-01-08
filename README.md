# 🚇 Metro Turnstile FSM (Finite State Machine)

This project implements a **Metro Turnstile Controller** using a **Finite State Machine (FSM)** in Verilog.  
The FSM validates an access code and controls the opening of a metro entry gate for a fixed duration.

---

## 🧠 FSM Overview

The turnstile operates in **three states**:

- **IDLE** – Waiting for user input
- **CHECK_CODE** – Verifying the access code
- **ACCESS_GRANTED** – Opening the gate for a limited time

The FSM transitions between these states based on the `validate_code`, `access_code`, and an internal `counter`.

---

## 🔁 State Transition Table

| Current State | Input Condition                         | Next State        | Output |
|--------------|------------------------------------------|-------------------|--------|
| IDLE         | `validate_code = 1`                      | CHECK_CODE        | none   |
| IDLE         | `validate_code = 0`                      | IDLE              | none   |
| CHECK_CODE   | `4 ≤ access_code ≤ 11`                   | ACCESS_GRANTED    | none   |
| CHECK_CODE   | other                                    | IDLE              | none   |
| ACCESS_GRANTED | `counter == 15`                        | IDLE              | none   |
| ACCESS_GRANTED | other                                  | ACCESS_GRANTED    | `open_access_door = 1` |

---

## 🧾 Input Signals

| Signal | Width | Description |
|------|------|-------------|
| `clk` | 1 | System clock |
| `rst` | 1 | Active-low reset |
| `access_code` | 4 | User-entered access code |
| `validate_code` | 1 | Pulse to validate access code |

---

## 📤 Output Signals

| Signal | Width | Description |
|------|------|-------------|
| `open_access_door` | 1 | Opens the metro gate |
| `state_out` | 2 | Current FSM state |

---

## ⏱️ Counter Behavior

- The counter runs **only in `ACCESS_GRANTED` state**
- It increments on every clock cycle
- When `counter == 15`, the FSM:
  - Closes the door
  - Returns to `IDLE`

---

## ⚙️ FSM Design Style

- **State register** → Sequential logic
- **Next-state logic** → Combinational logic
- **Output logic** → Moore-style (depends only on state)
- `validate_code` is treated as a **pulse**, not a level

---

## ✅ Key Design Rules Followed

- One register driven by **one always block**
- No combinational loops
- No latches inferred
- Safe, glitch-free control signals
- Industry-standard FSM coding style

---

## 🧪 Testbench Behavior

The testbench:
- Generates a clock
- Applies reset
- Sends **single-cycle pulses** on `validate_code`
- Tests both valid and invalid access codes
- Confirms correct FSM transitions and door timing

---

## 📌 Summary

This FSM models a **real-world metro turnstile system**, ensuring:
- Secure access validation
- Controlled gate opening
- Deterministic timing
- Clean FSM behavior

---

## 📁 Files

- `metrofsm.v` – FSM implementation
- `metrofsm_tb.v` – Testbench
- `metrofsm.vcd` – Simulation waveform

---

💡 *This project is ideal for learning FSM design, Verilog coding style, and hardware-safe control logic.*

