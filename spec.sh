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
xsel
read event $1
./
yes
extract image
filter region $2
extract event
save event $3
yes
extract spectrum
save spectrum $4
yes
exit
no
EOF

    echo "xco文件已创建: $xco_file"
}

# 主循环，遍历b1到b15
for i in {0..20}; do
    src_reg="c${i}.reg"
    evt="sw00089766005xwtw2po_cl.evt"
    spec="c${i}.pha"
    new_evt="c${i}.evt"

    # 调用 write_xco 函数生成 xco 文件，并调用 spectrum_extract 函数执行 xselect 命令
    write_xco "$evt" "$src_reg" "$new_evt" "$spec"
    spectrum_extract
done