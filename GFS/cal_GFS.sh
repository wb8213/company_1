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
export dir_out="/home/wubo/GFS/region_avg/"${yyyymmdd}_${hh}
if [ ! -d "${dir_out}" ] ; then
  mkdir $dir_out
fi

vars=( 'tmax' 'tmin' 'apcp' 'csnow' 'tavg')
funcs=('max'  'min'  'sum'  'sum'   'avg')
############cal original time series ####################
for ((i=0; i<${#vars[@]}; i++)) ; do
  export var=${vars[$i]}
  export func=${funcs[$i]} 
  if [ ! -d ${dir_out}/${yyyymmdd} ] ; then
    mkdir ${dir_out}/${yyyymmdd}
  fi
  ncl ./cal_region_avg.ncl 
done