#!/bin/bash

# Usage:
# wfuzzer.sh https://example.com
# wfuzzer.sh https://example.com/adirectory

# Note that there is no trailing /
# Outputs to ~/.wfuzz/output as md5 filenames
# Look at ~/.wfuzz/output/log.txt which file is what

url="$1/FUZZ{notthere}"
echo $url
dir=~/.wfuzz

out=$dir/output
mkdir $out
log=$out/log.txt
echo >> $log

cp $dir/disc $dir/disc1
sed -i "s,REP,$url," $dir/disc1
logstr=disc,$url
md5=$(echo -n $logstr | md5sum | cut -d" " -f1)
echo $(date) $logstr $md5 >> $log
wfuzz --recipe $dir/disc1 --oF $out/$md5
rm $dir/disc1

cp $dir/recurse $dir/recurse1
sed -i "s,REP,$url," $dir/recurse1
logstr=recurse,$url
md5=$(echo -n $logstr | md5sum | cut -d" " -f1)
echo $(date) $logstr $md5 >> $log
wfuzz --recipe $dir/recurse --oF $out/$md5
rm $dir/recurse1

cp $dir/extension $dir/extension1
url2=$(echo -n $url | sed "s,FUZZ{notthere},FUZZ{notthere}.FUZ2Z{no},")
sed -i "s,REP,$url2," $dir/extension1
logstr=extension,$url2
md5=$(echo -n $logstr | md5sum | cut -d" " -f1)
echo $(date) $logstr $md5 >> $log
wfuzz --recipe $dir/extension1 --oF $out/$md5
rm $dir/extension1
