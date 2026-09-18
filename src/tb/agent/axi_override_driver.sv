`ifndef AXI_COVERAGE_DRIVER
`define AXI_COVERAGE_DRIVER


class axi_override_driver extends axi_driver;

  `uvm_component_utils(axi_override_driver)

  function new(string name = "axi_override_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task drive_write(axi_trans pkt);
    int order;
    order = $urandom_range(0, 2); 
    case (order)
      0: begin // WDATA First, then AWADDR 
        `uvm_info("COV_DRV", "[WDATA FIRST] Driving WDATA before AWADDR", UVM_HIGH)
        // Write Data Channel
        axi_inf.drv_cb.WDATA  <= pkt.WDATA;
        axi_inf.drv_cb.WSTRB  <= pkt.WSTRB;
        axi_inf.drv_cb.WVALID <= 1'b1;
        @(axi_inf.drv_cb);
        while(!axi_inf.drv_cb.WREADY)
          @(axi_inf.drv_cb);
        axi_inf.drv_cb.WVALID <= 1'b0;

        
        repeat($urandom_range(0, 2)) @(axi_inf.drv_cb);

    
        axi_inf.drv_cb.AWADDR  <= pkt.AWADDR;
        axi_inf.drv_cb.AWPROT  <= pkt.AWPROT;
        axi_inf.drv_cb.AWVALID <= 1'b1;
        @(axi_inf.drv_cb);
        while(!axi_inf.drv_cb.AWREADY)
          @(axi_inf.drv_cb);
        axi_inf.drv_cb.AWVALID <= 1'b0;
      end

      1: begin //Simultaneous Address and Data 
        `uvm_info("COV_DRV", "[SIMULTANEOUS] Driving AWVALID and WVALID together", UVM_HIGH)
        fork
          begin
            axi_inf.drv_cb.AWADDR  <= pkt.AWADDR;
            axi_inf.drv_cb.AWPROT  <= pkt.AWPROT;
            axi_inf.drv_cb.AWVALID <= 1'b1;
            @(axi_inf.drv_cb);
            while(!axi_inf.drv_cb.AWREADY)
              @(axi_inf.drv_cb);
            axi_inf.drv_cb.AWVALID <= 1'b0;
          end
          begin
            axi_inf.drv_cb.WDATA  <= pkt.WDATA;
            axi_inf.drv_cb.WSTRB  <= pkt.WSTRB;
            axi_inf.drv_cb.WVALID <= 1'b1;
            @(axi_inf.drv_cb);
            while(!axi_inf.drv_cb.WREADY)
              @(axi_inf.drv_cb);
            axi_inf.drv_cb.WVALID <= 1'b0;
          end
        join
      end

      2: begin // AWADDR First, then WDATA
        `uvm_info("COV_DRV", "[AWADDR FIRST] Driving AWADDR before WDATA", UVM_HIGH)
        axi_inf.drv_cb.AWADDR  <= pkt.AWADDR;
        axi_inf.drv_cb.AWPROT  <= pkt.AWPROT;
        axi_inf.drv_cb.AWVALID <= 1'b1;
        @(axi_inf.drv_cb);
        while(!axi_inf.drv_cb.AWREADY)
          @(axi_inf.drv_cb);
        axi_inf.drv_cb.AWVALID <= 1'b0;

        repeat($urandom_range(0, 2)) @(axi_inf.drv_cb);

        axi_inf.drv_cb.WDATA  <= pkt.WDATA;
        axi_inf.drv_cb.WSTRB  <= pkt.WSTRB;
        axi_inf.drv_cb.WVALID <= 1'b1;
        @(axi_inf.drv_cb);
        while(!axi_inf.drv_cb.WREADY)
          @(axi_inf.drv_cb);
        axi_inf.drv_cb.WVALID <= 1'b0;
      end
    endcase

    
    repeat($urandom_range(0, 2)) @(axi_inf.drv_cb);
    axi_inf.drv_cb.BREADY <= 1'b1;
    @(axi_inf.drv_cb);
    while(!axi_inf.drv_cb.BVALID)
      @(axi_inf.drv_cb);
    pkt.BRESP = axi_inf.drv_cb.BRESP;
    axi_inf.drv_cb.BREADY <= 1'b0;

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


  // Overridden drive_read

  virtual task drive_read(axi_trans pkt);
    // Read Address Channel
    axi_inf.drv_cb.ARADDR  <= pkt.ARADDR;
    axi_inf.drv_cb.ARPROT  <= pkt.ARPROT;
    axi_inf.drv_cb.ARVALID <= 1'b1;
    @(axi_inf.drv_cb);
    while(!axi_inf.drv_cb.ARREADY)
      @(axi_inf.drv_cb);
    axi_inf.drv_cb.ARVALID <= 1'b0;


    repeat($urandom_range(0, 2)) @(axi_inf.drv_cb);
    axi_inf.drv_cb.RREADY <= 1'b1;
    @(axi_inf.drv_cb);
    while(!axi_inf.drv_cb.RVALID)
      @(axi_inf.drv_cb);
    pkt.RDATA = axi_inf.drv_cb.RDATA;
    pkt.RRESP = axi_inf.drv_cb.RRESP;
    axi_inf.drv_cb.RREADY <= 1'b0;

    @(axi_inf.drv_cb);
    axi_inf.drv_cb.ARADDR  <= 0;
    axi_inf.drv_cb.ARPROT  <= 0;
    axi_inf.drv_cb.ARVALID <= 0;
    axi_inf.drv_cb.RREADY  <= 0;
  endtask

endclass

`endif
