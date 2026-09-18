class c_55_1;
    integer addr = 4;
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

program p_55_1;
    c_55_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "000100010z0xxz10010xz0z0zx101100xxzzzxzxzzzzzzxxxzxzzzzxxzxzzzxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
