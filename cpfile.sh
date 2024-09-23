
find_pha(){ 
    local bkg_file="sw${1}_bkg.pha"
    local ancr_file="sw${1}.arf"
    local new_file="sw${1}po.pha"

    cp $new_file $ancr_file $bkg_file /home/data1/syj/data/J1727.8-1613/joint_fit/

}

for ob in */; do
    # 判断文件夹名称是否以 "0" 开头，以过滤出符合条件的文件夹
    if [[ "${ob}" == 0* ]]; then
        # 去除尾部的斜杠
        out="out${ob}"
        stem="${ob:0:11}"
        # 进入子文件夹并处理文件
        cd "$out" || { echo "Failed to enter directory $out"; exit 1; }
        find_pha "$stem"
        cd ..
    fi
done

echo "Script execution completed."