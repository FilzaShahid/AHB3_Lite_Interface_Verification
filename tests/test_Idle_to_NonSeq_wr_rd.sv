`include "environment.sv"
program test(ahb3lite_bus_inf intf);
  
  class my_trans extends transaction;
    bit [4:0] count;
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

      case (count)
        0 : begin
                HADDR = 16'h44;
                HTRANS = 2;
                HBURST = 0;
                HREADY = 1;
                HWRITE = 1;
                HWDATA = 32'h92392;
            end
        1 : begin
                HADDR = 16'h54;
                HTRANS = 2;
                HBURST = 0;
                HREADY = 1;
                HWRITE = 1;
                HWDATA = 32'h92392;
            end
        2 : begin
                HADDR = 16'h48;
                HTRANS = 2;
                HBURST = 0;
                HREADY = 1;
                HWDATA = 32'h43f55;
            end
        3 : begin
                HADDR = 16'h60;
                HTRANS = 2;
                HBURST = 3;
                HREADY = 1;
                HWRITE = 1;
                HWDATA = 32'hfd343;
            end
        4 : begin
                HADDR = 16'h64;
                HTRANS = 2;
                HBURST = 3;
                HREADY = 1;
                HWRITE = 1;
                HWDATA = 32'h23434;
            end
        5 : begin
                HADDR = 16'h68;
                HTRANS = 2;
                HBURST = 3;
                HREADY = 1;
                HWRITE = 1;
                HWDATA = 32'hadf3432;
            end
        6 : begin
                HADDR = 16'h6c;
                HTRANS = 2;
                HBURST = 3;
                HREADY = 1;
                HWRITE = 1;
                HWDATA = 32'h235436;
            end
        7 : begin
                HADDR = 0;
                HTRANS = 2;
                HBURST = 0;
                HREADY = 1;
                HWRITE = 1;
                HWDATA = 32'h235436;
            end
        8 : begin
                HADDR = 16'h44;
                HTRANS = 2;
                HBURST = 0;
                HREADY = 1;
                HWRITE = 0;
                HWDATA = 32'h325345af;
            end
        9 : begin
                HADDR = 16'h54;
                HTRANS = 0;
                HBURST = 0;
                HREADY = 0;
                HWRITE = 0;
            end
        10 : begin
                HADDR = 16'h48;
                HTRANS = 0;
                HBURST = 0;
                HREADY = 0;
                HWRITE = 0;
            end
        11 : begin
                HADDR = 16'h60;
                HTRANS = 2;
                HBURST = 3;
                HREADY = 0;
                HWRITE = 0;
            end
        12 : begin
                HADDR = 16'h60;
                HTRANS = 2;
                HBURST = 3;
                HREADY = 0;
                HWRITE = 0;
            end
        13 : begin
                HADDR = 16'h60;
                HTRANS = 2;
                HBURST = 3;
                HREADY = 1;
                HWRITE = 0;
            end
        14 : begin
                HADDR = 16'h64;
                HTRANS = 3;
                HBURST = 3;
                HREADY = 1;
                HWRITE = 0;
            end
        15 : begin
                HADDR = 16'h68;
                HTRANS = 3;
                HBURST = 3;
                HREADY = 1;
                HWRITE = 0;
            end
        16 : begin
                HADDR = 16'h6c;
                HTRANS = 3;
                HBURST = 3;
                HREADY = 1;
                HWRITE = 0;
            end
      endcase

      if (count == 17) count = 0;

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
    env.gen.repeat_count = 17;
    env.gen.trans = my_tr;

    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram