`include "defines.sv"

//including interfcae and testcase files -------------------
`include "interface.sv"
//----------------------------------------------------------

// including test files ------------------------------------        
`include "test_rand_wr_rd_fixed_addr.sv" 
// `include "test_wr_not_ready_in_addr_phase.sv" 
// `include "test_rd_not_ready_in_addr_phase.sv"  
// `include "test_wr_not_ready_in_data_phase.sv" 
// `include "test_rd_not_ready_in_data_phase.sv" 
// `include "test_sel.sv"          
// `include "test_not_ready.sv"   
// `include "test_nonseq_wr_rd.sv"   
// `include "test_seq_wr_rd.sv"          
// `include "test_idle_wr.sv"   
// `include "test_idle_rd.sv"  
// `include "test_busy_wr.sv"  
// `include "test_busy_rd.sv"  
// `include "test_WORD_wr_rd.sv"  
// `include "test_HALFWORD_wr_rd.sv" 
// `include "test_BYTE_wr_rd.sv"  
// `include "test_Idle_to_NonSeq_wr_rd.sv" 
// `include "test_Busy_to_Seq_wr_rd.sv"  
// `include "test_addr_change_in_idle.sv" 
// `include "test_error_resp.sv"     
// test for HRESETn was done in below module
//----------------------------------------------------------
// add more test benches for WRAP4, INCR4, and WORD write and HALFWORD and BYTE read 


module tbench_top();
  //clock and reset signal declaration
  bit HCLK;
  bit HRESETn;

  //creatinng instance of interface, inorder to connect DUT and testcase
  ahb3lite_bus_inf intf(HCLK, HRESETn);
  
  //Testcase instance, interface handle is passed to test as an argument
  test t1(intf);

   //clock generation
  always #5 HCLK = ~HCLK;

  //reset Generation
  initial begin
    HRESETn = 0;
    #10 HRESETn = 1;
  end
  
  //DUT instance, interface signals are connected to the DUT ports
  ahb3lite_sram1rw #(
    .MEM_SIZE      (`MEM_SIZE),
    .HADDR_SIZE    (`HADDR_SIZE),
    .HDATA_SIZE    (`HDATA_SIZE)
  ) dut (
    .HCLK(HCLK),
    .HRESETn(HRESETn),
    .HSEL(intf.HSEL),
    .HADDR(intf.HADDR),
    .HWDATA(intf.HWDATA),
    .HWRITE(intf.HWRITE),
    .HSIZE(intf.HSIZE),
    .HBURST(intf.HBURST),
    .HPROT(intf.HPROT),
    .HTRANS(intf.HTRANS),
    .HREADY(intf.HREADY),
    .HREADYOUT(intf.HREADYOUT),
    .HRESP(intf.HRESP), 
    .HRDATA(intf.HRDATA)
   );
 
endmodule