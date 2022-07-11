undef ("func_var")
function func_var (var:numeric, func:string)
local var_out
begin
  if (func .eq. "min") then
    var_out = dim_min_n_Wrap(var,0)
  else if (func .eq. "max") then 
    var_out = dim_max_n_Wrap(var,0)
  else if (func .eq. "sum") then
    var_out = dim_sum_n_Wrap(var,0)
  else 
     print("the "+ func + " is not supported")
     exit
  end if
  end if
  end if
  return(var_out)
end 

begin

start_hhs = (/"00","06","12","18"/)
fcst_hhs = (/   6,  12,  18,  24,  30, \
               36,  42,  48,  54,  60, \
               66,  72,  78,  84,  90, \
               96, 102, 108, 114, 120, \
              126, 132, 138, 144, 150, \
              156, 162, 168, 174, 180, \
              186, 192, 198, 204, 210, \
              216, 222, 228, 234, 240, \
              246, 252, 258, 264, 270, \
              276, 282, 288, 294, 300, \
              306, 312, 318, 324, 330, \
              336, 342, 348, 354, 360, \
              366, 372, 378, 384       /)
fcst_hhs := sprinti("%0.3i", fcst_hhs)

fcst_days = ispan(0,15,1)
fcst_days_hhs = new((/4,dimsizes(fcst_days),4/),string)
do i = 0,dimsizes(start_hhs) - 1
    fcst_hhs_use := fcst_hhs
  if (i .gt. 0) then
    empty_steps := new(i,string)
    fcst_hhs_use := array_append_record(empty_steps, fcst_hhs_use, 0)
  end if 
  do j = 0, dimsizes(fcst_days) - 1
    fcst_days_hhs(i,j,:) = fcst_hhs_use(ispan(j*4,j*4+3,1))
  end do
end do
delete([/empty_steps,fcst_hhs_use/])

end 





