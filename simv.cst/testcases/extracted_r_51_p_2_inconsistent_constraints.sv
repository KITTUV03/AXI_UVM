class c_51_2;
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

program p_51_2;
    c_51_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "0zxx1zx1zzzx0xxxxz0x0zzz0zzzzz11zzxxxxzxzzzxzzzxzxzzxzzzxxzxzxxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
