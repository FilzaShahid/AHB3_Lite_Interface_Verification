`include "environment.sv"
program test(ahb3lite_bus_inf intf);
  //declaring environment instance
  environment env;
  
  initial begin
    //creating environment
    env = new(intf);
    
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 20;

    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram