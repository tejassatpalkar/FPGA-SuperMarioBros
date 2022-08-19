//Two-always example for state machine
//Moore Machine

module jump (input logic Clk, Reset, current_jumping, 
                 input logic Ball_Y_Pos, input [7:0] keycode, keycode2,
             output int Y_Velocity );
     
     enum logic [5:0] {GROUND, JUMP1, JUMP2, JUMP3, JUMP4, JUMP5, JUMP6, JUMP7, JUMP8, JUMP9, JUMP10, JUMP11, JUMP12, JUMP13, JUMP14, JUMP15,
								JUMP16, JUMP17, JUMP18, JUMP19, JUMP20} curr_state, next_state; // States

    always_ff @ (posedge Clk) // frame_clk
    begin
        if (Reset)
            curr_state <= GROUND;
        else 
            curr_state <= next_state;
    end
    
    always_comb
    begin
        
        next_state  = curr_state;    
        unique case (curr_state) 

            GROUND : if (current_jumping && (keycode == 8'h1A || keycode2 == 8'h1A))                // In our reset state, if we see a run we should start adding
                        next_state = JUMP1;
							else if (current_jumping)
								next_state = JUMP15;
                                
            JUMP1:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else 
                        next_state = JUMP2;
                end
                
                JUMP2:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else 
                        next_state = JUMP3;
                end
                
                JUMP3:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else 
                        next_state = JUMP4;
                end
                
                JUMP4:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else 
                        next_state = JUMP5;
                end
                
                JUMP5:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP6;
                end
                
                JUMP6:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP7;
                end
                
                JUMP7:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP8;
                end
                
                JUMP8:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP9;
                end
                
                JUMP9:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP10;
                end
					 JUMP10:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP11;
                end
					 JUMP11:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP12;
                end
					 JUMP12:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP13;
                end
					 JUMP13:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP14;
                end
					 JUMP14:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP15;
                end
					 JUMP15:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP16;
                end
					 JUMP16:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP17;
                end
					 JUMP17:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP18;
                end
					 JUMP18:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP19;
                end
					 JUMP19:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP20;
                end
					 
                
                JUMP20:
                begin
                    if (~current_jumping)                
                        next_state = GROUND;
                    else
                        next_state = JUMP20;
                end
           

        endcase

        case (curr_state) 
          
               GROUND: 
            begin
                     Y_Velocity = 0;
            end
                
                JUMP1: 
            begin
                    
                    Y_Velocity = -10;
                    
            end
                
                JUMP2: 
            begin
                    
                    Y_Velocity = -8;
                    
            end
                
                JUMP3: 
            begin
                    
                    Y_Velocity = -8;
                    
            end
                
                JUMP4: 
            begin
                    
                    Y_Velocity = -7;
                    
            end
                
                JUMP5: 
            begin
                    
                    Y_Velocity = -7;
                    
            end
                
                JUMP6: 
            begin
                    
                    Y_Velocity = -6;
                    
            end
                
				    JUMP7: 
            begin
                    
                    Y_Velocity = -5;
                    
            end
				    JUMP8: 
            begin
                    
                    Y_Velocity = -5;
                    
            end
				    JUMP9: 
            begin
                    
                    Y_Velocity = -4;
                    
            end
				    JUMP10: 
            begin
                    
                    Y_Velocity = -4;
                    
            end
				    JUMP11: 
            begin
                    
                    Y_Velocity = -3;
                    
            end
				    JUMP12: 
            begin
                    
                    Y_Velocity = -3;
                    
            end
				    JUMP13: 
            begin
                    
                    Y_Velocity = -2;
                    
            end
				    JUMP14: 
            begin
                    
                    Y_Velocity = -2;
                    
            end
				    JUMP15: 
            begin
                    
                    Y_Velocity = 1;
                    
            end
				    JUMP16: 
            begin
                    
                    Y_Velocity = 1;
                    
            end
				    JUMP17: 
            begin
                    
                    Y_Velocity = 2;
                    
            end
                
                JUMP18: 
            begin
                    
                    Y_Velocity = 4;
                    
            end
                
                JUMP19: 
            begin
                    
                    Y_Velocity = 4;
                    
            end
                
                JUMP20: 
            begin
                    
                    Y_Velocity = 6;
                    
            end
                
        endcase
    end
endmodule
