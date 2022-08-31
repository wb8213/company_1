load "./func_gfs.ncl"
load "/home/wubo/script/mask/func_get_shpnames_shpxx_box.ncl"

begin
  var_name=getenv("var")
  func_name=getenv("func")
  yyyymmdd=getenv("yyyymmdd")
  start_hh=getenv("hh")

  dir_in=getenv("dir_in")
  dir_out=getenv("dir_out")
  dir_mask=getenv("dir_mask")

  files=dir_in+yyyymmdd+"/"+yyyymmdd+"_Z"+start_hh+ "_"+fcst_hhs+"_0p50.grb"
  nfiles = dimsizes(files) 
 
  var_name_long := get_var_name_long(var_name,fcst_hhs(0))
  f = addfile(files(0),"r")
  var = f->$var_name_long$
  var!0 = "lat"
  var!1 = "lon"
  lat = var&lat
  lon = var&lon
  nlat = dimsizes(lat)
  nlon = dimsizes(lon)

  var := new((/nfiles,nlat,nlon/),float)
  do i = 0, nfiles - 1  
    var_name_long := get_var_name_long(var_name,fcst_hhs(i))
    f := addfile(files(i),"r")
    var(i,:,:) = f->$var_name_long$
  end do
;;;;;;;;;;;;;;for snow;;;;;;;;;;;;;;;;;;;;;;;;
  if (var_name .eq. "snow") then
    tmp := new((/nfiles,nlat,nlon/),float)
    do i = 0, nfiles - 1
      var_name_long := get_var_name_long("apcp",fcst_hhs(i))
      f := addfile(files(i),"r")
      tmp(i,:,:) = f->$var_name_long$
    end do
    var := get_snow(var,tmp)
  end if
;;;;;;;;;;;;;;for tavg;;;;;;;;;;;;;;;;;;;;
  if (var_name .eq. "tavg") then
    tmp := new((/nfiles,nlat,nlon/),float)
    do i = 0, nfiles - 1
      var_name_long := get_var_name_long("tmax",fcst_hhs(i))
      f := addfile(files(i),"r")
      tmp(i,:,:) = f->$var_name_long$
    end do
    var := (var + tmp)/2.
  end if
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  

  var!0 = "time"
  var!1 = "lat"
  var!2 = "lon"
  var&lat = lat
  var&lon = lon
  
  to_day_idx = fcst_days_hh_idx(ind(start_hh .eq. start_hhs),:,:)
  dsizes = dimsizes(to_day_idx)
  ndays = dsizes(0)
  var_day = new((/ndays,nlat,nlon/),typeof(var))
  do i = 0, ndays - 1
    if (any(ismissing(to_day_idx(i,:)))) then
      var_day(i,:,:) = var_day@_FillValue
    else
      var_day(i,:,:) = var_func(var(to_day_idx(i,:),:,:),func_name)
    end if
  end do
  var_day!0 = "time"
  var_day!1 = "lat"
  var_day!2 = "lon"
  var_day&lat = lat
  var_day&lon = lon
  
  do i = 0,dimsizes(region_infos)-1 
    region_info := str_split(region_infos(i), " ")
    print(region_info)
    file_mask = dir_mask + "/GFS_0p50_" + region_info(0) + "_" + region_info(1) +".nc"
    file_out = dir_out + "/" + var_name + "_" + region_info(0) + "_"+region_info(1) +".nc"

    tmp = get_shpnames_shpxx_box(region_info(0))
    shpNames := tmp[0]
    delete(tmp)

    fmask := addfile(file_mask, "r")
    system("rm -rf "+file_out)
    fout := addfile(file_out,"c")

    do k = 0, dimsizes(shpNames) - 1
      print(shpNames(k))
      mask_region := fmask->$shpNames(k)$
      if (dimsizes(mask_region(:,0)) .eq. 1) then
        var_region  := var_day(:,{mask_region(:,0)},{mask_region(:,1)})
      else
        var_region  := dim_avg_n_Wrap(var_day(:,{mask_region(:,0)},{mask_region(:,1)}),(/1,2/) )
      end if
      fout->$shpNames(k)$ = var_region
    end do

  end do  
  
end 
