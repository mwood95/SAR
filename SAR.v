///////////////////////////////////////////////////////////////////////////////////////////////////////
// Developer: Michael Wood
// Date: 10/22/2017
// Description: This module implements a 4-bit Successive Approximation Register
// (SAR). This model verifies the high level functionality of the block. The
// ultimate design will result in an IC implemetation of a SAR ADC chip.

///////////////////////////////////////////////////////////////////////////////////////////////////////
module SAR(input in, input clock, input rst, output reg [3:0] out, state, next_state, output reg valid);

//////////////////////////////////////////////////////////////////////////////////////////////////////
// State Description using ONE-HOT encoding method
///////////////////////////////////////////////////////////////////////////////////////////////////// 
  localparam B3     = 4'b0001;
  localparam B2     = 4'b0010;
  localparam B1     = 4'b0100;
  localparam B0     = 4'b1000;
  localparam DONE   = 4'b0000; 
 
 // Bit set values for SAR state machine 
  localparam B3SET  = 4'b1000;
  localparam B2SET  = 3'b100;
  localparam B1SET  = 2'b10;
  localparam B0SET  = 1'b1;
  

 // Start State Machine  
  always @ (posedge clock or posedge rst)
    begin 
      if(rst)
        begin
        state <= B3;
        next_state <= B2;
        valid <= 1'b0;
        end
      else
        state <= next_state;
      
    end

 // Set ouput in each state
  always@(state)
    begin
      case(state)
        B3:
          begin
            out <= B3SET;
            next_state <= B2;
          end
        
        B2:
          begin
            if(in)
              begin
                out[3] <= 1;
              end
            else
              begin
                out[3] <= 0;
              end
            out[2:0] <= B2SET;
            next_state <= B1;
          end
        
        B1:
          begin
            if(in)
              begin
                out[2] <= 1;
              end
            else
              begin
                out[2] <= 0;
              end
             out[1:0] <= B1SET;
            next_state <= B0;
          end
        
        B0:
          begin
            if(in)
              begin
                out[1] <= 1;
              end
            else
              begin
                out[1] <= 0;
              end
            out[0] <= B0SET;
            next_state <= DONE;
          end
        
        DONE:
          begin
            if(in)
              begin
                out[0] <= 1;
              end
            else
              begin
                out[0] <= 0;
              end
            valid <= 1;
            next_state <= B3;
          end
      endcase
    end
  
endmodule 
