gui_start
read_file -format verilog {/home/UIS112/UIS112a08/Project_Code/TE/Mul_5bits_J5.v}
set_fix_multiple_port_nets -all -buffer_constants
create_clock -name "clk" -period 8 -waveform { 4 8 }  { clk  }
set_dont_touch_network  [ find clock clk ]
set_fix_hold  [ find clock clk]
uplevel #0 check_design
compile -exact_map
change_names -hierarchy -rule verilog
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group }
uplevel #0 { report_timing -path full -delay min -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group }
uplevel #0 { report_area }
uplevel #0 { report_area -hierarchy }
uplevel #0 { report_power -analysis_effort low }
report_qor