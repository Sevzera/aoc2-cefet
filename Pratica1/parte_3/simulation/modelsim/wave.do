onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /m_cache/clock
add wave -noupdate -radix unsigned /m_cache/test_wren
add wave -noupdate -radix unsigned /m_cache/test_tag
add wave -noupdate -radix unsigned /m_cache/test_data
add wave -noupdate -divider M.Principal
add wave -noupdate -radix unsigned /m_cache/mp_clock
add wave -noupdate -radix unsigned /m_cache/mp_wren
add wave -noupdate -radix unsigned /m_cache/mp_address
add wave -noupdate -radix unsigned /m_cache/mp_data
add wave -noupdate -radix unsigned /m_cache/mp_out
add wave -noupdate -divider M.Cache
add wave -noupdate -color Gray65 -radix unsigned /m_cache/mc_wren
add wave -noupdate -color Cyan -radix unsigned -childformat {{{/m_cache/mc_address[0]} -radix unsigned} {{/m_cache/mc_address[1]} -radix unsigned} {{/m_cache/mc_address[2]} -radix unsigned} {{/m_cache/mc_address[3]} -radix unsigned}} -expand -subitemconfig {{/m_cache/mc_address[0]} {-color Cyan -height 15 -radix unsigned} {/m_cache/mc_address[1]} {-color Cyan -height 15 -radix unsigned} {/m_cache/mc_address[2]} {-color Cyan -height 15 -radix unsigned} {/m_cache/mc_address[3]} {-color Cyan -height 15 -radix unsigned}} /m_cache/mc_address
add wave -noupdate -color {Cornflower Blue} -radix unsigned /m_cache/valido
add wave -noupdate -color {Cornflower Blue} -radix unsigned /m_cache/dirty
add wave -noupdate -color {Cornflower Blue} -radix unsigned /m_cache/lru
add wave -noupdate -color Yellow -radix unsigned /m_cache/mc_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {515 ps} 0}
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
WaveRestoreZoom {0 ps} {1350 ps}
