#!/bin/bash
source ~/anaconda3/bin/activate ncl

get_current_yyyymmdd() {
  local yyyymmdd
  yyyymmdd=`ls ${dir_in} | sed '/out/d' | awk 'END {print}'`  
  echo $yyyymmdd
}

get_current_hh() {
  local yyyymmdd=$1
  local hh 
  hh=`ls  ${dir_in}${yyyymmdd}/*_*_*.grb | awk 'END {print}' | sed 's/.*_Z//' | sed 's/_.*.grb//g' `
  echo $hh
}
export -f get_current_yyyymmdd
export -f get_current_hh

########################################

export dir_in="/home/wubo/GFS/download/"
export dir_out="/home/wubo/GFS/region_avg/"
export dir_mask="/home/wubo/mask/GFS_0p50/"

export file_climatology=""

yyyymmdd=$1
hh=$2

if [ ! -n "$yyyymmdd" ] ; then
  yyyymmdd_current=`get_current_yyyymmdd`
  export yyyymmdd=$yyyymmdd_current
fi
if [ ! -n "$hh" ] ; then
  hh_current=`get_current_hh ${yyyymmdd_current}`
  export hh=$hh_current 
fi
echo $yyyymmdd $hh 'is running'

vars=('tmax' 'tmin' 'apcp' 'csnow')
############cal original time series ####################
for var in ${vars[@]} ; do
  export var=$var
  if [ ! -d ${dir_out}/${yyyymmdd} ] ; then
    mkdir ${dir_out}/${yyyymmdd}
  fi
  ncl ./cal_region_avg.ncl 
done