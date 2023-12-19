`include "environment.sv"
program test(ahb3lite_bus_inf intf);
  
  class my_trans extends transaction;
    bit [3:0] count;

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
      HSIZE = 2;
      HTRANS = 2;
      HBURST = 0;

      case (count)
        0 : begin
              HWDATA = 32'ha;
              HADDR = 4;
              HWRITE = 1;
              HREADY = 0;
            end
        1 : begin
              HWDATA = 32'hb;
              HADDR = 4;
              HWRITE = 1;
              HREADY = 0;
            end
        2 : begin
              HWDATA = 32'hc;
              HADDR = 4;
              HWRITE = 1;
              HREADY = 1;
            end
        3 : begin
              HWDATA = 32'hd;
              HADDR = 4;
              HWRITE = 1;
              HREADY = 1;
            end
      endcase

      if (count == 4) count = 0;

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
    env.gen.repeat_count = 4;
    env.gen.trans = my_tr;

    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram