//Two-always example for state machine
//Moore Machine

module super_mario (input logic Clk, Reset, collision,
             output logic superMario);
     
    enum logic [1:0] {LITTLE, BIG} curr_state, next_state; // States

    always_ff @ (posedge Clk) // frame_clk
    begin
        if (Reset)
            curr_state <= LITTLE;
        else 
            curr_state <= next_state;
    end
    
    always_comb
    begin
        
        next_state  = curr_state;    
        unique case (curr_state) 

            LITTLE: if (collision)
					next_state = BIG;
                                
				BIG:
					next_state = BIG;

        endcase

        case (curr_state) 
          
            LITTLE: 
            begin
            
					superMario = 0;
					
            end
                
            BIG: 
            begin
                    
					superMario = 1;
                    
            end
                
        endcase
    end
endmodule
