`include "environment.sv"
program test(ahb3lite_bus_inf intf);
  
  class my_trans extends transaction;
    bit [2:0] count;
    function void pre_randomize();
      HADDR.rand_mode(0);
      HSEL.rand_mode(0);
      HSIZE.rand_mode(0);
      HTRANS.rand_mode(0);
      HBURST.rand_mode(0);
      HREADY.rand_mode(0);
      HWRITE.rand_mode(0);
      HWDATA.rand_mode(0);
      HSEL = 1;
      HBURST = 0;
      HWRITE = 1;
      HSIZE = 2;

      case (count)
        0 : begin
                HADDR = 16'h4;
                HTRANS = 2;
                HREADY = 1;
                HWDATA = 32'h92392;
            end
        1 : begin
                HADDR = 16'h8;
                HTRANS = 2;
                HREADY = 0;
                HWDATA = 32'h23f4d;
            end
        2 : begin
                HADDR = 16'h8;
                HTRANS = 2;
                HREADY = 0;
                HWDATA = 32'h23f4d;
            end
        3 : begin
                HTRANS = 0;
                HREADY = 1;
            end
        4 : begin
                HTRANS = 0;
                HREADY = 1;
            end
      endcase

      if (count == 5) count = 0;

      count++;
    endfunction
  endclass

  //declaring environment instance
  environment env;
  my_trans my_tr;
  
  initial begin
    //creating environment
    env = new(intf);
    my_tr = new();
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 5;
    env.gen.trans = my_tr;

    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram