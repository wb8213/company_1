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
export dir_climatology="/home/wubo/CFSR/climatology/"

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

############cal original time series ####################
vars=( 'tmax' 'tmin' 'apcp' 'snow' 'tavg')
funcs=('max'  'min'  'sum'  'sum'  'avg')
run_func(){
    export var=$1
    export func=$2
    ncl ./cal_region_avg.ncl 
}
export -f run_func
parallel -j 3 --link run_func ::: ${vars[@]} ::: ${funcs[@]} 
unset run_func
############cal anomaly #################################
vars=('tmax' 'tmin' 'apcp' 'snow' 'tavg')
funcs=('max'  'min'  'sum'  'sum'  'avg')
clim_files=('tmax_2012-2021.nc' 'tmin_2012-2021.nc' 'apcp_2012-2021.nc' 'snow_2012-2021.nc' 'tavg_2012-2021.nc')
run_func(){
    export var=$1
    export func=$2
    export clim_file=$3
    ncl ./cal_region_avg_anomaly.ncl 
}
export -f run_func
parallel -j 3 --link run_func ::: ${vars[@]} ::: ${funcs[@]} ::: ${clim_files[@]}
unset run_func

