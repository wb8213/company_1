load "/home/wubo/script/mask/func_get_shpnames_shpxx_box.ncl"

begin
dir_in   = getenv("dir_out")
dir_out  = getenv("dir_out")

var_name = getenv("var")

region_info = str_split(getenv("region_info"), " ")
tmp = get_shpnames_shpxx_box(region_info(0))
shpNames = tmp[0]
delete(tmp)

climatology_years = stringtointeger(str_split(getenv("climatology_years"), " "))
climatology_years := ispan(climatology_years(0), climatology_years(1), 1)

file_ins = new(dimsizes(climatology_years), string)
do i = 0, dimsizes(climatology_years) - 1, 1
  file_ins(i)  = dir_out + "/" + climatology_years(i) +"/" +var_name +"_" + region_info(0) + "_"+region_info(1) +"_origin.nc"
end do
file_out = dir_out + "/climatology/" +var_name +"_" + region_info(0) + "_"+region_info(1) +"_climatology.nc"

fin = addfiles(file_ins, "r")
time    = fin[:]->time                     ; time:units = "hours since 1-1-1 00:00:0.0"                               
TIME    = cd_calendar(time, 0)             ; type float 
year    = toint( TIME(:,0) )               ; toint strips meta data
month   = toint( TIME(:,1) )
day     = toint( TIME(:,2) ) 
ddd     = day_of_year(year, month, day) 
yyyyddd = year*1000 + ddd    

system("rm -rf "+file_out)
fout = addfile(file_out,"c")

do k = 0, dimsizes(shpNames) - 1
  print(shpNames(k))
  var := fin[:]->$shpNames(k)$
  var := conform_dims((/dimsizes(var),1,1/), var, 0)  
  var_clim := clmDayTLL(var, yyyyddd) 
  var_clim := smthClmDayTLL(var_clim, 4)
  fout->$shpNames(k)$ = var_clim(:,0,0) 
end do

end 