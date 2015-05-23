#!/bin/bash
#
# For Elastix 2.5 (FreePBX 2.11)
# Filename: /etc/asterisk/scripts/mixmon-mp3-2.sh
# Author: Andrey Sorokin (aka shadow_alone) andrey@sorokin.org
# Article in Russian - http://andrey.org/mp3-elastix-2-5-frepbx-2-11/
# -----------------------------------
# To enable:
# rpm -Uhv http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm
# yum --disablerepo=commercial-addons install ffmpeg lame
# Settings->Advanced Settings
# Display Readonly Settings - true
# Override Readonly Settings - true
# Post Call Recording Script - /etc/asterisk/scripts/mixmon-mp3-2.sh ^{YEAR} ^{MONTH} ^{DAY} ^{CALLFILENAME} ^{MIXMON_FORMAT} ^{MIXMON_DIR}
# Override Call Recording Location - /var/spool/asterisk/monitor/
# ------------------------------------

YEAR=$1
MONTH=$2
DAY=$3
CALLFILENAME=$4
MIXMON_FORMAT=$5
MIXMON_DIR=$6

if [ -z "${MIXMON_DIR}" ]; then
SPOOLDIR="/var/spool/asterisk/monitor/"
else
SPOOLDIR=${MIXMON_DIR}
fi

FFILENAME=${SPOOLDIR}${YEAR}/${MONTH}/${DAY}/${CALLFILENAME}.${MIXMON_FORMAT}

/usr/bin/test ! -e ${FFILENAME} && exit 21

WAVFILE=${FFILENAME}
MP3FILE=`echo ${WAVFILE} | /bin/sed 's/.wav/.mp3/g'`

#SUDO="/usr/bin/sudo"
LOWNICE="/bin/nice -n 19 /usr/bin/ionice -c3"

${LOWNICE} /usr/bin/lame --quiet --preset phone -h -v ${WAVFILE} ${MP3FILE}

/bin/chmod --reference=${WAVFILE} ${MP3FILE}
/bin/touch --reference=${WAVFILE} ${MP3FILE}
/bin/chown --reference=${WAVFILE} ${MP3FILE}

/usr/bin/test -e ${MP3FILE} && /bin/rm -f ${WAVFILE}

${LOWNICE} /usr/bin/ffmpeg -loglevel quiet -y -i ${MP3FILE} -f wav -acodec copy ${WAVFILE} >/dev/null 2>&1

/bin/chmod --reference=${MP3FILE} ${WAVFILE}
/bin/touch --reference=${MP3FILE} ${WAVFILE}
/bin/chown --reference=${MP3FILE} ${WAVFILE}

/usr/bin/test -e ${WAVFILE} && /bin/rm -f ${MP3FILE}

