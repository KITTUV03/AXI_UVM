`ifndef AXI_DRV
`define AXI_DRV

class axi_driver extends uvm_driver #(axi_trans);

  `uvm_component_utils(axi_driver)

  virtual intf axi_inf;

  //I have taken other sequencer handle for read operation
  uvm_seq_item_pull_port #(axi_trans) rd_item_port;

  function new(string name = "axi_driver", uvm_component parent);
    super.new(name, parent);
    rd_item_port = new("rd_item_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual intf)::get(this, "", "axi_inf", axi_inf))
      `uvm_fatal("AXI_DRIVER", "Interface Not Received in Driver")
  endfunction

  task run_phase(uvm_phase phase);
    //We're are waiting for deassertion of Reset
    wait(axi_inf.ARESETn === 1'b1);
    @(axi_inf.drv_cb);
    clear_all();
    @(axi_inf.drv_cb);

    fork
      write_channel_loop();
      read_channel_loop();
    join_none
  endtask


  task clear_all();
    axi_inf.drv_cb.AWADDR  <= 0;
    axi_inf.drv_cb.AWPROT  <= 0;
    axi_inf.drv_cb.AWVALID <= 0;

    axi_inf.drv_cb.WDATA   <= 0;
    axi_inf.drv_cb.WSTRB   <= 0;
    axi_inf.drv_cb.WVALID  <= 0;

    axi_inf.drv_cb.BREADY  <= 0;

    axi_inf.drv_cb.ARADDR  <= 0;
    axi_inf.drv_cb.ARPROT  <= 0;
    axi_inf.drv_cb.ARVALID <= 0;

    axi_inf.drv_cb.RREADY  <= 0;
  endtask


  //Perform Write Operation
  task write_channel_loop();
    axi_trans wr_pkt;
    forever begin
      seq_item_port.get_next_item(wr_pkt);
      `uvm_info("AXI_DRIVER", $sformatf("[WR CH] Received %s transaction", wr_pkt.operation.name()), UVM_HIGH)
      drive_write(wr_pkt);
      seq_item_port.item_done();
    end
  endtask

  //Perform Read Operation
  task read_channel_loop();
    axi_trans rd_pkt;
    forever begin
      rd_item_port.get_next_item(rd_pkt);
      `uvm_info("AXI_DRIVER", $sformatf("[RD CH] Received %s transaction", rd_pkt.operation.name()), UVM_HIGH)
      drive_read(rd_pkt);
      rd_item_port.item_done();
    end
  endtask


  task drive_write(axi_trans pkt);
    //Write Address Channel
    axi_inf.drv_cb.AWADDR  <= pkt.AWADDR;
    axi_inf.drv_cb.AWPROT  <= pkt.AWPROT;
    axi_inf.drv_cb.AWVALID <= 1'b1;
    @(axi_inf.drv_cb);
    while(!axi_inf.drv_cb.AWREADY)
      @(axi_inf.drv_cb);
    axi_inf.drv_cb.AWVALID <= 1'b0;
    `uvm_info("AXI_DRIVER", $sformatf("[AW HANDSHAKE] addr=0x%0h", pkt.AWADDR), UVM_HIGH)

    // Write Data Channel
    axi_inf.drv_cb.WDATA  <= pkt.WDATA;
    axi_inf.drv_cb.WSTRB  <= pkt.WSTRB;
    axi_inf.drv_cb.WVALID <= 1'b1;
    @(axi_inf.drv_cb);
    while(!axi_inf.drv_cb.WREADY)
      @(axi_inf.drv_cb);
    axi_inf.drv_cb.WVALID <= 1'b0;
    `uvm_info("AXI_DRIVER", $sformatf("[W HANDSHAKE] data=0x%0h strb=0x%0h", pkt.WDATA, pkt.WSTRB), UVM_HIGH)

    // Write Response Channel
    axi_inf.drv_cb.BREADY <= 1'b1;
    @(axi_inf.drv_cb);
    while(!axi_inf.drv_cb.BVALID)
      @(axi_inf.drv_cb);
    pkt.BRESP = axi_inf.drv_cb.BRESP;
    axi_inf.drv_cb.BREADY <= 1'b0;
    `uvm_info("AXI_DRIVER", $sformatf("[B HANDSHAKE] resp=%0d", pkt.BRESP), UVM_HIGH)

    // Clear write channel signals
    @(axi_inf.drv_cb);
    axi_inf.drv_cb.AWADDR  <= 0;
    axi_inf.drv_cb.AWPROT  <= 0;
    axi_inf.drv_cb.AWVALID <= 0;
    axi_inf.drv_cb.WDATA   <= 0;
    axi_inf.drv_cb.WSTRB   <= 0;
    axi_inf.drv_cb.WVALID  <= 0;
    axi_inf.drv_cb.BREADY  <= 0;
  endtask


  task drive_read(axi_trans pkt);
    // Read Address Channel
    axi_inf.drv_cb.ARADDR  <= pkt.ARADDR;
    axi_inf.drv_cb.ARPROT  <= pkt.ARPROT;
    axi_inf.drv_cb.ARVALID <= 1'b1;
    @(axi_inf.drv_cb);
    while(!axi_inf.drv_cb.ARREADY)
      @(axi_inf.drv_cb);
    axi_inf.drv_cb.ARVALID <= 1'b0;
    `uvm_info("AXI_DRIVER", $sformatf("[AR HANDSHAKE] addr=0x%0h", pkt.ARADDR), UVM_HIGH)

    //  Read Data Channel
    axi_inf.drv_cb.RREADY <= 1'b1;
    @(axi_inf.drv_cb);
    while(!axi_inf.drv_cb.RVALID)
      @(axi_inf.drv_cb);
    pkt.RDATA = axi_inf.drv_cb.RDATA;
    pkt.RRESP = axi_inf.drv_cb.RRESP;
    axi_inf.drv_cb.RREADY <= 1'b0;
    `uvm_info("AXI_DRIVER", $sformatf("[R HANDSHAKE] data=0x%0h resp=%0d", pkt.RDATA, pkt.RRESP), UVM_HIGH)

    @(axi_inf.drv_cb);
    axi_inf.drv_cb.ARADDR  <= 0;
    axi_inf.drv_cb.ARPROT  <= 0;
    axi_inf.drv_cb.ARVALID <= 0;
    axi_inf.drv_cb.RREADY  <= 0;
  endtask

endclass

`endif
