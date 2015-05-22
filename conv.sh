#!/bin/bash

WAVFILE=$1
MP3FILE=`echo ${WAVFILE} | /bin/sed 's/.wav/.mp3/g'`

#echo $MP3FILE

/usr/bin/lame --quiet --preset phone -h -v ${WAVFILE} ${MP3FILE}
/bin/chmod --reference=${WAVFILE} ${MP3FILE}
/bin/touch --reference=${WAVFILE} ${MP3FILE}
/bin/chown --reference=${WAVFILE} ${MP3FILE}

/usr/bin/test -e ${MP3FILE} && rm -f ${WAVFILE}

/usr/bin/ffmpeg -loglevel quiet -y -i ${MP3FILE} -f wav -acodec copy ${WAVFILE} >/dev/null 2>&1

/bin/chmod --reference=${MP3FILE} ${WAVFILE}
/bin/touch --reference=${MP3FILE} ${WAVFILE}
/bin/chown --reference=${MP3FILE} ${WAVFILE}
/usr/bin/test -e ${WAVFILE} && rm -f ${MP3FILE}

