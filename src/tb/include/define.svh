`define CLOCK_FREQ 100 //Mhz
`define DUTY_CYCLE 50

`define time_period 1000.0/`CLOCK_FREQ //In ns
`define high (`time_period * `DUTY_CYCLE)/100 
`define low (`time_period - `high) 



`define COMP_CNSTR(CLASS_NAME)\
function new(string name = "CLASS_NAME",uvm_component parent);\
  super.new(name,parent);\
endfunction
  
`define OBJ_CNSTR(CLASS_NAME)\
function new(string name = "CLASS_NAME");\
  super.new(name);\
endfunction
  

`define DATA_WIDTH 32
`define ADDR_WIDTH 32
`define MEM_DEPTH  16
`define STRB_WIDTH (`DATA_WIDTH)/8

`define TIME_OUT 100
`define NUM_OF_TRANS 70

