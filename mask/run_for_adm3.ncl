load "./func_getmask.ncl"
load "/home/wubo/script/mask/shapefile_utils.ncl"
begin

;;;;;;;;; for CPC ;;;;;;;;;;;;;;;;;;;;;;;;;;

grid = "CPC"
res = "x050"

target = "HONGZAO"

nlat             = 360
nlon             = 720
lat              = latGlobeFo(nlat, "lat", "latitude",  "degrees_north")
lon              = lonGlobeFo(nlon, "lon", "longitude", "degrees_east" )

;;;;;;;;;;; for GFS ;;;;;;;;;;;;;;;;;;;;;;;

;grid = "GFS"
;res  = "0p50"
;f = addfile("GFS_0p50_grid.nc","r")
;lat = f->lat_0
;lon = f->lon_0
;nlat = dimsizes(lat)
;nlon = dimsizes(lon)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



dir_in_root      = "/pub/data/shapefile/"
dir_out          = "/home/wubo/mask/"+target+"_"+grid+"_"+res+"/"
system("mkdir "+dir_out)

REGION_INFOs = (/ (/"CHN","Xinjiang Uygur","Aksu"/),    \
                  (/"CHN","Xinjiang Uygur","Kashgar"/), \
                  (/"CHN","Xinjiang Uygur","Khotan"/) \
                    /) 

dsizes = dimsizes(REGION_INFOs)
nREGIONs = dsizes(0)

do i = 1, nREGIONs - 1
  file_shp = dir_in_root+"/"+REGION_INFOs(i,0)+"_adm_shp/"+REGION_INFOs(i,0)+"_adm3.shp"
  f = addfile(file_shp, "r")
  NAME_1 = f->NAME_1 ; state or province
  NAME_2 = f->NAME_2 ; city
  NAME_3 = f->NAME_3 ; xian

  index := ind(NAME_1 .eq. REGION_INFOs(i,1))
  print( NAME_3(index) ) 

  index := ind(NAME_2 .eq. REGION_INFOs(i,2))
  print( NAME_3(index) ) 

  file_out = dir_out+"/"+grid+"_"+res+"_"+REGION_INFOs(i,0)+"_"+REGION_INFOs(i,1)+"_"+REGION_INFOs(i,2) +"_"+REGION_INFOs(i,3)


end do

end 