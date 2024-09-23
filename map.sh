map(){ 
    # 使用传入的路径参数构建所需文件的路径
    local attfile="/home/data1/syj/data/J1727.8-1613/swift/$1/auxil/sw${1}pat.fits.gz"
    local hdfile="/home/data1/syj/data/J1727.8-1613/swift/$1/xrt/hk/sw${1}xhd.hk.gz"
    local infile="/home/data1/syj/data/J1727.8-1613/swift/out$1/sw${1}xwtw2po_cl.evt"
    local ancr_file="sw${1}.arf"
    local expo="sw${1}_ex.img"

    # 调用 xrtexpomap 命令生成曝光图
    xrtexpomap attfile="$attfile" hdfile="$hdfile" infile="$infile" stemout="sw${1}" outdir="./" clobber=yes
    xrtmkarf outfile="$ancr_file" expofile="$expo" srcx=-1 srcy=-1
}


for ob in */; do
    # 判断文件夹名称是否以 "0" 开头，以过滤出符合条件的文件夹
    if [[ "${ob}" == 0* ]]; then
        # 构建相关文件的路径
        out="out${ob}"
        stem="${ob:0:11}"
        # 进入子文件夹
        cd "$out" || exit
        map $stem
        # 返回上级目录
        cd ..
    fi
done
