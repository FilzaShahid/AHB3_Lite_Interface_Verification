`define DRIV_IF vif.DRIVER.driver_cb
class driver;
  
    int no_transactions;                    //used to count the number of transactions
    virtual ahb3lite_bus_inf vif;               //creating virtual interface handle
    mailbox gen2driv;                       //creating mailbox handle
    event drv_done;
  //constructor
    function new(input virtual ahb3lite_bus_inf vif, input mailbox gen2driv, input event drv_done);
        this.vif = vif;       //getting the interface
        this.gen2driv = gen2driv;     //getting the mailbox handles from  environment
        this.drv_done = drv_done;
    endfunction
  
    //Reset task, Reset the Interface signals to default/initial values
    task reset;
        wait(!vif.HRESETn);
        $display("--------- [DRIVER] Reset Started ---------");  
        `DRIV_IF.HSEL <= 0;
        `DRIV_IF.HADDR <= 0;
        `DRIV_IF.HWDATA <= 0;
        `DRIV_IF.HWRITE <= 0;
        `DRIV_IF.HSIZE <= 0;
        `DRIV_IF.HBURST <= 0;
        `DRIV_IF.HPROT <= 0;
        `DRIV_IF.HTRANS <= 0;   
        `DRIV_IF.HREADY <= 0;     
        wait(vif.HRESETn);
        $display("--------- [DRIVER] Reset Ended ---------");
    endtask
  
  //drivers the transaction items to interface signals
    task drive;
        transaction trans;
        trans = new();
        gen2driv.get(trans);
        `DRIV_IF.HADDR <= trans.HADDR;
        `DRIV_IF.HSEL <= trans.HSEL; 
        `DRIV_IF.HSIZE <= trans.HSIZE; 
        `DRIV_IF.HPROT <= trans.HPROT;
        `DRIV_IF.HTRANS <= trans.HTRANS; 
        `DRIV_IF.HBURST <= trans.HBURST; 
        `DRIV_IF.HWRITE <= trans.HWRITE; 
        `DRIV_IF.HREADY <= trans.HREADY; 
        @(posedge vif.DRIVER.HCLK);
        `DRIV_IF.HWDATA <= trans.HWDATA;
        //$info("[Driver]: Value recieved in driver. Transaction: %d", no_transactions);
        no_transactions++;
        -> drv_done;
        #1;
    endtask

    task main;
        wait(vif.HRESETn);
        forever
            drive();
    endtask
        
endclass

