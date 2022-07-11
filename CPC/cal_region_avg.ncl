load "/home/wubo/script/mask/func_get_shpnames_shpxx_box.ncl"

undef ("read_var")
function read_var (box:numeric, fin:file, var_name:string)
local latS, latN, lonW, lonE, var, var1, var2, dsize1, dsize2
begin
  latS             = box(0)
  latN             = box(1)
  lonW             = box(2)
  lonE             = box(3)
  if (lonW .ge. 0) then
    var = fin->$var_name$(:,{latS:latN},{lonW:lonE})
    var!0 = "time"
    var!1 = "lat"
    var!2 = "lon"
  else 
    lonW = lonW + 360
    var1 = fin->$var_name$(:,{latS:latN},{0:lonE})
    var1!0 = "time"
    var1!1 = "lat"
    var1!2 = "lon"
    var2 = fin->$var_name$(:,{latS:latN},{lonW:})
    var2!0 = "time"
    var2!1 = "lat"
    var2!2 = "lon"

    var =  array_append_record(var1(lon|:,time|:,lat|:), var2(lon|:,time|:,lat|:),0)
    var := var(time|:,lat|:,lon|:)
    print(var&lon)
  end if
  return(var)
end 


begin
dir_in   = getenv("dir_in")
dir_out  = getenv("dir_out")
dir_mask = getenv("dir_mask")

var_name = getenv("var")
year = getenv("year")
region_info = str_split(getenv("region_info"), " ")

print(var_name + " " + year + " " + region_info)

file_in = dir_in + "/" + var_name + "/" + var_name +"."+year+".nc"
file_mask = dir_mask + "/CPC_x050_" + region_info(0) + "_" + region_info(1) +".nc"
file_out = dir_out + "/" + year +"/" +var_name +"_" + region_info(0) + "_"+region_info(1) +"_origin.nc"

tmp = get_shpnames_shpxx_box(region_info(0))
shpNames = tmp[0]
box      = tmp[2]
delete(tmp)

fmask = addfile(file_mask, "r")
fin = addfile(file_in, "r")
var = read_var(box, fin, var_name)
system("rm -rf "+file_out)
fout = addfile(file_out,"c")

do k = 0, dimsizes(shpNames) - 1
  print(shpNames(k))
  mask_region := fmask->$shpNames(k)$
  if (dimsizes(mask_region(:,0)) .eq. 1) then
    var_region  := var(:,{mask_region(:,0)},{mask_region(:,1)})
  else
    var_region  := dim_avg_n_Wrap(var(:,{mask_region(:,0)},{mask_region(:,1)}),(/1,2/) )
  end if
  fout->$shpNames(k)$ = var_region
end do

end 