class c_6_1;
    integer addr = 5;
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

program p_6_1;
    c_6_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "z1zx0x0zz10zz001zzx00zxxzxx1xzx0xxxzzzzzxxxxxxxzxzxxxzzzxzzxxxxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
