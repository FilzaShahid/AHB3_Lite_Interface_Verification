`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;
  
  //generator and driver instance
  generator  gen;
  driver     driv;
  monitor    mon;
  scoreboard scb;
  
  //mailbox handle's
  mailbox gen2driv;
  mailbox mon2scb;
  
  //event for synchronization between generator and test
  event gen_ended;
  event drv_done;
  
  //virtual interface
  virtual ahb3lite_bus_inf vif;
  
  //constructor
  function new(virtual ahb3lite_bus_inf vif);
    //get the interface from test
    this.vif = vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2driv = new();
    mon2scb  = new();
    
    //creating generator and driver
    gen  = new(gen2driv,gen_ended);
    driv = new(vif,gen2driv,drv_done);
    mon  = new(vif,mon2scb,drv_done);
    scb  = new(mon2scb);
  endfunction
  
  //
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
    gen.main();
    driv.main();
    mon.main();
    scb.main();      
    join_any
  endtask
  
  task post_test();
    wait(gen_ended.triggered);
    wait(gen.repeat_count == driv.no_transactions);
    wait(gen.repeat_count == scb.no_transactions);
    $display("\nSummary: \n \t Total no. of Transactions = %0d \n \t No. of Matches    = %0d \n \t No. of MisMatches = %0d \n", gen.repeat_count, scb.no_matches, scb.no_mismatches);
    if (scb.no_matches == gen.repeat_count) begin
      $display("\t TEST HAS PASSED SUCCESSFULLY. \n");
    end
    else begin
      $display("\t TEST HAS FAILED. \n");
    end
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
  
endclass

