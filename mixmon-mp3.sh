#!/bin/bash
#
# For Elastix < 2.5 (FreePBX 2.8)
# Filename: /etc/asterisk/scripts/mixmon-mp3.sh
# Author: Andrey Sorokin (aka shadow_alone) andrey@sorokin.org
# Article in Russian - http://andrey.org/mp3-elastix-2-5-frepbx-2-11/
# -----------------------------------
# To enable:
# rpm -Uhv http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm
# yum --disablerepo=commercial-addons install ffmpeg lame
# -> General Settings
# Run after record: /etc/asterisk/scripts/mixmon-mp3.sh ^{MIXMON_DIR} ^{CALLFILENAME} ^{MIXMON_FORMAT}
# Recording Location: /var/spool/asterisk/monitor/
# ------------------------------------

if [ -z "${MIXMONFILE}" ]; then
MIXMONFILE=${1}/${2}.${3}
fi

WAVFILE=${MIXMONFILE}
MP3FILE=`echo ${WAVFILE} | /bin/sed 's/.wav/.mp3/g'`

SUDO="/usr/bin/sudo"
LOWNICE="/bin/nice -n 19 /usr/bin/ionice -c3"

${SUDO} ${LOWNICE} /usr/bin/lame --quiet --preset phone -h -v ${WAVFILE} ${MP3FILE}
/bin/chmod --reference=${WAVFILE} ${MP3FILE}
/bin/touch --reference=${WAVFILE} ${MP3FILE}
/bin/chown --reference=${WAVFILE} ${MP3FILE}

/usr/bin/test -e ${MP3FILE} && /bin/rm -f ${WAVFILE}

${SUDO} ${LOWNICE} /usr/bin/ffmpeg -loglevel quiet -y -i ${MP3FILE} -f wav -acodec copy ${WAVFILE} >/dev/null 2>&1

/bin/chmod --reference=${MP3FILE} ${WAVFILE}
/bin/touch --reference=${MP3FILE} ${WAVFILE}
/bin/chown --reference=${MP3FILE} ${WAVFILE}
/usr/bin/test -e ${WAVFILE} && /bin/rm -f ${MP3FILE}

