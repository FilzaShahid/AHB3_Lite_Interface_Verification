`include "defines.sv"
class scoreboard;
    mailbox mon2scb;                 //creating mailbox handle
    int no_transactions;             //used to count the number of transactions
    logic [`HDATA_SIZE-1:0] memory_temp [256];
    int no_matches, no_mismatches;
    
    //constructor
    function new(input mailbox mon2scb);
      this.mon2scb = mon2scb;     //getting the mailbox handles from  environment
      foreach(memory_temp[i]) memory_temp[i] = 32'hxxxxxxxx;
    endfunction

    task write_in_mem(input transaction trans);
      case (trans.HSIZE)
        3'b000 : begin                     // BYTE case 
          case (trans.HADDR[1:0])
            2'b00 : begin
              memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][7:0] = trans.HWDATA[7:0];
              if (trans.HWDATA[7:0] == memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][7:0]) begin
                $display("[Scoreboard-WRITE-BYTE-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
                no_matches++;
              end
              else begin
                $display("[Scoreboard-WRITE-BYTE-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
                no_mismatches++;
              end
            end
            2'b01 : begin
              memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][15:8] = trans.HWDATA[15:8];
              if (trans.HWDATA[15:8] == memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][15:8]) begin
                $display("[Scoreboard-WRITE-BYTE-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
                no_matches++;
              end
              else begin
                $display("[Scoreboard-WRITE-BYTE-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
                no_mismatches++;
              end
            end
            2'b10 : begin
              memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][23:16] = trans.HWDATA[23:16];
              if (trans.HWDATA[23:16] == memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][23:16]) begin
                $display("[Scoreboard-WRITE-BYTE-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
                no_matches++;
              end
              else begin
                $display("[Scoreboard-WRITE-BYTE-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
                no_mismatches++;
              end
            end
            2'b11 : begin
              memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][31:24] = trans.HWDATA[31:24];
              if (trans.HWDATA[`HDATA_SIZE-1:24] == memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][`HDATA_SIZE-1:24]) begin
                $display("[Scoreboard-WRITE-BYTE-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
                no_matches++;
              end
              else begin
                $display("[Scoreboard-WRITE-BYTE-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
                no_mismatches++;
              end
            end
          endcase  
        end
        3'b001 : begin                     // HALFWORD case 
          case (trans.HADDR[0])
            1'b0 : begin
              memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][15:0] = trans.HWDATA[15:0];
              if (trans.HWDATA[15:0] == memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][15:0]) begin
                $display("[Scoreboard-WRITE-HALFWORD-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
                no_matches++;
              end
              else begin
                $display("[Scoreboard-WRITE-HALFWORD-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
                no_mismatches++;
              end
            end
            1'b1 : begin
              memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][31:16] = trans.HWDATA[31:16];
              if (trans.HWDATA[`HDATA_SIZE-1:16] == memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][`HDATA_SIZE-1:16]) begin
                $display("[Scoreboard-WRITE-HALFWORD-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
                no_matches++;
              end
              else begin
                $display("[Scoreboard-WRITE-HALFWORD-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
                no_mismatches++;
              end
            end
          endcase
        end
        3'b010 : begin                     // WORD case 
          memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][`HDATA_SIZE-1:0] = trans.HWDATA;
          if (trans.HWDATA == memory_temp[trans.HADDR[`HADDR_SIZE-1:2]][`HDATA_SIZE-1:0]) begin
            $display("[Scoreboard-WRITE-WORD-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
            no_matches++;
          end
          else begin
            $display("[Scoreboard-WRITE-WORD-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HWDATA);
            no_mismatches++;
          end
        end
      endcase
    endtask

    task read_from_mem(input transaction trans);
      case (trans.HSIZE)
        3'b000 : begin
          case (trans.HADDR[1:0])
            2'b00 : begin
              if (memory_temp[trans.HADDR[15:2]][7:0] !==  trans.HRDATA[7:0]) begin
                $display("[Scoreboard-READ-BYTE-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]][7:0],trans.HRDATA);
              end
              else begin
                $display("[Scoreboard-READ-BYTE-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]][7:0],trans.HRDATA);
              end 
            end
            2'b01 : begin
              if (memory_temp[trans.HADDR[15:2]][15:8] !==  trans.HRDATA[15:8]) begin
                $display("[Scoreboard-READ-BYTE-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]][15:8],trans.HRDATA);
              end
              else begin
                $display("[Scoreboard-READ-BYTE-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]][15:8],trans.HRDATA);
              end 
            end
            2'b10 : begin
              if (memory_temp[trans.HADDR[15:2]][23:16] !==  trans.HRDATA[23:16]) begin
                $display("[Scoreboard-READ-BYTE-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]][23:16],trans.HRDATA);
              end
              else begin
                $display("[Scoreboard-READ-BYTE-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]][23:16],trans.HRDATA);
              end 
            end
            2'b11 : begin
              if (memory_temp[trans.HADDR[15:2]][31:23] !==  trans.HRDATA[31:23]) begin
                $display("[Scoreboard-READ-BYTE-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]][31:24],trans.HRDATA);
              end
              else begin
                $display("[Scoreboard-READ-BYTE-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]][31:24],trans.HRDATA);
              end 
            end
          endcase
        end
        3'b001 : begin
          case (trans.HADDR[0])
            1'b0 : begin
              if (memory_temp[trans.HADDR[15:2]][15:0] !==  trans.HRDATA[15:0]) begin
                $display("[Scoreboard-READ-HALFWORD-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]][15:0],trans.HRDATA);
              end
              else begin
                $display("[Scoreboard-READ-HALFWORD-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]][15:0],trans.HRDATA);
              end 
            end
            1'b1 : begin
              if (memory_temp[trans.HADDR[15:2]][31:16] !==  trans.HRDATA[31:16]) begin
                $display("[Scoreboard-READ-HALFWORD-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]][31:16],trans.HRDATA);
              end
              else begin
                $display("[Scoreboard-READ-HALFWORD-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]][31:16],trans.HRDATA);
              end 
            end
          endcase
        end
        3'b010 : begin
          if (memory_temp[trans.HADDR[15:2]] !==  trans.HRDATA) begin
            $display("[Scoreboard-READ-WORD-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]],trans.HRDATA);
          end
          else begin
            $display("[Scoreboard-READ-WORD-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[15:2]],trans.HRDATA);
            
          end 
        end
      endcase
      // if (memory_temp[trans.HADDR[`HADDR_SIZE-1:2]] !==  trans.HRDATA) begin
      //   $display("[Scoreboard-READ-WORD-TEST-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HRDATA);
      //   no_mismatches++;
      // end
      // else begin
      //   $display("[Scoreboard-READ-WORD-TEST-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,memory_temp[trans.HADDR[`HADDR_SIZE-1:2]],trans.HRDATA);
      //   no_matches++;
      // end 
    endtask

    task not_ready_idle_busy(input transaction trans);
      if (trans.HTRANS == 0) begin
        $display("[Scoreboard-Idle] Slave is idle.");
        if (trans.HRDATA === 32'hx) begin
          $display("[Scoreboard-Idle-Test-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,32'hx,trans.HRDATA);
          no_matches++;
        end
        else begin
          $display("[Scoreboard-Idle-Test-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,32'hx,trans.HRDATA);
          no_mismatches++;
        end
        no_transactions++;
      end
      else if (trans.HTRANS == 1) begin
        $display("[Scoreboard-Busy] Slave is busy.");
        if (trans.HRDATA === 32'hx) begin
          $display("[Scoreboard-Busy-Test-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,32'hx,trans.HRDATA);
          no_matches++;
        end
        else begin
          $display("[Scoreboard-Busy-Test-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,32'hx,trans.HRDATA);
          no_mismatches++;
        end
        no_transactions++;
      end
      else begin
        $display("[Scoreboard-Not-Ready] Slave is not ready yet.");
        if (trans.HRDATA === 32'hx) begin
          $display("[Scoreboard-Not-Ready-Test-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,32'hx,trans.HRDATA);
          no_matches++;
        end
        else begin
          $display("[Scoreboard-Not-Ready-Test-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,32'hx,trans.HRDATA);
          no_mismatches++;
        end
        no_transactions++;
      end
    endtask
    
    //stores wdata and compare rdata with stored data
    task main;
        transaction trans;
        forever begin
          trans = new();
          mon2scb.get(trans);
          $info("[SCOREBOARD-ENTER] Data successfully recieved in scoreboard. Transaction %0d-----------------------------", no_transactions);
          //trans.print_trans();
          if (trans.HSEL) begin
            $display("[Scoreboard-Selection] Slave is connected.");
            if (trans.HREADY) begin
              $display("[Scoreboard-Ready] Slave is Ready for the transfer.");
              if (trans.HPROT) begin
                $display("[Scoreboard-Protection] Proctection for Data access only is Valid.");
                if (trans.HWRITE) begin
                  write_in_mem(trans);
                end
                else begin
                  read_from_mem(trans);
                end
                no_transactions++;
                //trans.print_trans();
              end
              else begin
                $display("[Scoreboard] Protection for Data access only is not Valid.");
                no_transactions++;
              end
            end
            else begin
              not_ready_idle_busy(trans);  
            end
          end
          else begin
            if (!trans.HSEL) begin
              $display("[Scoreboard] Slave is not connected.");
              if (trans.HRDATA === 32'hx) begin
                $display("[Scoreboard-Slave-Not-Connected-Test-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,32'hx,trans.HRDATA);
                no_matches++;
              end
              else begin
                $display("[Scoreboard-Slave-Not-Connected-Test-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.HADDR,32'hx,trans.HRDATA);
                no_mismatches++;
              end
              no_transactions++;
            end
          end
          $info("[SCOREBOARD-LEAVE] Successfully leaving scoreboard. ----------------------------------------------------------------");
        end
    endtask
    
  endclass