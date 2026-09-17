class c_94_1;
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

program p_94_1;
    c_94_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "z01001xzz1zx1101110xxzz1x1x01x1xzxxzxzzzxxzxzzzxxxzzzxxxzzxxxzzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
