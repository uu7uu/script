map(){ 
    # 使用传入的路径参数构建所需文件的路径
    local expo="sw00089766005xwtw2po_ex.img"
    local out="c${1}.arf"
    local in="c${1}.pha"

    # 生成arf文件
    xrtmkarf phafile="$in" outfile="$out" expofile="$expo" srcx=-1 srcy=-1 psfflag=yes clobber=yes
}

for i in {0..20}; do
    map "$i"
done

