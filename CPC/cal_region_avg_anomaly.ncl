load "/home/wubo/script/mask/func_get_shpnames_shpxx_box.ncl"

undef ("calDayAnomT") 
function calDayAnomT (var_1d:numeric, var_clim_1d:numeric)
local  time, TIME, year, month, day, ddd, yyyyddd, var_3d, var_clim_3d
begin
  time    = var_1d&time                
  TIME    = cd_calendar(time, 0)       
  year    = toint( TIME(:,0) )
  month   = toint( TIME(:,1) )
  day     = toint( TIME(:,2) ) 
  ddd     = day_of_year(year, month, day) 
  yyyyddd = year*1000 + ddd  
  
  var_3d = conform_dims((/dimsizes(var_1d),1,1/),var_1d,0)
  var_clim_3d = conform_dims((/dimsizes(var_clim_1d),1,1/),var_clim_1d,0)

  var_3d =  calcDayAnomTLL (var_3d, yyyyddd, var_clim_3d) 
  return(var_3d(:,0,0))    

end 

begin
dir_in   = getenv("dir_out")
dir_out  = getenv("dir_out")

var_name = getenv("var")
year = getenv("year")
region_info = str_split(getenv("region_info"), " ")
tmp = get_shpnames_shpxx_box(region_info(0))
shpNames = tmp[0]
delete(tmp)

file_in   =dir_in + "/" + year+ "/" +var_name +"_" + region_info(0) + "_"+region_info(1) +"_origin.nc"
file_clim =dir_in + "/climatology/" +var_name +"_" + region_info(0) + "_"+region_info(1) +"_climatology.nc"
file_out = dir_out + "/" + year+ "/" +var_name +"_" + region_info(0) + "_"+region_info(1) +"_anomaly.nc"

fin = addfile(file_in,"r")
fclim = addfile(file_clim,"r")
system("rm -rf "+file_out)   
fout = addfile(file_out,"c") 

do k = 0, dimsizes(shpNames) - 1
  print(shpNames(k))
  var := fin->$shpNames(k)$
  var_clim := fclim->$shpNames(k)$
  var := calDayAnomT(var,var_clim)
  fout->$shpNames(k)$ = var 
end do

end 