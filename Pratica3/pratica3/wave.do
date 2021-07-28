onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /Pratica3/instructionQ/Clock
add wave -noupdate /Pratica3/instructionQ/Clear
add wave -noupdate /Pratica3/instructionQ/instr
add wave -noupdate -divider {Reserve Station}
add wave -noupdate /Pratica3/instructionQ/rStation/RS_addSubFull
add wave -noupdate /Pratica3/instructionQ/rStation/Rs_mulDivFull
add wave -noupdate /Pratica3/instructionQ/rStation/opCode
add wave -noupdate /Pratica3/instructionQ/rStation/Xreg
add wave -noupdate /Pratica3/instructionQ/rStation/Yreg
add wave -noupdate /Pratica3/instructionQ/rStation/Op
add wave -noupdate -expand -subitemconfig {{/Pratica3/instructionQ/rStation/Vk[5]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Vk[4]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Vk[3]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Vk[2]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Vk[1]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Vk[0]} {-color {Cornflower Blue} -height 15}} /Pratica3/instructionQ/rStation/Vk
add wave -noupdate -expand -subitemconfig {{/Pratica3/instructionQ/rStation/Vj[5]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Vj[4]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Vj[3]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Vj[2]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Vj[1]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Vj[0]} {-color {Cornflower Blue} -height 15}} /Pratica3/instructionQ/rStation/Vj
add wave -noupdate -expand -subitemconfig {{/Pratica3/instructionQ/rStation/Qk[5]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Qk[4]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Qk[3]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Qk[2]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Qk[1]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Qk[0]} {-color {Cornflower Blue} -height 15}} /Pratica3/instructionQ/rStation/Qk
add wave -noupdate -expand -subitemconfig {{/Pratica3/instructionQ/rStation/Qj[5]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Qj[4]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Qj[3]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Qj[2]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Qj[1]} {-color {Cornflower Blue} -height 15} {/Pratica3/instructionQ/rStation/Qj[0]} {-color {Cornflower Blue} -height 15}} /Pratica3/instructionQ/rStation/Qj
add wave -noupdate /Pratica3/instructionQ/rStation/Busy
add wave -noupdate /Pratica3/instructionQ/rStation/Exec
add wave -noupdate /Pratica3/instructionQ/rStation/Wresult
add wave -noupdate -divider {Reserve Station Status}
add wave -noupdate -expand /Pratica3/instructionQ/rStation/rsSts/reserveStationIndex
add wave -noupdate /Pratica3/instructionQ/rStation/regsBusy
add wave -noupdate /Pratica3/instructionQ/rStation/reserveStatus
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {197 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 ns}
