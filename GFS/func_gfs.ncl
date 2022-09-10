undef ("get_var_name_long")
function get_var_name_long (var_name_short:string, fcst_hh:string)
local var_name_long
begin
  if (var_name_short .eq. "tmin") then
    var_name_long = "TMIN_P8_L103_GLL0_min"
  else if (var_name_short .eq. "tmax") then
    var_name_long = "TMAX_P8_L103_GLL0_max"
  else if (var_name_short .eq. "apcp") then
    var_name_long = "APCP_P8_L1_GLL0_acc"
  else if (var_name_short .eq. "snow") then
    var_name_long = "CSNOW_P8_L1_GLL0_avg"
  else if (var_name_short .eq. "tavg") then
    var_name_long = "TMIN_P8_L103_GLL0_min"
  else 
    print("the "+ var_name_short + " is not supported")
    exit
  end if
  end if
  end if
  end if
  end if
  
  if (fcst_hh .eq. "006") then
    var_name_long := var_name_long
  else 
    var_name_long := var_name_long+"6h"
  end if

  return(var_name_long)
end 

undef ("var_func")
function var_func (var:numeric, func:string)
local var_out
begin
  if (func .eq. "min") then
    var_out = dim_min_n_Wrap(var,0)
  else if (func .eq. "max") then 
    var_out = dim_max_n_Wrap(var,0)
  else if (func .eq. "sum") then
    var_out = dim_sum_n_Wrap(var,0)
  else if (func .eq. "avg") then
    var_out = dim_avg_n_Wrap(var,0)
  else 
     print("the "+ func + " is not supported")
     exit
  end if
  end if
  end if
  end if
  return(var_out)
end 

undef ("get_snow")
function get_snow(csnow:numeric,apcp:numeric)
local snow
begin
  snow = new(dimsizes(apcp),typeof(apcp))
  snow = where( csnow .eq. 1, apcp, 0. )
  return(snow)
end  

undef ("cal_yyyyddd_yyyymmdd") 
function cal_yyyyddd_yyyymmdd(yyyymmdd_init:numeric,length:numeric)
local yyyyddd_init, yyyyddds, yyyymmdds, i, yyyyddd, yyyy, ddd
begin
  yyyyddd_init = yyyymmdd_to_yyyyddd(yyyymmdd_init)
  yyyyddds = ispan(yyyyddd_init,yyyyddd_init+length - 1,1)
  yyyymmdds = new(length, integer)
  do i = 0, length - 1
    yyyyddd = yyyyddds(i)
    yyyy = yyyyddd / 1000
    ddd = yyyyddd - yyyy*1000 
    if (isleapyear(yyyy)) then 
      if (ddd .gt. 366) then 
        ddd = ddd - 366
        yyyy = yyyy + 1
      end if
    else
      if (ddd .gt. 365) then 
        ddd = ddd - 365
        yyyy = yyyy + 1
      end if
    end if
    yyyyddds(i) = yyyy*1000 + ddd 
    yyyymmdds(i) = yyyy*10000 + monthday(yyyy,ddd)
  end do
  return([/yyyyddds, yyyymmdds/])

end 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

begin
fcst_hhs = (/   6,  12,  18,  24,  30, \
               36,  42,  48,  54,  60, \
               66,  72,  78,  84,  90, \
               96, 102, 108, 114, 120, \
              126, 132, 138, 144, 150, \
              156, 162, 168, 174, 180, \
              186, 192, 198, 204, 210, \
              216, 222, 228, 234, 240, \
              246, 252, 258, 264, 270, \
              276, 282, 288, 294, 300, \
              306, 312, 318, 324, 330, \
              336, 342, 348, 354, 360, \
              366, 372, 378, 384       /)
fcst_hhs := sprinti("%0.3i", fcst_hhs)
fcst_days = ispan(0,15,1)

start_hhs = (/"00","06","12","18"/)
fcst_days_hh_idx = new((/4,dimsizes(fcst_days),4/),integer)
do i = 0,dimsizes(start_hhs) - 1
    fcst_hhs_use := ispan(0,dimsizes(fcst_hhs)-1,1)
  if (i .gt. 0) then
    empty_steps := new(i,integer)
    fcst_hhs_use := array_append_record(empty_steps, fcst_hhs_use, 0)
  end if 
  do j = 0, dimsizes(fcst_days) - 1
    fcst_days_hh_idx(i,j,:) = fcst_hhs_use(ispan(j*4,j*4+3,1))
  end do
end do
delete([/empty_steps,fcst_hhs_use/])

region_infos=(/"CHN state","ARG state","AUS state",\
               "BRA state","CAN state","CHN state",\
               "EUR country","IDN state","IND state",\
               "MYS state","USA state"/)

end 



