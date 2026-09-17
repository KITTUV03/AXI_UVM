`ifndef AXI_TRANS
`define AXI_TRANS

typedef enum {idle, single_w, single_r, b2b_w, b2b_r} operation_type;

class axi_trans extends uvm_sequence_item;
  
  //WRITE ADDRESS CHANNEL
  rand bit [`ADDR_WIDTH-1:0]  AWADDR;
  rand bit [2:0]              AWPROT;
  
  //WRITE DATA CHANNEL
  rand bit [`DATA_WIDTH-1:0]  WDATA;
  rand bit [`STRB_WIDTH-1:0]  WSTRB;
  
  //WRITE RESPONSE 
  bit [1:0]                   BRESP;
  
  //READ ADDRESS CHANNEL  
  rand bit [`ADDR_WIDTH-1:0]  ARADDR;
  rand bit [2:0]              ARPROT;
  
  //READ DATA 
  bit [`DATA_WIDTH-1:0]       RDATA;
  bit [1:0]                   RRESP;
  
  //OPERATION TYPE
  rand operation_type         operation;

  `uvm_object_utils_begin(axi_trans)
    `uvm_field_enum(operation_type, operation, UVM_ALL_ON)
    `uvm_field_int(AWADDR, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(AWPROT, UVM_ALL_ON)
    `uvm_field_int(WDATA,  UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(WSTRB,  UVM_ALL_ON | UVM_BIN)
    `uvm_field_int(ARADDR, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(ARPROT, UVM_ALL_ON)
    `uvm_field_int(BRESP,  UVM_ALL_ON)
    `uvm_field_int(RDATA,  UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(RRESP,  UVM_ALL_ON)
  `uvm_object_utils_end
  

  function new(string name = "axi_trans");
    super.new(name);
  endfunction
  
  
  
  
  constraint aligned_address {
    AWADDR[1:0] == 2'b00;
    ARADDR[1:0] == 2'b00;
  }
  
  constraint valid_address_range {
    AWADDR[31:6] == 0;
    ARADDR[31:6] == 0;
    AWADDR[5:2] inside {[0:9], 15};
    ARADDR[5:2] inside {[0:12], 15};
  }

  constraint slv_err_address {
    AWADDR[31:6] == 0;
    ARADDR[31:6] == 0;
    AWADDR[5:2] inside {[10:12]};
    ARADDR[5:2] inside {[13:14]};
  }
  
  
  constraint dec_err_address {
    AWADDR >= (`MEM_DEPTH * 4);
    ARADDR >= (`MEM_DEPTH * 4);
    AWADDR[1:0] == 2'b00;
    ARADDR[1:0] == 2'b00;
    AWADDR <= 32'h0000_00FF;
    ARADDR <= 32'h0000_00FF;
  }
  
  constraint default_prot {
    AWPROT == 3'b000;
    ARPROT == 3'b000;
  }
  
  constraint default_wstrb {
    WSTRB == 4'hF;
  }
  
  
endclass
`endif
