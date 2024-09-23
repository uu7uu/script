proc cat_err {args} {

#设置confidence level
	    set cl 2.71
	    if {[llength $args] > 0} {
	       set cl [lindex $args 0]
	    }

	tclout modpar;
	set total $xspec_tclout;
	set ll [list];
	set value [list];
	set err [list];
	set par [list];
	for {set n 1} {$n <= $total} {incr n} {
	tclout pfree $n;
	set test $xspec_tclout
	if {$test=="T"} {lappend ll $n} 
	}
	
#计算误差

	error $cl $ll; 
	}

	
proc print_err {} {
	tclout modpar;
	set total $xspec_tclout;
	set ll [list];
	set value [list];
	set err [list];
	set par [list];
	for {set n 1} {$n <= $total} {incr n} {
	tclout pfree $n;
	set test $xspec_tclout
	if {$test=="T"} {lappend ll $n} 
	}
	
#计算误差

	#error $ll; 
	set len [llength $ll]
	
#获得参数列表
	for {set a 0} {$a<$len} {incr a} {
	tclout pinfo [lindex $ll $a];
	lappend par [lindex $xspec_tclout 0];
	}

#获得置信区间

	for {set p 0} {$p < $len} {incr p} {
	tclout error [lindex $ll $p];
	lappend err $xspec_tclout;
	}
 
#获得value

	for {set i 0} {$i < $len} {incr i} {
	tclout param [lindex $ll $i];
	lappend value [lindex $xspec_tclout 0];
	}
	
#打印结果

	puts $ll;
	puts " para  name       value      lbound      ubound \n"
	for {set q 0} {$q < $len} {incr q} {
	puts [format " %-4d  %-10s %-.6f    %-4f    %-4f    (%-.6f,%.6f)" [lindex $ll $q] [lindex $par $q] [lindex $value $q] [lindex [lindex $err $q] 0] [lindex [lindex $err $q] 1] [expr "[lindex [lindex $err $q] 0]-[lindex $value $q]"] [expr "[lindex [lindex $err $q] 1]-[lindex $value $q]"]]
	}
	
	
	}
	
