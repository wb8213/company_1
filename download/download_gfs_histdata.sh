#!/bin/bash

get_file_url() {
  local date=$1
  local hour=$2
  local fhr=$3
  local URL_head="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_${res}.pl?"
  if [ $res == "0p25" ];then
    local file_url=(${URL_head}"file=gfs.t${hour}z.pgrb2.${res}.f${fhr}&lev_surface=on&lev_2_m_above_ground=on&var_APCP=on&var_TMIN=on&var_TMAX=on&var_ACPCP=on&var_CSNOW=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=%2Fgfs.${date}%2F${hour}%2Fatmos")
  elif [ $res == "0p50" ];then
    local file_url=(${URL_head}"file=gfs.t${hour}z.pgrb2full.${res}.f${fhr}&lev_surface=on&lev_2_m_above_ground=on&var_APCP=on&var_TMIN=on&var_TMAX=on&var_ACPCP=on&var_CSNOW=on&leftlon=0&rightlon=360&toplat=90&bottomlat=-90&dir=%2Fgfs.${date}%2F${hour}%2Fatmos") 
  else
    echo "the res is not supported"
  fi
  echo ${file_url} 
  }	

get_file() {
  local date=$1
  local hour=$2
  local fhr=$3
  local file=${download_path}/${date}/${date}_Z${hour}_${fhr}_${res}.grb
  echo ${file} 
  }
export -f get_file
export -f get_file_url

download_file() {
  local date=$1
  local hour=$2
  local fhr=$3

  local file_url=`get_file_url $date $hour $fhr`
  local file=`get_file  $date $hour $fhr`
  local dir=${download_path}/$date
  if [ ! -d "$dir" ] ; then 
    mkdir $dir
  fi
  wget -c -O ${file}  $file_url 
  }
export -f download_file

check_update() {
  local date=$1
  local hour=$2
  local URL_head="https://nomads.ncep.noaa.gov/cgi-bin/filter_gfs_${res}.pl?"

  local info_URL=${URL_head}?dir=%2Fgfs.${date}%2F${hour}%2Fatmos
  wget -c -O update_info.txt $info_URL 
  local info=`egrep -o "No files or directories found" update_info.txt ` 
  echo $info 
}
export -f check_update

get_date_hour() {
  local hour_run=`date +"%H"`
  local today=`date +"%Y%m%d"`
  local yesterday=`date +"%Y%m%d" -d "-1 days"`
  local hour
  local date
  if [ ${hour_run} -ge '12' ] && [ ${hour_run} -le '17' ] ; then
    hour='00'
    date=${today}
  elif  [ ${hour_run} -ge '18' ] && [ ${hour_run} -le '23' ]; then
    hour='06'
    date=${today}
  elif  [ ${hour_run} -ge '00' ] && [ ${hour_run} -le '05' ]; then
    hour='12'
    date=${yesterday}
  elif [ ${hour_run} -ge '06' ] && [ ${hour_run} -le '11' ]; then
    hour='18'
    date=${yesterday}
  else 
    return
  fi
  echo $date $hour
}
export -f get_date_hour

check_download_finished() {
  local date=$1
  local hour=$2
  local fhrs=($3)

  local fhr
  local file
  local fsize
  local download_status=()
  
  for fhr in ${fhrs[@]} ; do
    file=`get_file  $date $hour $fhr`
    if [ -f $file ] ; then
      fsize=`ls -lah --block-size=k $file | awk '{print $5}' | tr -cd "[0-9.]"`
      if [ "${fsize}" -gt "${fsize_limit}" ] ; then
        download_status+=('TRUE')
      else
        download_status+=('FALSE')
      fi
    else
      download_status+=('FALSE')
    fi
  done
  if [[ "${download_status[@]}" =~ 'FALSE' ]] ; then
    echo 'DOWNLOAD UNFINISHED'
  else
    echo 'DOWNLOAD FINISHED'
  fi
}
export -f check_download_finished

##################################################################################
export max_processes=8
export fsize_limit=700 #KB
export res="0p50"
export download_path="/home/wubo/GFS/download/"

logfile="${download_path}/out.`date +"%Y%m%d%H"`.log"
fhrs=('006 012 018 024 030 036 042 048' \
      '054 060 066 072 078 084 090 096' \
      '102 108 114 120 126 132 138 144' \
      '150 156 162 168 174 180 186 192' \
      '198 204 210 216 222 228 234 240' \
      '246 252 258 264 270 276 282 288' \
      '294 300 306 312 318 324 330 336' \
      '342 348 354 360 366 372 378 384')

hours=(00 06 12 18)

for date in `seq 20220831 1 20220831`  ; do
  for hour in ${hours[@]} ; do
    
    for fhrs_group in "${fhrs[@]}" ; do
      echo ${fhrs_group}
      while true ; do
        parallel -j ${max_processes} download_file ${date} ${hour}  ::: ${fhrs_group}
        status=`check_download_finished ${date} ${hour} "${fhrs_group}"`
        if [ "${status}" == 'DOWNLOAD UNFINISHED' ] ; then
          sleep 120s
        continue
      elif  [ "${status}" == 'DOWNLOAD FINISHED' ] ; then
        sleep 2s
        break
      fi
      done
    done

  done
done

exit
