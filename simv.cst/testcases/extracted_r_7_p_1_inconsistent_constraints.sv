class c_7_1;
    integer addr = 6;
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

program p_7_1;
    c_7_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "x0xzxz1x00zz0zzzx1zzx00x1zz1xzz1zxzzzxzxxzzxzzzxxzzxxxzzzzxzzxzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
