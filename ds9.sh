ds9Func(){
    ds9 $1 centroid -scale log -cmap bb -region show yes -region centroid auto yes -region command "circle 535.99496, 527.29786, 47 #color=green" -region select all -region edit yes -region centroid -region save src.reg -region delete select -region command "annulus 535.44967,528.09492,47,71 #color=green" -region select all -region edit yes -region centroid -region save bkg.reg -exit
}

# 检查参数是否提供
if [ $# -ne 1 ]; then
    echo "Usage: $0 <file>"
    exit 1
fi

# 检查文件是否存在
if [ ! -f "$1" ]; then
    echo "File $1 not found."
    exit 1
fi

# 逐行读取文件内容并处理
while IFS= read -r ob; do
    if [[ "${ob}" == 0* ]]; then
        echo "${ob}"
        out="out${ob}"
        stem="sw${ob:0:11}xwtw2po_cl.evt"
        # 这里添加你的处理逻辑，比如调用函数
        # 注意要使用绝对路径或相对路径，具体取决于你的文件结构
        cd "$out"
        ds9Func "$stem"
        cd ..
    fi
done < "$1"