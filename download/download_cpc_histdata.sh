#!/bin/bash

download_file() {
  local remote_file=$1
  local local_file=$2
  wget -c ${remote_file}  --ftp-user=anonymous  --ftp-password=lcx@mail.iap.ac.cn -O ${local_file}
}
export -f download_file

get_file_lastdate() {
  source ~/anaconda3/bin/activate cdo
  local file=$1
  local last_date
  last_date=`cdo sinfo ${file} | tail -n 2 |head -n 1 |  awk '{ print $(NF-1) }'`
  echo $last_date
  conda deactivate
}
export -f get_file_lastdate

get_local_files_tobedown() {
  local local_files=($1)
  local file_status=($2)
  local local_files_tobedown=()
  for (( i=0 ; i<${#local_files[@]} ; i=i+1 )) ; do
    if [ ${file_status[$i]} == "not_updated" ] ; then
      local_files_tobedown+=(${local_files[$i]})
    fi
  done
  echo ${local_files_tobedown[@]}
}
export -f get_local_files_tobedown

get_remote_files_tobedown() {
  local remote_files=($1)
  local file_status=($2)
  local remote_files_tobedown=()
  for (( i=0 ; i<${#remote_files[@]} ; i=i+1 )) ; do
    if [ ${file_status[$i]} == "not_updated" ] ; then
      remote_files_tobedown+=(${remote_files[$i]})
    fi
  done
  echo ${remote_files_tobedown[@]}
}
export -f get_remote_files_tobedown

###########################################################
for year in `seq 1971 1 1988` ; do
  download_path='/home/wubo/CPC/download/'
  
  max_processes=3
  logfile="${download_path}/out.`date +"%Y%m%d%H"`.log"
  
  remote_files=("ftp://ftp.cdc.noaa.gov/Projects/Datasets/cpc_global_precip/precip.${year}.nc" \
                "ftp://ftp.cdc.noaa.gov/Projects/Datasets/cpc_global_temp/tmin.${year}.nc"     \
                "ftp://ftp.cdc.noaa.gov/Projects/Datasets/cpc_global_temp/tmax.${year}.nc" )
  
  local_files=("${download_path}/precip/precip.${year}.nc" \
               "${download_path}/tmin/tmin.${year}.nc"     \
               "${download_path}/tmax/tmax.${year}.nc" )
  
  ####################
   
  remote_files_tobedown=(`get_remote_files_tobedown "${remote_files[*]}" "${file_status[*]}" `)
  local_files_tobedown=(`get_local_files_tobedown "${local_files[*]}" "${file_status[*]}" `)
  
  parallel -j ${max_processes} rm -rf  ::: ${local_files_tobedown[@]} 
  parallel -j ${max_processes} --link download_file ::: ${remote_files_tobedown[@]} ::: ${local_files_tobedown[@]}   

done
exit