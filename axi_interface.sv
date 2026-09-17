interface intf(input ACLK, input ARESETn);
  
  //WRITE ADDRESS CHANNEL
  logic [`ADDR_WIDTH-1:0] AWADDR;
  logic [2:0]             AWPROT;
  logic                   AWVALID;
  logic                   AWREADY;
  
  //WRITE DATA CHANNEL
  logic [`DATA_WIDTH-1:0] WDATA;
  logic [`STRB_WIDTH-1:0] WSTRB;
  logic                   WVALID;
  logic                   WREADY;
  
  //WRITE RESPONSE CHANNEL
  logic [1:0]             BRESP;
  logic                   BVALID;
  logic                   BREADY;
  
  //READ ADDRESS CHANNEL  
  logic [`ADDR_WIDTH-1:0] ARADDR;
  logic [2:0]             ARPROT;
  logic                   ARVALID;
  logic                   ARREADY;
  
  //READ DATA CHANNEL  
  logic [`DATA_WIDTH-1:0] RDATA;
  logic [1:0]             RRESP;
  logic                   RVALID;
  logic                   RREADY;
  
  
  clocking drv_cb @(posedge ACLK);
    default input #1 output #0;
    output AWADDR, AWPROT, AWVALID;
    output WDATA, WSTRB, WVALID;
    output BREADY;
    output ARADDR, ARPROT, ARVALID;
    output RREADY;
    input  AWREADY, WREADY;
    input  BRESP, BVALID;
    input  ARREADY;
    input  RDATA, RRESP, RVALID;
  endclocking
  
  clocking mon_cb @(posedge ACLK);
    default input #1 output #0;
    input AWADDR, AWPROT, AWVALID, AWREADY;
    input WDATA, WSTRB, WVALID, WREADY;
    input BRESP, BVALID, BREADY;
    input ARADDR, ARPROT, ARVALID, ARREADY;
    input RDATA, RRESP, RVALID, RREADY;
  endclocking
  
  
  modport drv_mp(clocking drv_cb, input ACLK, input ARESETn);
  modport mon_mp(clocking mon_cb, input ACLK, input ARESETn);
  
  
endinterface
