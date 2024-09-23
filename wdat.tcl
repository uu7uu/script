proc load {args} {
# first check if the user input a ? for help

    if {![llength $args] || [lindex $args 0] == "?" || [lindex $args 0] == "-h"} {
       puts "Usage: load data"
       puts " "
       puts "songyj  v1.1  23/06"
       return
    }
    
# parse the arguments - spin number; confidence level

    if {[llength $args] > 0} {
       set number [lindex $args 0]
    }
   query yes
   setp energy
   setp back
   cpd /xs
set le [format "%d" $number]l 
set me [format "%d" $number]m
da 1:1 $le
da 2:2 $me
ign 1:**-2. 10.-**
ign 2:**-10. 25.-**
plot da
}