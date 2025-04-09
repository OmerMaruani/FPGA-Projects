# FPGA-Projects

**This repository contains Verilog implementations of various digital systems, demonstrating key concepts in digital logic design, including shifting lights, stopwatch functionality, and matrix multiplication. The projects are developed using both Verilog and VHDL, and are simulated in ModelSim.**

### Project Files

- **src**: Contains the main Verilog code for logic implementations.
- **sim**: Contains the testbenches and simulation files for ModelSim/Questa to verify the design.
- **par**: The place and route files used to implement the design on FPGA hardware through Quartus.

### Project1 shifting_lights
The shifting lights project simulates a simple on/off control system using digital logic in Verilog. It consists of a pulse generator to create a clock signal at a slower frequency, a shift register to manage the state of the light, and a direction control to manage the light's shifting behavior. 

### Project2 Stopwatch
The Stopwatch project implements a digital stopwatch with start/stop, clear, and lap functionalities using Verilog. It includes a pulse generator, counter, and 7-segment display to show time in seconds and hundredths of a second. The project demonstrates handling real-time events, synchronization, and user input for a functional embedded system.

### Project3 Matrix Multiplication
The Matrix Multiplication project involves using RAM to store input data, followed by a data generator to feed the multiplication operation. The design includes multiplying the matrices using Verilog components, storing the result in RAM, and displaying the output on 7-segment displays. This project demonstrates data handling, memory management, and arithmetic processing in hardware.
