class c_12_1;
    rand bit[31:0] AWADDR; // rand_mode = ON 

    constraint valid_address_range_this    // (constraint_mode = ON) (src/tb/agent/axi_trans.sv:57)
    {
       ((AWADDR[31:6]) == 26'h0);
    }
    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (src/tb/sequences/axi_negative_test.sv:44)
    {
       (AWADDR == 32'hffffffff);
    }
endclass

program p_12_1;
    c_12_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "x11x011x0zx1x01zz1zxx1zx00zxx1z0zzxzzxxzxxxxzxzxxzzzzxzzxxzzzxzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
