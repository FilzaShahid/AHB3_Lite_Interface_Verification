// signal bits
`define HTRANS_SIZE 2
`define HSIZE_SIZE  3
`define HBURST_SIZE 3
`define HPROT_SIZE 4

// main parameters
`define MEM_SIZE          64       //Memory in Bytes
`define MEM_DEPTH         256     //Memory depth
`define HADDR_SIZE        16
`define HDATA_SIZE        32

// HTRANS
`define HTRANS_IDLE    0
`define HTRANS_BUSY    1
`define HTRANS_NONSEQ  2
`define HTRANS_SEQ     3

// HSIZE
`define HSIZE_BYTE  0
`define HSIZE_HWORD 1
`define HSIZE_WORD  2

//HBURST
`define HBURST_SINGLE 0 
`define HBURST_WRAP4  2
`define HBURST_INCR4  3

//HPROT
`define HPROT_DATA 1