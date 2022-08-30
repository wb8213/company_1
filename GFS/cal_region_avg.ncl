load "./func_gfs.ncl"
begin
  var_name=getenv("var")
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
    if (var_name .eq. "csnow") then
      var_name_long := get_var_name_long("apcp",fcst_hhs(i))
      tmp = f->$var_name_long$
      var(i,:,:) = get_snow(var(i,:,:),tmp)
    end if
  end do
  var!0 = "time"
  var!1 = "lat"
  var!2 = "lon"
  var&lat = lat
  var&lon = lon
 
  print(fcst_days_hh_idx)
  

end 
