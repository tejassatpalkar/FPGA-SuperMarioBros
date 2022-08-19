//Two-always example for state machine
//Moore Machine

module dynamic_sprite (input logic Clk, Reset,
					input [7:0] keycode, keycode2,
             output [1:0] which_mario );
     
    enum logic [1:0] {STANDING, FIRST, SECOND, THIRD} curr_state, next_state; // States

    always_ff @ (posedge Clk) // frame_clk
    begin
        if (Reset)
            curr_state <= STANDING;
        else 
            curr_state <= next_state;
    end
    
    always_comb
    begin
        
        next_state  = curr_state;    
        unique case (curr_state) 

            STANDING : if (keycode == 8'h04 || keycode2 == 8'h04 || keycode == 8'h07 || keycode2 == 8'h07)
                        next_state = FIRST;
                                
				FIRST:
                begin
                    if (~(keycode == 8'h04 || keycode2 == 8'h04 || keycode == 8'h07 || keycode2 == 8'h07))                
                        next_state = STANDING;
                    else 
                        next_state = SECOND;
                end
                
            SECOND:
                begin
                    if (~(keycode == 8'h04 || keycode2 == 8'h04 || keycode == 8'h07 || keycode2 == 8'h07))                
                        next_state = STANDING;
                    else 
                        next_state = THIRD;
                end
                
            THIRD:
                begin
                    if (~(keycode == 8'h04 || keycode2 == 8'h04 || keycode == 8'h07 || keycode2 == 8'h07))                
                        next_state = STANDING;
                    else 
                        next_state = FIRST;
                end

        endcase

        case (curr_state) 
          
            STANDING: 
            begin
            
					which_mario = 0;
					
            end
                
            FIRST: 
            begin
                    
					which_mario = 2'b01;
                    
            end
				
				SECOND: 
            begin
                    
					which_mario = 2'b10;
                    
            end
				
				THIRD: 
            begin
                    
					which_mario = 2'b11;
                    
            end
                
        endcase
    end
endmodule
