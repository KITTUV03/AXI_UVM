class c_38_1;
    integer addr = 7;
    rand bit[31:0] AWADDR; // rand_mode = ON 

    constraint dec_err_address_this    // (constraint_mode = ON) (src/tb/agent/axi_trans.sv:74)
    {
       (AWADDR >= (16 * 4));
    }
    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (src/tb/sequences/axi_corner_data_seq.sv:31)
    {
       (AWADDR == (addr * 4));
    }
endclass

program p_38_1;
    c_38_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "011zz0z1x111110z0zx1zz1zx100x1x1xxzxzxxzzxxxxxzzzzzxxzzzxxzzxzxx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
