`ifndef AXI_INP_MON
`define AXI_INP_MON

class axi_input_monitor extends uvm_monitor;
  `uvm_component_utils(axi_input_monitor)

  virtual intf axi_inf;
  uvm_analysis_port #(axi_trans) write_ap;
  uvm_analysis_port #(axi_trans) read_ap;

  function new(string name = "axi_input_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    write_ap = new("write_ap", this);
    read_ap  = new("read_ap",  this);
    if(!uvm_config_db #(virtual intf)::get(this, "", "axi_inf", axi_inf))
      `uvm_fatal("AXI_INP_MON", "Interface Not Received in Input Monitor")
  endfunction

  task run_phase(uvm_phase phase);
    wait(axi_inf.ARESETn === 1'b1);
    @(axi_inf.mon_cb);

    fork
      monitor_write_input();
      monitor_read_input();
    join_none
  endtask

  // Monitor Write Input: Captures AW (Address) and W (Data) handshakes
  task monitor_write_input();
    axi_trans wr_trans;
    bit addr_captured, data_captured;

    forever begin
      addr_captured = 0;
      data_captured = 0;
      wr_trans = axi_trans::type_id::create("wr_inp_trans");
      wr_trans.operation = single_w;

      while (!(addr_captured && data_captured)) begin
        @(axi_inf.mon_cb);
        if (!axi_inf.ARESETn) begin
          addr_captured = 0;
          data_captured = 0;
          wr_trans = axi_trans::type_id::create("wr_inp_trans");
          wr_trans.operation = single_w;
          wait(axi_inf.ARESETn === 1'b1);
          @(axi_inf.mon_cb);
          continue;
        end

        // AW Handshake
        if (!addr_captured && axi_inf.mon_cb.AWVALID && axi_inf.mon_cb.AWREADY) begin
          wr_trans.AWADDR = axi_inf.mon_cb.AWADDR;
          wr_trans.AWPROT = axi_inf.mon_cb.AWPROT;
          addr_captured = 1;
          `uvm_info("AXI_INP_MON", $sformatf("[AW CAPTURED] addr=0x%08h", wr_trans.AWADDR), UVM_HIGH)
        end

        // W Handshake
        if (!data_captured && axi_inf.mon_cb.WVALID && axi_inf.mon_cb.WREADY) begin
          wr_trans.WDATA = axi_inf.mon_cb.WDATA;
          wr_trans.WSTRB = axi_inf.mon_cb.WSTRB;
          data_captured = 1;
          `uvm_info("AXI_INP_MON", $sformatf("[W CAPTURED] data=0x%08h strb=0x%01h", wr_trans.WDATA, wr_trans.WSTRB), UVM_HIGH)
        end
      end

      `uvm_info("AXI_INP_MON", $sformatf("[WRITE INPUT COMPLETE] addr=0x%08h data=0x%08h strb=0x%01h",
                wr_trans.AWADDR, wr_trans.WDATA, wr_trans.WSTRB), UVM_MEDIUM)
      write_ap.write(wr_trans);
    end
  endtask

  // Monitor Read Input: Captures AR (Address) handshake
  task monitor_read_input();
    axi_trans rd_trans;

    forever begin
      rd_trans = axi_trans::type_id::create("rd_inp_trans");
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
          `uvm_info("AXI_INP_MON", $sformatf("[AR CAPTURED] addr=0x%08h", rd_trans.ARADDR), UVM_HIGH)
          break;
        end
      end

      `uvm_info("AXI_INP_MON", $sformatf("[READ INPUT COMPLETE] addr=0x%08h", rd_trans.ARADDR), UVM_MEDIUM)
      read_ap.write(rd_trans);
    end
  endtask

endclass


`endif
 
     
