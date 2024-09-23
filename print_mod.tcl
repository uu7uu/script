#载入函数时的提示
puts "\"cat_err\", \"print_err\" has loaded."

#计算error的函数
proc cat_err {args} {
    set cl 2.71
    if {[llength $args] >0 } {
        set cl [lindex $args 0]
    }
    tclout modpar
    set total $xspec_tclout
    set ll [list]
    for {set i 1} {$i <= $total} {incr i} {
        tclout pfree $i
        if {$xspec_tclout == "T"} {lappend ll $i}
    }
    parall error [llength $ll]
    error $cl $ll
}

proc print_err {} {
    tclout modpar
    set total $xspec_tclout
    set ll [list]
    set par [list]
    set err [list]
    set value [list]
    for {set i 1} {$i <= $total} {incr i} {
        tclout pfree $i
        set temp $xspec_tclout
        if {$temp == "T"} {lappend ll $i}
    }
    set len [llength $ll]

    #如果之前没有计算过error的话，之后的lbound与ubound只会给出0
    #所以在这里进行一次无提示的error计算
    tclout chatter
    set temp $xspec_tclout
    chat 0 0
    parall error $len
    error $ll
    chat temp

    #之前的写法会需要进行多次循环，这样可以在一次循环里面获取全部的参数
    for {set i 0} {$i < $len} {incr i} {
        #用一个变量记录index，可以减少从ll中获取编号的次数
        set temp [lindex $ll $i]
        tclout pinfo $temp
        lappend par [lindex $xspec_tclout 0]
        tclout error $temp
        lappend err $xspec_tclout
        tclout param $temp
        lappend value [lindex $xspec_tclout 0]
    }
    puts "para name       value    lbound   ubound"
    for {set i 0} {$i < $len} {incr i} {
        puts [format "%-4d %-10s %-.6f %-4f %-4f (%-.6f, %-.6f)" \
        [lindex $ll $i] [lindex $par $i] [lindex $value $i] [lindex [lindex $err $i] 0] [lindex [lindex $err $i] 1]\
        [expr "[lindex [lindex $err $i] 0]-[lindex $value $i]"] [expr "[lindex [lindex $err $i] 1]-[lindex $value $i]"]]
    }
}
