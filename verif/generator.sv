class generator;
  
    rand transaction trans,tr;           //declaring transaction class 
    int  repeat_count;                   //repeat count, to specify number of items to generate
    mailbox gen2driv;                    //mailbox, to generate and send the packet to driver
    event ended;                         //event
    
    //constructor
    function new(input mailbox gen2driv,input event ended);
      //getting the mailbox handle from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
      this.gen2driv = gen2driv;
      this.ended    = ended;
      trans = new();
    endfunction
    
    //main task, generates(create and randomizes) the repeat_count number of transaction packets and puts into mailbox
    task main();
      repeat(repeat_count) begin
        if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");      
        tr = trans.copy();
        gen2driv.put(tr);
        //$info("[Generator] Transaction generated successfully");
        //trans.print_trans();
      end
      -> ended; 
    endtask
    
  endclass