class c_27_1;
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

program p_27_1;
    c_27_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "x10x01zx010z0xz1zz00111x0x0z0101zzzxzzzxzzxxxxxxxxxzzzxzxzzzxxxx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
