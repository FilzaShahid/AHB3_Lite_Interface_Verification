`include "defines.sv"
class transaction;   
    // rand logic                       HRESETn;         // Asynchronous active low reset
    rand logic                       HSEL;            // Bus Select
    rand logic    [ `HADDR_SIZE-1:0] HADDR;           // Address Bus
    rand logic    [ `HDATA_SIZE-1:0] HWDATA;          // Write Data Bus
    rand logic                       HWRITE;          // Write Select
    rand logic    [ `HSIZE_SIZE-1:0] HSIZE;           // Transfer Size
    rand logic    [`HBURST_SIZE-1:0] HBURST;          // Transfer Burst Size
    rand logic    [ `HPROT_SIZE-1:0] HPROT;           // Transfer Protection Level
    rand logic    [`HTRANS_SIZE-1:0] HTRANS;          // Transfer Type
    rand logic                       HREADY;          // Transfer Ready Input
    logic                            HREADYOUT;       // Transfer Ready Output
    logic         [ `HDATA_SIZE-1:0] HRDATA;          // Read Data Bus
    logic                            HRESP;           // Transfer Response

    // Single burst, 4-beat wrapping burst and 4-beat increment burst
    constraint C_HBURST {                             
        (HBURST == `HBURST_SINGLE || HBURST == `HBURST_WRAP4 || HBURST == `HBURST_INCR4);
        // HBURST inside {3'b000, 3'b010, 3'b011};    
    }

    // Address aligned w.r.t. Size
    constraint C_HADDR_align_with_HSIZE {             
        if (HSIZE == `HSIZE_HWORD) {
            HADDR % 2 == 0;
        }
        else if (HSIZE == `HSIZE_WORD) {
            HADDR % 4 == 0;
        }
    }

    // Protection control for Data Access only
    constraint C_HPROT {                              
        HPROT == `HPROT_DATA;
    }

    // Transfer sizes of byte, half word and word only
    constraint C_HSIZE {                              
        (HSIZE == `HSIZE_BYTE  || HSIZE == `HSIZE_HWORD || HSIZE == `HSIZE_WORD);
        // HSIZE inside {3'b000 , 3'b001, 3'b010};  
    }

    // print_trans method to print the transaction item values for debug purposes
    function void print_trans();                     
        $display("HSEL = %0h, HADDR = %0h, HWDATA = %0h, HWRITE = %0h, HSIZE = %0h, HBURST = %0h, HPROT = %0h, HTRANS = %0h, HREADY = %0h, HREADYOUT = %0h, HRDATA = %0h, HRESP = %0h", HSEL, HADDR, HWDATA, HWRITE, HSIZE, HBURST, HPROT, HTRANS, HREADY, HREADYOUT, HRDATA, HRESP);
    endfunction
    
    // making a trans method
    function transaction copy();
        transaction trans;
        trans = new();
        trans.HSEL = this.HSEL;
        trans.HADDR = this.HADDR;
        trans.HWDATA = this.HWDATA;
        trans.HWRITE = this.HWRITE;
        trans.HSIZE = this.HSIZE;
        trans.HBURST = this.HBURST;
        trans.HPROT = this.HPROT;
        trans.HTRANS = this.HTRANS;
        trans.HREADY = this.HREADY;
        trans.HREADYOUT = this.HREADYOUT;
        trans.HRDATA = this.HRDATA;
        trans.HRESP = this.HRESP;
        return trans;
    endfunction
endclass