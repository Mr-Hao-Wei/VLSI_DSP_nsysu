gui_start
read_file -format verilog {/home/VLSIDSP/B093011056/jychen/VLSI_DSP/ES/SYN/FFT_SYN_v3_jychen/Pipeline/2/FFT_11_point_pipe.v}
current_design FFT_11_point_pipe
analyze -format verilog {/home/VLSIDSP/B093011056/jychen/VLSI_DSP/ES/SYN/FFT_SYN_v3_jychen/Pipeline/2/ComplexAdder.v}
analyze -format verilog {/home/VLSIDSP/B093011056/jychen/VLSI_DSP/ES/SYN/FFT_SYN_v3_jychen/Pipeline/2/ComplexMul_coef_Real.v}
analyze -format verilog {/home/VLSIDSP/B093011056/jychen/VLSI_DSP/ES/SYN/FFT_SYN_v3_jychen/Pipeline/2/ComplexMul_coef_Imag.v}
current_design FFT_11_point_pipe
link
current_design FFT_11_point_pipe
set_fix_multiple_port_nets -all -buffer_constants
create_clock -name "clk" -period 2 -waveform { 1 2  }  { clk  }

uplevel #0 check_design
compile -exact_map
change_names -hierarchy -rule verilog
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group }
uplevel #0 { report_timing -path full -delay min -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group }
uplevel #0 { report_area }
uplevel #0 { report_area -hierarchy }
uplevel #0 { report_power -analysis_effort low }
write -hierarchy -format verilog -output FFT_11_point_pipe_syn.v
write_sdf -version 2.1 FFT_11_point_pipe_syn.sdf
write -hierarchy -format ddc -output FFT_11_point_pipe_syn.ddc
write_sdc FFT_11_point_pipe_syn.sdc
write_scan_def -expand_elements Corelnst -o FFT_11_point_pipe_syn.def
report_area > area_FFT_11_point_pipe_syn.log
report_timing > timing_FFT_11_point_pipe_syn.log
report_power > power_FFT_11_point_pipe_syn.log