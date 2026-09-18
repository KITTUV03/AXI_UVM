class c_2_1;
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

program p_2_1;
    c_2_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "00zz01zzz100zxzz10x0x1zxz1z1x0xxxzzxxxxxxzzxzxxxxzzzxxxxzzxxzxxx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
