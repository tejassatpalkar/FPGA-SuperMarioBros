module goomba (input logic Clk, Reset, killGoomba,
//                 input logic Ball_X_Pos, 
//             output int X_Velocity, 
			 output logic isAlive);
			 
			 //Two-always example for state machine
//Moore Machine
     
    enum logic [1:0] {ON, OFF} curr_state, next_state; // States

    always_ff @ (posedge Clk or posedge Reset) // frame_clk
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

            ON: if (killGoomba)
                    next_state = OFF;
                                
                OFF:
                    next_state = OFF;

        endcase

        case (curr_state) 
          
            ON: 
            begin
            
                    isAlive = 1;                    
            end
                
            OFF: 
            begin
						
                    isAlive = 0;
					       
            end
                
        endcase
    end
endmodule 



module  goombaPos ( input Reset, frame_clk, input isAlive,
               output [9:0]  BallX, BallY 
			   );

		parameter [9:0] Ball_X_Center= 464-16;  // Center position on the X axis
		parameter [9:0] Ball_Y_Center= 479 - 32 - 16 + 1;  // Center position on the Y axis
		parameter [9:0] Ball_X_Min=3;       // Leftmost point on the X axis
		parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
		parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
		parameter [9:0] Ball_Y_Max= 479 - 32 + 1;     // Bottommost point on the Y axis
		parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
		parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
		
		logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, width, height, new_velocity, grid_X, grid_Y;
		assign width = 16;
		assign height = 16;
		
		gsm goomba_state(.Clk(frame_clk), .Reset(Reset), .X_Velocity(new_velocity)); 

		always_comb begin
		
		Ball_X_Motion = new_velocity;
					  
			 if ( (Ball_X_Pos + $signed(new_velocity) + width) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
				begin
					Ball_X_Motion = 0;  // 2's complement.
				end
					  
			else if ( $signed(Ball_X_Pos + $signed(new_velocity)) <= $signed(Ball_X_Min) )  // Ball is at the Left edge, BOUNCE!
				begin
					Ball_X_Motion = 0;
					
				end
				 
		
		end
		
		
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Goomba
        
		  if (Reset)  // Asynchronous Reset
        begin 
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end else begin
		
		if (~isAlive)
		begin
		Ball_Y_Pos <= 700;
		Ball_X_Pos <= 700;
		end
		else begin  
		Ball_Y_Pos <= Ball_Y_Center;  // Update ball position
		Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
		end
		end
	 end
			       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
					
endmodule



module gsm (input logic Clk, Reset, 
//                 input logic Ball_X_Pos, 
             output int X_Velocity
);
			 
			 //Two-always example for state machine
//Moore Machine
     
    enum logic [2:0] {STILL1, LEFT, STILL2, RIGHT} curr_state, next_state; // States
	int counter, next_count; 

    always_ff @ (posedge Clk or posedge Reset) // frame_clk
    begin
        if (Reset) begin
            curr_state <= STILL1;
			counter <= 0;
			end
        else begin
            curr_state <= next_state;
			counter <= next_count;
			end
    end
    
    always_comb
    begin
        
        next_state  = curr_state; 
		next_count = 0; 		
        unique case (curr_state) 

            STILL1: begin
				if (counter < 96) 
				begin
					next_count = counter + 1;
					next_state = STILL1;
				end
				else begin
					next_count = 0; 
					next_state = LEFT;
				end		
			end
			 LEFT: begin
				if (counter < 32) 
				begin
					next_count = counter + 1;
					next_state = LEFT;
				end
				else begin
					next_count = 0; 
					next_state = STILL2;
				end		
			end
			 STILL2: begin
				if (counter < 96) 
				begin
					next_count = counter + 1;
					next_state = STILL2;
				end
				else begin
					next_count = 0; 
					next_state = RIGHT;
				end		
			end
			 RIGHT: begin
				if (counter < 32) 
				begin
					next_count = counter + 1;
					next_state = RIGHT;
				end
				else begin
					next_count = 0; 
					next_state = STILL1;
				end		
			end
                                
                

        endcase

        case (curr_state) 
          
            STILL1, STILL2: 
            begin
            
                    X_Velocity = 0;                    
            end
                
            LEFT: 
            begin
						
                    X_Velocity = -1;
					       
            end
			
			RIGHT: 
			begin
				X_Velocity = 1; 
			end
                
        endcase
    end
endmodule 

			 
//Two-always example for state machine
//Moore Machine

module dynamic_goomba (input logic Clk, Reset,
             output which_goomba );
     
    enum logic [1:0] {ONE, TWO} curr_state, next_state; // States

    always_ff @ (posedge Clk or posedge Reset) // frame_clk
    begin
        if (Reset)
            curr_state <= ONE;
        else 
            curr_state <= next_state;
    end
    
    always_comb
    begin
        
        next_state  = curr_state;    
        unique case (curr_state) 

            ONE : begin
					next_state = TWO;
				end
			TWO: begin	
				next_state = ONE; 
				end	

        endcase

        case (curr_state) 
          
            ONE: 
            begin
            
					which_goomba = 0;
					
            end
                
            TWO: 
            begin
                    
					which_goomba = 1;
                    
            end
                
        endcase
    end
endmodule

			 

					