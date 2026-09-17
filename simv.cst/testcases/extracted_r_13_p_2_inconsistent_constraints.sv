class c_13_2;
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

program p_13_2;
    c_13_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "11xzz01zzxxx1z1z1010xz0100x0101xxxzxzzxxzzxxzzxxxzzxxxxzxxzzxzzx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
