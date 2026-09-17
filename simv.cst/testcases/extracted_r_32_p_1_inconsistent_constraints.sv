class c_32_1;
    rand bit[31:0] AWADDR; // rand_mode = ON 

    constraint valid_address_range_this    // (constraint_mode = ON) (axi_trans.sv:57)
    {
       ((AWADDR[31:6]) == 26'h0);
    }
    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (axi_negative_test.sv:44)
    {
       (AWADDR == 32'hffffffff);
    }
endclass

program p_32_1;
    c_32_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "0zzz000x01xx1x10z1x01xzzx00x0zx0xzxzxzzzzxxxxxzxzzzzzxxzzxxzzxzx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
