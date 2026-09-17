class c_11_2;
    rand bit[31:0] ARADDR; // rand_mode = ON 

    constraint valid_address_range_this    // (constraint_mode = ON) (axi_trans.sv:57)
    {
       ((ARADDR[31:6]) == 26'h0);
    }
    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (axi_negative_test.sv:56)
    {
       (ARADDR == 32'hffffffff);
    }
endclass

program p_11_2;
    c_11_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "0xzzzz11zxx0x1zzx101z0x00xxxxz11xzxxzzzzzxzxzzxzxzzxzzzxxxxxzxxx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
