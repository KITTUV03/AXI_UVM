`ifndef AXI_MON
`define AXI_MON

class axi_monitor extends uvm_monitor;
  `uvm_component_utils(axi_monitor)

  virtual intf axi_inf;
  uvm_analysis_port #(axi_trans) write_ap;
  uvm_analysis_port #(axi_trans) read_ap;

  function new(string name = "axi_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    write_ap = new("write_ap", this);
    read_ap  = new("read_ap",  this);
    if(!uvm_config_db #(virtual intf)::get(this, "", "axi_inf", axi_inf))
      `uvm_fatal("AXI_MONITOR", "Interface Not Received in Monitor")
  endfunction

  task run_phase(uvm_phase phase);
    wait(axi_inf.ARESETn === 1'b1);
    @(axi_inf.mon_cb);

    fork
      monitor_write_channel();
      monitor_read_channel();
    join_none
  endtask


  task monitor_write_channel();
    axi_trans wr_trans;
    bit addres_captured, data_captured;

    forever begin
      addres_captured = 0;
      data_captured  = 0;
      wr_trans = axi_trans::type_id::create("wr_trans");
      wr_trans.operation = single_w;

      while (!(addres_captured && data_captured)) begin
        @(axi_inf.mon_cb);
        if (!axi_inf.ARESETn) begin
          addres_captured = 0;
          data_captured  = 0;
          wr_trans = axi_trans::type_id::create("wr_trans");
          wr_trans.operation = single_w;
          wait(axi_inf.ARESETn === 1'b1);
          @(axi_inf.mon_cb);
          continue;
        end

        // AW handshake
        if (!addres_captured && axi_inf.mon_cb.AWVALID && axi_inf.mon_cb.AWREADY) begin
          wr_trans.AWADDR = axi_inf.mon_cb.AWADDR;
          wr_trans.AWPROT = axi_inf.mon_cb.AWPROT;
          addres_captured = 1;
          `uvm_info("AXI_MONITOR", $sformatf("[AW CAPTURED] addr=0x%08h", wr_trans.AWADDR), UVM_HIGH)
        end

        // W handshake
        if (!data_captured && axi_inf.mon_cb.WVALID && axi_inf.mon_cb.WREADY) begin
          wr_trans.WDATA = axi_inf.mon_cb.WDATA;
          wr_trans.WSTRB = axi_inf.mon_cb.WSTRB;
          data_captured = 1;
          `uvm_info("AXI_MONITOR", $sformatf("[W CAPTURED] data=0x%08h strb=0x%01h", wr_trans.WDATA, wr_trans.WSTRB), UVM_HIGH)
        end
      end

      forever begin
        @(axi_inf.mon_cb);
        if (!axi_inf.ARESETn) break;
        if (axi_inf.mon_cb.BVALID && axi_inf.mon_cb.BREADY) begin
          wr_trans.BRESP = axi_inf.mon_cb.BRESP;
          `uvm_info("AXI_MONITOR", $sformatf("[WRITE COMPLETE] addr=0x%08h data=0x%08h strb=0x%01h resp=%0d",
                    wr_trans.AWADDR, wr_trans.WDATA, wr_trans.WSTRB, wr_trans.BRESP), UVM_MEDIUM)
          write_ap.write(wr_trans);
          break;
        end
      end

    end // forever
  endtask


  task monitor_read_channel();
    axi_trans rd_trans;

    forever begin
      rd_trans = axi_trans::type_id::create("rd_trans");
      rd_trans.operation = single_r;

      forever begin
        @(axi_inf.mon_cb);
        if (!axi_inf.ARESETn) begin
          wait(axi_inf.ARESETn === 1'b1);
          @(axi_inf.mon_cb);
          continue;
        end
        if (axi_inf.mon_cb.ARVALID && axi_inf.mon_cb.ARREADY) begin
          rd_trans.ARADDR = axi_inf.mon_cb.ARADDR;
          rd_trans.ARPROT = axi_inf.mon_cb.ARPROT;
          `uvm_info("AXI_MONITOR", $sformatf("[AR CAPTURED] addr=0x%08h", rd_trans.ARADDR), UVM_HIGH)
          break;
        end
      end

      forever begin
        @(axi_inf.mon_cb);
        if (!axi_inf.ARESETn) break;
        if (axi_inf.mon_cb.RVALID && axi_inf.mon_cb.RREADY) begin
          rd_trans.RDATA = axi_inf.mon_cb.RDATA;
          rd_trans.RRESP = axi_inf.mon_cb.RRESP;
          `uvm_info("AXI_MONITOR", $sformatf("[READ COMPLETE] addr=0x%08h data=0x%08h resp=%0d",
                    rd_trans.ARADDR, rd_trans.RDATA, rd_trans.RRESP), UVM_MEDIUM)
          read_ap.write(rd_trans);
          break;
        end
      end

    end 
  endtask

endclass

`endif
    
     
