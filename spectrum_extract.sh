# 定义函数 spectrum_extract，用于执行 xselect 命令
spectrum_extract(){
    xselect @yes
}

# 定义函数 write_xco，用于生成 xco 文件
write_xco(){
    local xco_file="yes.xco"

    # 检查文件是否存在，如果存在则删除
    if [ -f "$xco_file" ]; then
        rm "$xco_file"
    fi

    # 打开xco文件以写入模式，并写入内容
    cat <<EOF > "$xco_file"
yes
xsel
read event $1
./
yes
filter region $2
extract spectrum
save spectrum $3
clear region all
filter region $4
extract spectrum
save spectrum $5
extract curve 
save curve
yes
exit
no
EOF

    echo "xco文件已创建: $xco_file"
}

# 获取当前目录下的所有子文件夹，并对其进行循环处理
for ob in */; do
    # 判断文件夹名称是否以 "0" 开头，以过滤出符合条件的文件夹
    if [[ "${ob}" == 0* ]]; then
        echo ${ob}
        # 构建相关文件的路径
        out="out${ob}"
        evt="sw${ob:0:11}xwtw2po_cl.evt"
        spec="sw${ob:0:11}.pha"
        bkg="sw${ob:0:11}_bkg.pha"
        src_reg="src_${ob:0:11}.reg"
        bkg_reg="bkg_${ob:0:11}.reg"
        # 进入子文件夹
        cd "$out" || exit
        # 调用 write_xco 函数生成 xco 文件，并调用 spectrum_extract 函数执行 xselect 命令
        write_xco "$evt" "$src_reg" "$spec" "$bkg_reg" "$bkg"
        spectrum_extract
        # 返回上级目录
        cd ..
    fi
done
