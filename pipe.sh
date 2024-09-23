dir_ob=$(ls -d */)
for ob in ${dir_ob}
do
	#echo ${ob}
	cd ${ob}
	dir_data=$(ls -d */)
	for dir in ${dir_data}
	do
		if [[ "${dir}" == P* ]]; then
		inputdir=${dir}
		cd ${inputdir}
			if [! -d out];then
			break
		else
		cd ..
		for i in ${inputdir}
		do	
		echo ${inputdir}
		hpipeline --LE_ONLY --ME_ONLY --header -i ${inputdir} -o out/
		done
		fi
		fi
	done
	cd ..


done


