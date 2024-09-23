#计算数据集误差
proc me {args} {

# first check if the user input a ? for help

    if {![llength $args] || [lindex $args 0] == "?" || [lindex $args 0] == "-h"} {
       puts "Usage: spin error analysis"
       puts "Runs error analysis for spin <number> of kerrbb and writes the results"
       puts "to <spin.txt>. If <confidence level> is given that is used for error analysis."
       puts "Default confidence level is 90%."
       puts " "
       puts "Before running this procedure you must have read in the datasets"
       puts "along with their response files and optional background"
       puts "and arf files. You must also have defined the model."
       puts " "
       puts "The output file is a txt file with the columns being the"
       puts "value fit for spin parameter in each dataset. "
       puts "You need imput the number of spin param"
       puts " "
       puts "songyj  v1.1  23/06"
       return
    }
    
# parse the arguments - spin number; confidence level

    if {[llength $args] > 0} {
       set number [lindex $args 0]
    }
    set err 2.71
    if {[llength $args] > 1} {
       set err [lindex $args 1]
    }

#检查是否存在参数文件
    if {[file exists "par.txt"]==0} {
       puts "You must have a Dataset: <par.txt>"
       return
    }

#查看模型free参数有哪些
	tclout modpar;
	set tt $xspec_tclout;
	set ll [list]
	for {set n 1} {$n<=$tt} {incr n} {
	tclout pfree $n;
	set test $xspec_tclout
	if {$test=="T"} {lappend ll $n} 
	}

#寻找par.txt文件 读取数据集
set spin [open "spin_result.txt" a+]
set pd [open par.txt r];
set total [lindex [exec wc -l par.txt] 0]

for {set x 1} {$x<=$total} {incr x} {
	set line [gets $pd];set par [list];
	for {set i 0} {$i<3} {incr i} {lappend par [lindex $line $i]}
		set m [lindex $par 0];
		set i [lindex $par 1];
		set d [lindex $par 2];

#更改模型参数
		newpar [expr "$number + 1"] $i;
		newpar [expr "$number + 2"] $m;
		newpar [expr "$number + 4"] $d;
		newpar $number 0.9
		renorm;
		fit;
#计算误差
		error $err $ll; 
		tclout param $number 
		lappend par [lindex $xspec_tclout 0]
		puts $spin  $par;
		

}

#关闭文件
close $pd;
close $spin;
}



