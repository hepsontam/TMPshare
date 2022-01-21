#!/bin/bash
RED_FONT_PREFIX="\033[31m"
GREEN_FONT_PREFIX="\033[32m"
YELLOW_FONT_PREFIX="\033[1;33m"
FONT_COLOR_SUFFIX="\033[0m"
INPUT="${GREEN_FONT_PREFIX}⇢${FONT_COLOR_SUFFIX}"

declare -A shareFile path
dir=/root/TMPshare/
#curDir=${PWD}
parDir=`dirname $PWD`

function processName(){
	name=`echo ${1} | sed "s@\.\./@${parDir}/@"`
	name=`echo ${1} | sed "s@\./@${PWD}/@"`
	if [[ ! -z `echo ${1} | sed "s,/.*,,g"` ]]
	then
		name=${PWD}/${name}
	fi
	return $name
}

echo 'Welcome to TMP Setting!'
echo -e "${RED_FONT_PREFIX}  No sapce in path names!!!${FONT_COLOR_SUFFIX}"

m=$1           # Mode
if [[ -z $1 ]]
then
	echo
	echo 'Set the Sharing span:  1⃣️  1 Day   2⃣️  3 Days   3⃣️  1 Week'
	echo -e "${INPUT} \c"
	read m
	case $m in
	'')
		m=0             # No input
		;;
	[1-3])
		m=`expr $m - 1` # Default -> Share for 1 Day
		;;
	99)
		;;
	*)
		echo '❗️ Nothing Chosen.'
		echo 'Quit.'
		exit
		;;
	esac
fi

k=$2
token=''
if [[ ${#k} -eq 20 ]]    # A New Token owns 20 characters.
then
	token=$k
elif [[ $k == N ]] || [[ $k == new ]]
then
	echo
	echo -e "${RED_FONT_PREFIX}Please enter your new token:"
	echo -e "${INPUT} \c"
	read token2
	if [[ ${#token2} -eq 20 ]]
	then
		token=$token2
	fi
fi

if [[ ! -z $token ]]
then
	sed -i "2s/=.*/=${token}/" ${dir}Upload.sh
fi

## Haven't set the path
if [[ -z $3 ]]  
then
	#sed -i "3s@=.*@=@" $action          # reset
	echo 'Path of the sharing file:'
	echo -e "${INPUT} \c"
	read path
	for ((i=1;i<11;i++))
	do
		if [[ -z ${path[$i]} ]]
		then			
			continue
		fi
		shareFile=("${shareFile[*]}" ${path[$i]})
	done
fi
## Cpature the input path
for ((i=3;i<11;i++))
do
	if [[ ! -z \$$i ]]
	then
		shareFile=("${shareFile[*]}" \$$i)
		
	fi
done
## shareFile=`echo $1 | sed 's, ,@,g'`
#echo $shareFile

## Record the path to record.txt
rm ${dir}record.txt
echo -e "Path of File to Upload:${YELLOW_FONT_PREFIX}"
for e in $shareFile
do
	processName $e
	if [[ ! -f $e ]]
	then
		echo "$e ❗️"
		# echo 'Assure keying in the legal path of file.'
		echo
		continues
	fi
	echo $e >> ${dir}record.txt
	echo "$e ✅"
	echo
## shareFile=`echo ${shareFile} | sed 's,@,\\ ,g'
done
echo -e "${FONT_COLOR_SUFFIX}"

echo
echo 'All of the settings have been done.'

echo -e "${GREEN_FONT_PREFIX}"
echo 'Take An Action? (n/y)'
echo -e "${INPUT} \c"
read a
if [[ $a == Y ]] || [[ $a == y ]]
then
	echo Uploaded.
	# /root/TMPshare/Upload.sh
else
	echo
	echo 'Quit.'
fi
