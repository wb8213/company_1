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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

begin

dir_cfsr = "/home/wubo/CFSR/download/"
dir_out = "/home/wubo/CFSR/climatology/"

var_names = (/"tmin","tmax","apcp","tavg","snow"/)
var_name_longs = (/"TMIN_P8_L103_GLL0","TMAX_P8_L103_GLL0","PRATE_P8_L1_GLL0_avg","TMIN_P8_L103_GLL0","CSNOW_P8_L1_GLL0_avg"/)
funcs = (/"min","max","avg","avg","avg"/)

year_start = 2012
year_end = 2021

yyyymmdd = yyyymmdd_time(year_start, year_end, "integer")
yyyyddd = yyyymmdd_to_yyyyddd(yyyymmdd)

f = addfile(dir_cfsr+var_names(0)+"/cdas1."+yyyymmdd(0)+".pgrbh.grb2","r")
var = f->$var_name_longs(0)$
var!1 = "lat"
var!2 = "lon"
lat = var&lat
lon = var&lon
nlat = dimsizes(lat)
nlon = dimsizes(lon)

do i = 0, dimsizes(var_names) - 1
  var_name = var_names(i)
  print(var_name)
  var := new((/dimsizes(yyyymmdd),nlat,nlon/),float) 
  do j = 0, dimsizes(yyyymmdd) - 1
    print(j)
    if (var_name .eq. "tavg") then
      f = addfile(dir_cfsr+"tmin"+"/cdas1."+yyyymmdd(j)+".pgrbh.grb2","r")
      tmp := f->TMIN_P8_L103_GLL0  
      f = addfile(dir_cfsr+"tmax"+"/cdas1."+yyyymmdd(j)+".pgrbh.grb2","r")
      tmp1 := f->TMAX_P8_L103_GLL0
      tmp = (tmp + tmp1)/2.
    else if (var_name .eq. "snow") then
      f = addfile(dir_cfsr+var_name+"/cdas1."+yyyymmdd(j)+".pgrbh.grb2","r")
      tmp := f->$var_name_longs(i)$
      f = addfile(dir_cfsr+"apcp"+"/cdas1."+yyyymmdd(j)+".pgrbh.grb2","r")
      tmp1 := f->PRATE_P8_L1_GLL0_avg
      tmp := get_snow(tmp,tmp1)
    else 
      f = addfile(dir_cfsr+var_name+"/cdas1."+yyyymmdd(j)+".pgrbh.grb2","r")
      tmp := f->$var_name_longs(i)$
    end if
    end if

    var(j,:,:) = var_func(tmp,funcs(i))

    if (var_name .eq. "tmin") then
      var(j,:,:) = var(j,:,:) - 273.15
      var@units = "degC"
    end if
    if (var_name .eq. "tmax") then
      var(j,:,:) = var(j,:,:) - 273.15
      var@units = "degC"
    end if
    if (var_name .eq. "apcp") then
      var(j,:,:) = var(j,:,:) * 86400
      var@units = "mm/day"
    end if
    if (var_name .eq. "tavg") then
      var(j,:,:) = var(j,:,:) - 273.15
      var@units = "degC"
    end if   
    if (var_name .eq. "snow") then
      var(j,:,:) = var(j,:,:) * 86400
      var@units = "mm/day"
    end if

  end do

  var_clim := clmDayTLL(var, yyyyddd) 
  delete(var)
  var_clim := smthClmDayTLL(var_clim, 4)
  var_clim!1 = "lat"
  var_clim!2 = "lon"
  var_clim&lat = lat
  var_clim&lon = lon

  system("rm -rf " + dir_out+var_name+"_"+year_start+"-"+year_end+".nc")
  fout = addfile(dir_out+var_name+"_"+year_start+"-"+year_end+".nc","c") 
  fout->$var_name$ = var_clim
end do

end 


