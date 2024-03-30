//This module debounces push buttons switches

module sw_debouncer (
		input clk, 
		input rst, 
		input PB, 
		
		output DEBOUNCED
    );

    reg debounced;
	wire sync_0;
	wire sync_1;
	reg [16:0] counter; //a 17 bit counter will max out around 3ms
    
	wire counter_max = &counter; //1 when the timer overflows
	wire idle = ( debounced==sync_1 );

	assign DEBOUNCED = debounced;
    assign sync_0 = ~PB;
	assign sync_1 = sync_0; 

    always @( posedge clk ) begin
        if ( !rst ) begin
			debounced <= 0;
			counter <= 0;   
        end
        else begin
			if ( idle ) begin
				counter <= 0; 
			end
			else begin
				counter <= counter + 1;
				if ( counter_max ) begin
					debounced <= ~debounced;
				end
			end
		end
    end
endmodule
    
    
    
    