class c_39_1;
    integer addr = 8;
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

program p_39_1;
    c_39_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "00zzx1111z111zxzzx0zz1100000z0zzxxzxxzzzxxzxzxzzxxzxzzzzzzzzzxzx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
