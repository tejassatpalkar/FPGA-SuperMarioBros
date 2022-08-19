//Two-always example for state machine
//Moore Machine

module mushroom (input logic Clk, Reset, collision,
             output logic mushroom_on);
     
    enum logic [1:0] {ON, OFF} curr_state, next_state; // States

    always_ff @ (posedge Clk) // frame_clk
    begin
        if (Reset)
            curr_state <= ON;
        else 
            curr_state <= next_state;
    end
    
    always_comb
    begin
        
        next_state  = curr_state;    
        unique case (curr_state) 

            ON: if (collision)
					next_state = OFF;
                                
				OFF:
					next_state = OFF;

        endcase

        case (curr_state) 
          
            ON: 
            begin
            
					mushroom_on = 1;
					
            end
                
            OFF: 
            begin
                    
					mushroom_on = 0;
                    
            end
                
        endcase
    end
endmodule
