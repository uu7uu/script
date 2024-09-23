dir_ob=$(ls -d */)
for ob in ${dir_ob}; do
    if [[ "${ob}" == 0* ]]; then
        echo ${ob}
        out="out${ob}"
        stem="sw${ob:0:11}"
        xrtpipeline indir=./$ob outdir=./$out steminputs=$stem stemoutputs=DEFAULT cleanup=yes srcra=OBJECT srcdec=OBJECT
    fi
done

