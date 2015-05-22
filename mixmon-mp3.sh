#!/bin/bash

if [ -z "${MIXMONFILE}" ]; then
MIXMONFILE=${1}/${2}.${3}
fi

#if [ -z "${1}" ]; then
#TEMPDIR="/var/spool/asterisk/monitor/"
#else
#TEMPDIR=${1}
#fi


WAVFILE=${MIXMONFILE}
MP3FILE=`echo ${WAVFILE} | /bin/sed 's/.wav/.mp3/g'`

#echo $MP3FILE
SUDO="/usr/bin/sudo"
LOWNICE="/bin/nice -n 19 /usr/bin/ionice -c3"



${SUDO} ${LOWNICE} /usr/bin/lame --quiet --preset phone -h -v ${WAVFILE} ${MP3FILE}
${SUDO} /bin/chmod --reference=${WAVFILE} ${MP3FILE}
${SUDO} /bin/touch --reference=${WAVFILE} ${MP3FILE}
${SUDO} /bin/chown --reference=${WAVFILE} ${MP3FILE}

/usr/bin/test -e ${MP3FILE} && ${SUDO} /bin/rm -f ${WAVFILE}

${SUDO} ${LOWNICE} /usr/bin/ffmpeg -loglevel quiet -y -i ${MP3FILE} -f wav -acodec copy ${WAVFILE} >/dev/null 2>&1

${SUDO} /bin/chmod --reference=${MP3FILE} ${WAVFILE}
${SUDO} /bin/touch --reference=${MP3FILE} ${WAVFILE}
${SUDO} /bin/chown --reference=${MP3FILE} ${WAVFILE}
/usr/bin/test -e ${WAVFILE} && ${SUDO} /bin/rm -f ${MP3FILE}

