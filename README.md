# Power_analysis_on_FPGA
Implementation of the AES cipher on a FPGA with the support of CPA experiments. The design that can be implemented on FPGA has the following hierarchical structure:
 1. top_cpa.vhd
    - top_ctrl_aes.vhd
      - ctrl_aes.vhd
      - sbox_decoder.vhd
      - lfsr.vhd
    - top_uart_aes.vhd
      - top_ctrl_rx.vhd
        - ctrl_rx.vhd
        - rx_sampling.vhd
        - baud_gen.vhd
      - top_ctrl_tx.vhd
        - ctrl_tx.vhd
        - baud_gen_tx.vhd
    - top_sbox_aes.vhd
      - sbox.vhd
      - reg_sbox.vhd
      - reg_after.vhd
    - xor_sbox.vhd

In addition scripts for simulation and conducting measurements are available. For the simulation the Matlab scripts have the following hierarchical structure:
 1. AES_simul.m
    - AES_encrypt.m
      - addroundkey.m
      - subbytes.m
      - shiftrows.m
      - mixcolumns.m
      - expan_core.m
      - key_expansion.m
    - prediction.m
    - real_pow_mod.m
 
 
The script for conductiong the experiment was designed in Python, experiment.py.
