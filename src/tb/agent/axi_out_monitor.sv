// `ifndef AXI_OUT_MON
// `define AXI_OUT_MON

// class axi_out_monitor extends uvm_monitor;
//   `uvm_component_utils(axi_out_monitor)
//   `COMP_CNSTR(axi_out_monitor)
  
//   virtual intf axi_inf;
//   axi_trans trans;
  
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     if(!uvm_config_db #(virtual intf)::get(this,"","axi_inf",axi_inf))
//       `uvm_fatal(get_type_name(),"Interface Not Received in Input Monitor")
//   endfunction
      
//   task run_phase(uvm_phase phase);
//     forever begin
//       bit is_read=0;
//       bit is_write=0;
      
//       fork
//       get_from_dut_write();
//       get_from_dut_read();
//       join_none
      
//       wait(is_write && is_read);
//       disable fork;
      
//     end
//   endtask
    
//  task get_from_dut_write();
   
//    @(axi_inf.in_mon_cb);
//    if((axi_inf.in_mon_cb.AWVALID && axi_inf.in_mon_cb.AWREADY) || (axi_inf.in_mon_cb.WVALID && axi_inf.in_mon_cb.WREADY))
//      begin
//        bit write_addr = axi_inf.in_mon_cb.AWVALID && axi_inf.in_mon_cb.AWREADY;
//        bit write_data = axi_inf.in_mon_cb.WVALID && axi_inf.in_mon_cb.WREADY;
       
//        if(write_addr) begin
//          wait(axi_inf.in_mon_cb.WVALID && axi_inf.in_mon_cb.WREADY);
//        end
//        else if(write_data) begin
//          wait(axi_inf.in_mon_cb.AWVALID && axi_inf.in_mon_cb.AWREADY);
//        end
       
//        is_write=1;
//        trans=axi_trans::type_id::create("trans");
//        trans.AWADDR = axi_inf.in_mon_cb.AWADDR;
//        trans.WDATA = axi_inf.in_mon_cb.WDATA;
//        trans.WSTRB = axi_inf.in_mon_cb.WSTRB;
//      end
   
//    else begin
//      is_write=1;
//      return;
//    end
   
//  endtask
      
    
//  task get_from_dut_read();
   
//    @(axi_inf.in_mon_cb);
//    if((axi_inf.in_mon_cb.ARVALID && axi_inf.in_mon_cb.ARREADY))
//      begin
//        is_read=1;
//        trans=axi_trans::type_id::create("trans");
//        trans.ARADDR = axi_inf.in_mon_cb.ARADDR;
//      end
   
//    else begin
//        is_read=1;
//      return;
//    end
   
   
//  endtask
        
// endclass

// `endif



 
