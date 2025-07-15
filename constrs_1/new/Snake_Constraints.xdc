## Clock Signal
set_property PACKAGE_PIN W5 [get_ports {CLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {CLK}]


## LEDs
set_property PACKAGE_PIN U16 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property PACKAGE_PIN W18 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property PACKAGE_PIN U15 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN U14 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN V14 [get_ports {LED[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
set_property PACKAGE_PIN L1 [get_ports {READY}]
set_property IOSTANDARD LVCMOS33 [get_ports {READY}]
set_property PACKAGE_PIN P1 [get_ports {IP_LED}]
set_property IOSTANDARD LVCMOS33 [get_ports {IP_LED}]

## 7-Segment Display - Segment Select
## set_property PACKAGE_PIN U2 [get_ports {SEG_SELECT[0]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT[0]}]
## set_property PACKAGE_PIN U4 [get_ports {SEG_SELECT[1]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT[1]}]
## set_property PACKAGE_PIN V4 [get_ports {SEG_SELECT[2]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT[2]}]
## set_property PACKAGE_PIN W4 [get_ports {SEG_SELECT[3]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT[3]}]

## 7-Segment Display - DEC_OUT
## set_property PACKAGE_PIN W7 [get_ports {DEC_OUT[0]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[0]}]
## set_property PACKAGE_PIN W6 [get_ports {DEC_OUT[1]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[1]}]
## set_property PACKAGE_PIN U8 [get_ports {DEC_OUT[2]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[2]}]
## set_property PACKAGE_PIN V8 [get_ports {DEC_OUT[3]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[3]}]
## set_property PACKAGE_PIN U5 [get_ports {DEC_OUT[4]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[4]}]
## set_property PACKAGE_PIN V5 [get_ports {DEC_OUT[5]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[5]}]
## set_property PACKAGE_PIN U7 [get_ports {DEC_OUT[6]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[6]}]
## set_property PACKAGE_PIN V7 [get_ports {DEC_OUT[7]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {DEC_OUT[7]}]

##Buttons
set_property PACKAGE_PIN T18 [get_ports {BTNR}]
set_property IOSTANDARD LVCMOS33 [get_ports {BTNR}]
## set_property PACKAGE_PIN U18 [get_ports {BTNC}]
## set_property IOSTANDARD LVCMOS33 [get_ports {BTNC}]
set_property PACKAGE_PIN W19 [get_ports {RESET}]
set_property IOSTANDARD LVCMOS33 [get_ports {RESET}]
## set_property PACKAGE_PIN U17 [get_ports {BTND}]
## set_property IOSTANDARD LVCMOS33 [get_ports {BTND}]
## set_property PACKAGE_PIN T18 [get_ports {BTNU}]
## set_property IOSTANDARD LVCMOS33 [get_ports {BTNU}]



# VGA Horizontal Sync (HS)
## set_property PACKAGE_PIN P19 [get_ports {HS}]
## set_property IOSTANDARD LVCMOS33 [get_ports {HS}]

# VGA Vertical Sync (VS)
## set_property PACKAGE_PIN R19 [get_ports {VS}]
## set_property IOSTANDARD LVCMOS33 [get_ports {VS}]

# VGA Red color bits
## set_property PACKAGE_PIN G19 [get_ports {COLOUR_OUT[11]}]  
## set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[11]}]
## set_property PACKAGE_PIN H19 [get_ports {COLOUR_OUT[10]}]  
## set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[10]}]
## set_property PACKAGE_PIN J19 [get_ports {COLOUR_OUT[9]}]  
## set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[9]}]
## set_property PACKAGE_PIN N19 [get_ports {COLOUR_OUT[8]}]   
## set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[8]}]

# VGA Green color bits
## set_property PACKAGE_PIN J17 [get_ports {COLOUR_OUT[7]}]   
## set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[7]}]
## set_property PACKAGE_PIN H17 [get_ports {COLOUR_OUT[6]}]  
## set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[6]}]
## set_property PACKAGE_PIN G17 [get_ports {COLOUR_OUT[5]}]   
## set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[5]}]
## set_property PACKAGE_PIN D17 [get_ports {COLOUR_OUT[4]}] 
## set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[4]}]

# VGA Blue color bits
## set_property PACKAGE_PIN N18 [get_ports {COLOUR_OUT[3]}]   
## set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[3]}]
## set_property PACKAGE_PIN L18 [get_ports {COLOUR_OUT[2]}]   
## set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[2]}]
## set_property PACKAGE_PIN K18 [get_ports {COLOUR_OUT[1]}]   
## set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[1]}]
## set_property PACKAGE_PIN J18 [get_ports {COLOUR_OUT[0]}]   
## set_property IOSTANDARD LVCMOS33 [get_ports {COLOUR_OUT[0]}]

# Slide switches for colour input
## set_property PACKAGE_PIN R2 [get_ports {SWITCHES[0]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[0]}]
## set_property PACKAGE_PIN T1 [get_ports {SWITCHES[1]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[1]}]
## set_property PACKAGE_PIN U1 [get_ports {SWITCHES[2]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[2]}]
## set_property PACKAGE_PIN W2 [get_ports {SWITCHES[3]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[3]}]
## set_property PACKAGE_PIN R3 [get_ports {SWITCHES[4]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[4]}]
## set_property PACKAGE_PIN T2 [get_ports {SWITCHES[5]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[5]}]
## set_property PACKAGE_PIN T3 [get_ports {SWITCHES[6]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[6]}]
## set_property PACKAGE_PIN V2 [get_ports {SWITCHES[7]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[7]}]
## set_property PACKAGE_PIN W13 [get_ports {SWITCHES[8]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[8]}]
## set_property PACKAGE_PIN W14 [get_ports {SWITCHES[9]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[9]}]
## set_property PACKAGE_PIN V15 [get_ports {SWITCHES[10]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[10]}]
## set_property PACKAGE_PIN W15 [get_ports {SWITCHES[11]}]
## set_property IOSTANDARD LVCMOS33 [get_ports {SWITCHES[11]}]

##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports Tx_debug]
set_property IOSTANDARD LVCMOS33 [get_ports Tx_debug]
#Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports Transmit_debug]
set_property IOSTANDARD LVCMOS33 [get_ports Transmit_debug]
#Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports BTNR_debug]
set_property IOSTANDARD LVCMOS33 [get_ports BTNR_debug]
#Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports CLK_debug]
set_property IOSTANDARD LVCMOS33 [get_ports CLK_debug]

##USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports Rx]
set_property IOSTANDARD LVCMOS33 [get_ports Rx]

set_property PACKAGE_PIN A18 [get_ports Tx]
set_property IOSTANDARD LVCMOS33 [get_ports Tx]

