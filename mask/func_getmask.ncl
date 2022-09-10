load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/diagnostics_cam.ncl"
load "./shapefile_utils.ncl"
load "./func_get_shpnames_shpxx_box.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

undef("find_one_point_nearest_to_shape")
function find_one_point_nearest_to_shape(model_lat_2d:numeric,model_lon_2d:numeric,lat_shp_1d:numeric,lon_shp_1d:numeric)
local idx, n_shp_point, i, np, np_max_idx,point
begin
  idx = wrf_latlon_to_ij(model_lat_2d,model_lon_2d,lat_shp_1d,lon_shp_1d)
  n_shp_point = dimsizes(lat_shp_1d)
  np = new(n_shp_point,integer)
  do i = 0, n_shp_point - 1
    np(i) = num( idx(i,0).eq.idx(:,0) .and. idx(i,1).eq.idx(:,1) )
  end do
  np_max_idx = maxind(np) 
  point = new(2,typeof(model_lat_2d))
  point(0) = model_lat_2d(idx(np_max_idx,0),idx(np_max_idx,1))
  point(1) = model_lon_2d(idx(np_max_idx,0),idx(np_max_idx,1))
  return(point)
end

undef("getmask")
procedure getmask(region:string,reg_lab:string,lat:numeric,lon:numeric,\
                  file_shp0:string,file_shp1:string,file_out:string)
local  tmp, shpNames, shpXX, box, adm0_lab, latS, latN, lonW, lonE, nlat, nlon, \
       nshp, fin_shp0, fin_shp1, geometry, segments, laty, lonx, dims, nreg, ishp, startSegment,\
       numSegments, segStrt, segLast, idx_seg, iseg, startPT, endPT, lat_shp, lon_shp, \
       latS_shp, latN_shp, lonE_shp, lonW_shp, lats, lons, nlat, nlon, ylat, xlon, \
       ylat1d, xlon1d, npts, ipt, inout, npts_in, mask_out, ipt_in, ipt, ishpName, \
       map, line0, line1, line2, poly,res, resP, plres, lnres

begin

tmp = get_shpnames_shpxx_box(region)
shpNames = tmp[0]
shpXX    = tmp[1]
box      = tmp[2]

adm0_lab         = region   
latS             = box(0)
latN             = box(1)
lonW             = box(2)
lonE             = box(3)

nlat             = dimsizes(lat)
nlon             = dimsizes(lon)
nshp             = dimsizes(shpNames)

fin_shp0                 = addfile( file_shp0, "r" )
fin_shp1                 = addfile( file_shp1, "r" )
print_shapefile_info( file_shp0 )

geometry                := fin_shp1->geometry
segments                := fin_shp1->segments
laty                    := fin_shp1->y
lonx                    := fin_shp1->x
lonx                     = where(lonx .lt. 0., 360+lonx, lonx)
dims                    := dimsizes(geometry)
nreg                     = dims(0)

system("rm -rf "+ file_out+".nc")
fout = addfile(file_out+".nc","c")

;;;;;;;;;;; for plot ;;;;;;;;;;;;
res                      = True
res@gsnMaximize          = True
res@gsnDraw              = False
res@gsnFrame             = False
res@mpLimitMode          = "LatLon"
res@mpOutlineOn          = False
res@mpFillOn             = False
res@mpMinLatF            = latS
res@mpMaxLatF            = latN
res@mpMinLonF            = lonW
res@mpMaxLonF            = lonE
res@mpCenterLonF         = (lonW+lonE)/2.      

plres                    = True
plres@gsMarkerSizeF      = 0.003

lnres                 = True
lnres@gsLineThicknessF= 2.0
lnres@gsLineColor     = ndtooned(namedcolor2rgb("black"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



do ishp = 0, nshp -1 
  ishpName              = shpNames(ishp)
  
  startSegment          = geometry(ishp, 0)
  numSegments           = geometry(ishp, 1)

  segStrt               = startSegment
  segLast               = startSegment+numSegments-1
  idx_seg               = maxind(segments(segStrt:segLast, 1))

  segStrt               = startSegment+idx_seg
  segLast               = startSegment+idx_seg  

  do iseg = segStrt, segLast
     startPT            = segments(iseg, 0)
     endPT              = startPT + segments(iseg, 1) - 1
     lat_shp           := laty(startPT:endPT)
     lon_shp           := lonx(startPT:endPT)
     latS_shp           = min(laty(startPT:endPT))
     latN_shp           = max(laty(startPT:endPT))
     lonW_shp           = min(lonx(startPT:endPT))
     lonE_shp           = max(lonx(startPT:endPT))
  end do

  lats := lat({latS_shp:latN_shp})
  lons := lon({lonW_shp:lonE_shp})

  nlat  = dimsizes(lats)
  nlon  = dimsizes(lons)

  ylat  := new((/nlat, nlon/), float)
  xlon  := new((/nlat, nlon/), float)


  do ilat = 0, nlat - 1
    ylat(ilat, :) = lats(ilat)
  end do

  do ilon = 0, nlon - 1
    xlon(:, ilon) = lons(ilon)
  end do

  ylat1d := ndtooned(ylat)
  xlon1d := ndtooned(xlon)
  npts    = dimsizes(ylat1d)
  
  npts_in               = 0
  do ipt = 0, npts - 1
    inout              = gc_inout(ylat1d(ipt), xlon1d(ipt), lat_shp, lon_shp) 
    if(inout) then
      npts_in         = npts_in + 1
    end if
  end do

  if (npts_in .eq. 0) then    ; no points fall in the regions
    mask_out              := new((/1,2/), float)
    mask_out(0,:) = find_one_point_nearest_to_shape(ylat,xlon,lat_shp,lon_shp)
  else
    mask_out              := new((/npts_in,2/), float)
    ipt_in                = 0
    do ipt = 0, npts - 1
      inout              = gc_inout(ylat1d(ipt), xlon1d(ipt), lat_shp, lon_shp) 
      if(inout) then
        mask_out(ipt_in,0) = ylat1d(ipt)
        mask_out(ipt_in,1) = xlon1d(ipt)
        ipt_in          = ipt_in + 1
      end if
    end do
  end if
  mask_out!0 = "point_"+ishpName
  mask_out!1 = "lat_lon"

  fout->$ishpName$ = mask_out

;;;;;;;;;;;;;;;;;; for plot ;;;;;;;;;;;;;;;;;;;;;;;;

  wks                   = gsn_open_wks( "png", file_out+"_"+ishpName)
  gsn_define_colormap( wks, "WhViBlGrYeOrRe" )
  map             = gsn_csm_map(wks, res)
  poly            = gsn_add_shapefile_polylines(wks, map, file_shp1, lnres) 

  plres@gsMarkerColor   := ndtooned(namedcolor2rgb("red"))
  do iseg = segStrt, segLast
    startPT            = segments(iseg, 0)
    endPT              = startPT + segments(iseg, 1) - 1
    lat_shp           := laty(startPT:endPT)
    lon_shp           := lonx(startPT:endPT)
    line0              = gsn_add_polymarker(wks, map, lon_shp, lat_shp, plres)
  end do
  line1                 = gsn_add_polymarker(wks, map, xlon1d, ylat1d, plres)
  plres@gsMarkerColor   = ndtooned(namedcolor2rgb("blue"))
  line2                 = gsn_add_polymarker(wks, map, mask_out(:,1), mask_out(:,0), plres)
  
  draw(wks)
  frame(wks)
end do

end

