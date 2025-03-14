SIM =  _tb.vvp                   
SRC =  _tb.v  ../01_src/*.v                
             
								 
all: compile simulate view       
								 
compile:                         
	iverilog -o $(SIM) $(SRC)        
								 
simulate:                        
	vvp $(SIM)                       
view:                            
	gtkwave  _tb.vcd           
								 
clean:                           
	rm -f $(SIM) *.vcd               