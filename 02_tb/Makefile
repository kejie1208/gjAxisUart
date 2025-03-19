SIM =  gjAxisUartTop_tb.vvp                   
SRC =  ./gjAxisUartTop_tb.sv  ../01_src/*.v                
             
								 
all: compile simulate view       
								 
compile:                         
	iverilog -o $(SIM) $(SRC)   -g2005-sv    
	#verilator -cc $(SIM) $(SRC)     
								 
simulate:                        
	vvp $(SIM)                       
view:                            
	gtkwave  gjAxisUartTop_tb.vcd           
								 
clean:                           
	rm -f $(SIM) *.vcd               