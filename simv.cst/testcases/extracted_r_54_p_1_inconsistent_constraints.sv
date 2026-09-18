class c_54_1;
    integer addr = 3;
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

program p_54_1;
    c_54_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "0z10z1x10x10x1z00011z1x00z0100z0zxxzzzzzzzzxxxzzxzzzzzzxzzzzzzxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
