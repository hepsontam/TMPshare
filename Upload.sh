#!/bin/bash
RED_FONT_PREFIX="\033[31m"
GREEN_FONT_PREFIX="\033[32m"
YELLOW_FONT_PREFIX="\033[1;33m"
LIGHT_PURPLE_FONT_PREFIX="\033[1;35m"
FONT_COLOR_SUFFIX="\033[0m"
INPUT="${GREEN_FONT_PREFIX}⇢${FONT_COLOR_SUFFIX}"

echo 'Welcome to TMP!'

shareFile=$1
echo
if [[ ! -f $shareFile ]]
then
	echo '❗️ File does not exist.'
	echo 'Assure keying in the path of file.'
	echo 'Quit.'
	exit
fi
echo -e "Path of File to Upload: ${YELLOW_FONT_PREFIX}$shareFile${FONT_COLOR_SUFFIX}"

m=$2            # Mode
if [[ -z $2 ]]
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
	*)
		echo '❗️ Nothing Chosen.'
		echo 'Quit.'
		exit
		;;
	esac
fi

k=$3
token=wpqf9qkmwxyt7g6fkuni
if [[ -z $k ]] || [[ $k  -ne 0 ]]
then
		echo
		echo 'A New Token? (n/y)'
		echo -e "${INPUT} \c"
		read new
		if [[ $new == Y ]] || [[ $new == y ]]
		then
			open -a /Applications/Google\ Chrome.app https://app.tmp.link
			echo -e "${RED_FONT_PREFIX}Please enter your new token:"
			echo -e "${INPUT} \c"
			read token2
			if [[ ! -z $token2 ]]
			then
				token=$token2
			fi
		fi
fi

echo
echo -e "Uploading...${LIGHT_PURPLE_FONT_PREFIX}"
curl -o /tmp/TMPupload.log -# -k -F "file=@$shareFile" -F "token=$token" -F "model=$m"  -X POST "https://connect.tmp.link/api_v2/cli_uploader"
# tmp -f $shareFile -m $m -k $token
echo -e "${FONT_COLOR_SUFFIX}"
cat /tmp/TMPupload.log
rm /tmp/TMPupload.log
