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
      HSEL = 1;
      HTRANS = 2;
      HBURST = 0;
      HREADY = 1;
      HSIZE = 2;

      case (count)
        0 : begin
                HADDR = 0;
                HWRITE = 1;
            end
        1 : begin
                HADDR = 4;
                HWRITE = 1;
            end
        2 : begin
                HADDR = 8;
                HWRITE = 1;
            end
        3 : begin
                HADDR = 12;
                HWRITE = 1;
            end
        4 : begin
                HADDR = 0;
                HWRITE = 0;
            end
        5 : begin
                HADDR = 4;
                HWRITE = 0;
            end
        6 : begin
                HADDR = 8;
                HWRITE = 0;
            end
        7 : begin
                HADDR = 12;
                HWRITE = 0;
            end
      endcase

      if (count == 8) count = 0;

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
    env.gen.repeat_count = 10;
    env.gen.trans = my_tr;

    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram