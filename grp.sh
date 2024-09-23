dir_ob=$(ls -d */)
for ob in ${dir_ob}
do
	#echo ${ob}
	cd ${ob}
	cd out
    pha_name=$(ls *.pha)
    for file in ${pha_name}
    do
        if [[ $file == *"bkg"* ]]; then
            continue
        elif [[ $file == *"ME"* ]]; then
            grppha ${file} ${file%spec*}sys.pha clobber=yes chatter=0 comm="systematics 0-1023 0.02&group min 100&exit"
        else [[ $file == *"LE"* ]]; 
            grppha ${file} ${file%spec*}sys.pha clobber=yes chatter=0 comm="systematics 0-1535 0.01&group min 100&exit"
        fi
    done
    cd ..
    cd ..

done