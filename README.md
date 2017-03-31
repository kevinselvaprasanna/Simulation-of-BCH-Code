Simulation-of-BCH-Code
======================

About
-----
An implementation of narrow-sense BCH code with n=127 and d=15 on F_128 generated using x^7+x^3+1. 

* The program finds the generator polynomial for the designed code.
* Finds the parity check matrix.
* Implements BM algorithm for finding the error locator polynomial's coefficients.

For a detailed explaination of the algorithm see `report.pdf`

Requirements
------------
* Matlab 2016b

Instructions to run the code
----------------------------
* The `main.m` file is the main file and should be run to see the output.
* The message words should be placed in `msg.txt` file by default(Can be changed in `main.m`).
* The program outputs the encoded codewords in the file `codeword.txt`.
* The received vectors should be placed in `rx.txt` file by default(Can be changed in `main.m`).
* The program outputs the corrected codewords and decoded message in the file `decoderOut.txt` on seperate lines.

Contents
--------
* `main.m` - Main file that calls the encoder and decoder of the BCH codes.
* `bch.m` - A bch class which implements encode, decode and various other methods.
* `berlekamp_massey.m` - Code for BM Algorithm used to get the coefficients of the error locator polynomial.
* `gflog.m` - logarithm of elements in the finite field.
* `read_file.m` - Function to read the inputs.
* `gen_msg.m` - Generates random messages, used for testing.
