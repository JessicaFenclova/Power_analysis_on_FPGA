create_clock -period 20.000 [get_ports {i_cloc}]
set_false_path -from [get_ports {i_res}]