create_clock -period 20.000 [get_ports {i_clock}]
set_false_path -from [get_ports {i_reset}]
set_false_path -to [get_ports {output_SEGMENT_0_3[*] output_SEGMENT_4_7[*] o_trigger o_data o_bits_sbox[*]}]
