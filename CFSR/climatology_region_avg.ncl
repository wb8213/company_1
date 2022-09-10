load "/home/wubo/script/mask/func_get_shpnames_shpxx_box.ncl"

begin
var_names = (/"tmin","tmax","apcp","tavg","snow"/)

dir_in="/home/wubo/CFSR/climatology/"
dir_out="/home/wubo/CFSR/climatology/"
dir_mask="/home/wubo/mask/GFS_0p50/"

region_infos=(/"CHN state","ARG state","AUS state",\
             "BRA state","CAN state","CHN state",\
             "EUR country","IDN state","IND state",\
             "MYS state","USA state"/)
year_start = 2012
year_end = 2021

do  v = 0, dimsizes(var_names) - 1
  var_name = var_names(v)
 
  f = addfile(dir_in+var_name+"_"+year_start+"-"+year_end+".nc","r")
  var = f->$var_name$
  
  do i = 0,dimsizes(region_infos)-1 
    region_info := str_split(region_infos(i), " ")
    file_mask = dir_mask + "/GFS_0p50_" + region_info(0) + "_" + region_info(1) +".nc"
    file_out = dir_out + "/" + var_name + "_" + region_info(0) + "_"+region_info(1) +".nc"

    tmp := get_shpnames_shpxx_box(region_info(0))
    shpNames := tmp[0]

    fmask := addfile(file_mask, "r")
    system("rm -rf "+file_out)
    fout := addfile(file_out,"c")

    do k = 0, dimsizes(shpNames) - 1
      mask_region := fmask->$shpNames(k)$
      if (dimsizes(mask_region(:,0)) .eq. 1) then
        var_region  := var(:,{mask_region(:,0)},{mask_region(:,1)})
      else
        var_region  := dim_avg_n_Wrap(var(:,{mask_region(:,0)},{mask_region(:,1)}),(/1,2/) )
      end if
      fout->$shpNames(k)$ = var_region
    end do

  end do  
end do 
end 