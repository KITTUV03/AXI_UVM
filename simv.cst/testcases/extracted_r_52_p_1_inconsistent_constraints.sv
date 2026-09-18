class c_52_1;
    integer addr = 1;
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

program p_52_1;
    c_52_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "011z011xxz11z01x00x010x0z0zx0x0zxxxzzzxxzzxzzxzxxzxzxzxzzxzxxxzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
