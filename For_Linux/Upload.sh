#!/bin/bash
token=lhcq7njonxxo5vuxrgo2

declare -A shareFile
dir=/root/TMPshare/ 
LIGHT_PURPLE_FONT_PREFIX="\033[1;35m"
FONT_COLOR_SUFFIX="\033[0m"

m=$1            
# Mode --> Set the Sharing span:  0-1 Day;  1-3 Days;  2-1 Week;  99-Long
if [[ -z $m ]]
then
	 m=0             # No input
fi

echo -e "Uploading to TMP.link..."

lines=`cat ${dir}record.txt | wc -l`
for ((i=1;i<=${lines};i++))
do
	shareFile[$i]=`sed -n ${i}p ${dir}record.txt`
	if [[ ! -f ${shareFile[$i]} ]]
	then
	    echo "Error in File $i setting."
	    echo -e "${FONT_COLOR_SUFFIX}"
		echo
		continue
	fi
	echo -e "File ${i}${LIGHT_PURPLE_FONT_PREFIX}"

	curl -o /tmp/TMPupload.log --progress-bar \
	-k -F "file=@${shareFile[$i]}" -F "model=$m" \
	-F "token=$token" -X POST "https://connect.tmp.link/api_v2/cli_uploader"
	
	echo -e "${FONT_COLOR_SUFFIX}"
done

# tmp -f $shareFile -m $m -k $token

cat /tmp/TMPupload.log
sed -n 2p /tmp/TMPupload.log | cut -d ' ' -f 3 >> /root/TMPshare/TMPupload.log
${dir}Announce.sh >> /dev/null 2>&1
rm /tmp/TMPupload.log
