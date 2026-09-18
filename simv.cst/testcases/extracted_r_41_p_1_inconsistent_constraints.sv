class c_41_1;
    integer addr = 0;
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

program p_41_1;
    c_41_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "0xx101zx01110xz1110xzz10zzz101zxxxxxzxzzxxxzxxxxxzxzxzxxxzxxxzxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
