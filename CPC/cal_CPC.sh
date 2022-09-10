#!/bin/bash
source ~/anaconda3/bin/activate ncl

get_last_year() {
  local var=$1
  local last_year
  last_year=`ls ${dir_in}/${var} | sed -n '$p' | sed "s/^.*\///g" | sed "s/[^0-9]//g"` 
  echo $last_year
}
export get_last_year

###############################################
run_mode=${1:-"last_year"} # 'full_year' or 'last_year'
echo 'This run is for '$run_mode

export dir_in="/home/wubo/CPC/download/"
export dir_out="/home/wubo/CPC/region_avg/"
export dir_mask="/home/wubo/mask/CPC_x050/"

export climatology_years='2012 2021' 

vars=('precip' 'tmax' 'tmin')
region_infos=('CHN state' \
              'ARG state' \
              'AUS state' \
              'BRA state' \
              'CAN state' \
              'CHN state' \
              'EUR country' \
              'IDN state' \
              'IND state' \
              'MYS state' \
              'USA state' )

last_year=`get_last_year ${vars[0]}`
echo 'the last year of CPC is ' $last_year 'in our directory'

if [ "$run_mode" == "last_year" ] ; then
  years=("${last_year}")
elif [ "$run_mode" == "full_year" ] ; then
  years=`seq 1979 1 ${last_year}`
else
  echo 'run_mode setting is false'
  exit 
fi

############cal original time series ####################
for var in ${vars[@]} ; do
  export var=$var

  for year in ${years[@]} ; do
    if [ ! -d ${dir_out}/${year} ] ; then
      mkdir ${dir_out}/${year}
    fi
    export year=$year
    for region_info in "${region_infos[@]}" ; do
      export region_info="${region_info}"
      ncl ./cal_region_avg.ncl 
    done
  done
done
###########cal climatological time series ######################
if [ "$run_mode" == "full_year" ] ; then
  for var in ${vars[@]} ; do
    export var=$var
    for region_info in "${region_infos[@]}" ; do
      export region_info="${region_info}"
      ncl ./cal_region_avg_climatology.ncl
    done
  done   
fi
###########cal anomalous time series ######################
for var in ${vars[@]} ; do
  export var=$var

  for year in ${years[@]} ; do
    export year=$year
    for region_info in "${region_infos[@]}" ; do
      export region_info="${region_info}"
      ncl ./cal_region_avg_anomaly.ncl 
    done
  done
done

exit

