#!/bin/bash
check_bash_run_status() {
  local bash_script=$1
  local ps_txt=`ps -x`
  if [[ "${ps_txt}" =~ "${bash_script}" ]] ; then
    echo running
  else
    echo not_running
  fi
}
export -f check_bash_run_status


#############################################

logfile="/home/wubo/script/run/log.txt"

while true ; do
  
download_cpc_status=`check_bash_run_status "download_cpc.sh"`
if [ "${download_cpc_status}" == "not_running" ] ; then
  echo 'submit download_cpc.sh'
  nohup sh /home/wubo/script/download/download_cpc.sh > /dev/null 2>&1 &
else
  echo 'download_cpc.sh is' ${download_cpc_status}
fi

download_gfs_status=`check_bash_run_status "download_gfs.sh"`
if [ "${download_gfs_status}" == "not_running" ] ; then
  echo 'submit download_gfs.sh'
  nohup sh /home/wubo/script/download/download_gfs.sh > /dev/null 2>&1 &
else 
  echo 'download_gfs.sh is' ${download_gfs_status}
fi

cpc_download_current_date=`cat ${logfile} | grep "CPC download for" | sed -n '$p' | awk '{ print $4 }'`
#cpc_download_current_time=`cat ${logfile} | grep "CPC download for" | sed -n '$p' | awk '{ print $8 " " $9 }'`

gfs_download_current_date=`cat ${logfile} | grep "GFS download for" | sed -n '$p' | awk '{ print $4 " " $5 }'`
#gfs_download_current_time=`cat ${logfile} | grep "GFS download for" | sed -n '$p' | awk '{ print $9 " " $10 }'`

if [ "${gfs_download_current_date}" != "${gfs_download_last_date}" ] ; then
  echo submit cal_GFS.sh
  cd /home/wubo/script/GFS
  nohup sh cal_GFS.sh ${gfs_download_current_date} > /dev/null 2>&1 &
  gfs_download_last_date=${gfs_download_current_date}
fi
if [ "${cpc_download_current_date}" != "${cpc_download_last_date}" ] ; then
  echo submit cal_CPC.sh
  cd /home/wubo/script/CPC
  nohup sh cal_CPC.sh > /dev/null 2>&1 &
  cpc_download_last_date=${cpc_download_current_date}
fi
sleep 60s

done







exit