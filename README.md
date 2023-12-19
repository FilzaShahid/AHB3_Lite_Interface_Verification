# AHB3_Lite_Interface_Verification
To create a layered testbench architecture design in System Verilog for AHB-Lite Slave Protocol. The simulator used for this project is VCS. For compiling and simulating without gui:

    vcs -sverilog design_files/*.sv verif/*.sv tests/*.sv testbench.sv
    ./simv

For observing waveform in gui:

  vcs -lca -debug_access+all -sverilog design_files/*.sv verif/*.sv tests/*.sv testbench.sv
  ./simv -gui &
