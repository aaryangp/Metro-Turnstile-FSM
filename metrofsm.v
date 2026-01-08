module metrofsm(
    input clk,rst,
    input [3:0] access_code ,
    input validate_code,
    output reg open_access_door ,
    output [1:0] state_out
  );

  parameter IDLE = 2'b00 ;
  parameter CHECK_CODE = 2'b01 ;
  parameter ACCESS_GRANTED = 2'b10 ;

  reg [3:0] counter ;
  reg [1:0] ps,ns ;


  always@(posedge clk or negedge rst)
  begin
    if(!rst)
    begin
      ps <= IDLE ;
    end
    else
      ps <= ns ;

   case(ps)
      IDLE :
      begin
        open_access_door <= 1'b0 ;
      end
      CHECK_CODE :
      begin
        open_access_door <= 1'b0 ;
      end

      ACCESS_GRANTED :
      begin
        if(counter != 4'hF)
          open_access_door <= 1'b1 ;
        else
          open_access_door <= 1'b0 ;
      end
    endcase
end
  
assign state_out = ps ;

  always @(posedge clk or negedge rst)
  begin
    if(!rst)
    counter <= 4'h0 ;
    else if(ps == ACCESS_GRANTED)
      counter <= counter + 4'h1;
    else
      counter <= 4'd0;
  end

  always@(*)
  begin
    ns = IDLE ;

    case(ps)

      IDLE :
      begin 
        if(validate_code)
          ns = CHECK_CODE ;
        else
          ns = IDLE ;
      end

      CHECK_CODE:
      begin
        if((access_code >= 4'd4) && (access_code <= 4'd11))
          ns = ACCESS_GRANTED ;
        else
          ns = IDLE ;

      end

      ACCESS_GRANTED:
      begin 
       
        if(counter == 4'hF)
          ns = IDLE ;
        else
          ns = ACCESS_GRANTED ;
      end

      default :
        ns = IDLE ;

    endcase
  end


endmodule
