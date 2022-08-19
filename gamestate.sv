module game_state (input logic Clk, Reset, initGameOver, peach,
						 input [7:0] keycode, keycode2,
						 output logic gameover, startScreen, win);
             
//Two-always example for state machine
//Moore Machine
     
    enum logic [2:0] {START, ON, OFF, WIN} curr_state, next_state; // States

    always_ff @ (posedge Clk or posedge Reset) // frame_clk
    begin
        if (Reset)
            curr_state <= START;
        else 
            curr_state <= next_state;
    end
    
    always_comb
    begin
        
        next_state  = curr_state;    
        unique case (curr_state) 
				
				START:
					if ((keycode == 8'd40) || (keycode2 == 8'd40))
						next_state = ON;

            ON:
				begin
					if (initGameOver)
						next_state = OFF;
				   
					if (peach)
						next_state = WIN;
				end
                                
            OFF:
                  next_state = OFF;
						
				WIN: if (initGameOver)
                    next_state = OFF;

        endcase

        case (curr_state) 
				
				START:
				begin
					startScreen = 1;
					gameover = 0;
					win = 0;
				end
          
            ON: 
            begin
					gameover = 0;  
					startScreen = 0;
					win = 0;
            end
                
            OFF: 
            begin       
					gameover = 1;
					startScreen = 0;
					win = 0;
            end
				
				WIN: 
				begin
					startScreen = 0;
					gameover = 0;
					win = 1;
				end
					
                
        endcase
    end
endmodule 