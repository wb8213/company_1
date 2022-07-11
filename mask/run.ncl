load "./func_getmask.ncl"

begin

;;;;;;;;; for CPC ;;;;;;;;;;;;;;;;;;;;;;;;;;

;grid = "CPC"
;res = "x050"
;nlat             = 360
;nlon             = 720
;lat              = latGlobeFo(nlat, "lat", "latitude",  "degrees_north")
;lon              = lonGlobeFo(nlon, "lon", "longitude", "degrees_east" )

;;;;;;;;;;; for GFS ;;;;;;;;;;;;;;;;;;;;;;;

grid = "GFS"
res  = "0p50"
f = addfile("GFS_0p50_grid.nc","r")
lat = f->lat_0
lon = f->lon_0
nlat = dimsizes(lat)
nlon = dimsizes(lon)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



dir_in_root      = "/pub/data/shapefile/"
dir_out          = "/home/wubo/mask/"+grid+"_"+res+"/"
system("mkdir "+dir_out)

REGION_INFOs = (/ (/"CHN","state"/), \
                  (/"ARG","state"/), \
                  (/"AUS","state"/), \
                  (/"BRA","state"/), \
                  (/"CAN","state"/), \
                  (/"CHN","state"/), \
                  (/"EUR","country"/), \
                  (/"IDN","state"/), \
                  (/"IND","state"/), \
                  (/"MYS","state"/), \
                  (/"USA","state"/) /)

dsizes = dimsizes(REGION_INFOs)
nREGIONs = dsizes(0)

do i = 0, nREGIONs - 1
  if (REGION_INFOs(i,1) .eq. "state") then
    file_shp0 = dir_in_root+"/"+REGION_INFOs(i,0)+"_adm_shp/"+REGION_INFOs(i,0)+"_adm0.shp"
    file_shp1 = dir_in_root+"/"+REGION_INFOs(i,0)+"_state_shp/"+REGION_INFOs(i,0)+"_state.shp"
  end if

  if (REGION_INFOs(i,1) .eq. "country") then
    file_shp0 = dir_in_root+"/"+REGION_INFOs(i,0)+"_country_shp/"+REGION_INFOs(i,0)+"_country.shp"
    file_shp1 = dir_in_root+"/"+REGION_INFOs(i,0)+"_country_shp/"+REGION_INFOs(i,0)+"_country.shp"
  end if
  
  file_out = dir_out+"/"+grid+"_"+res+"_"+REGION_INFOs(i,0)+"_"+REGION_INFOs(i,1)

  print(REGION_INFOs(i,0) + " " + REGION_INFOs(i,1) + " " + file_shp0+ " " + file_shp1+ " "+file_out)

  getmask(REGION_INFOs(i,0),REGION_INFOs(i,1),lat,lon,file_shp0,file_shp1,file_out)
end do

end 