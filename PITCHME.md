WRF for WIMEA-ICT
===

![](assets/wrf-logo.png)

## How to use it

###### **Damas Makweba**, DIT - Dar Es Salam Institute of Technologies - ( [@dmakweba](https://github.com/dmakweba) )
###### **Mario Torrisi**, DFA-UNICT - Physics and Astronomy Department, University of Catania - ( [@mtorrisi](https://github.com/mtorrisi) )

---

# WRF user interface

![](assets/screenshot.png)

+++

# The `namelist.wps` file

Select the **namelist.wps** using the '*Choose File*' button. Following an example of *WPS* file of Italy.

``` wps
&share
 wrf_core = 'ARW',
 max_dom = 2,
 start_date = '2017-05-11_00:00:00','2017-05-11_00:00:00',
 end_date   = '2017-05-22_00:00:00','2017-05-22_00:00:00',
 interval_seconds = 21600
 io_form_geogrid = 2,
/

&geogrid
 parent_id         =   1,   1,
 parent_grid_ratio =   1,   3,
 i_parent_start    =   1,  31,
 j_parent_start    =   1,  17,
 e_we              =  74, 112,
 e_sn              =  61,  97,
 geog_data_res     = '10m','2m',
 dx = 30000,
 dy = 30000,
 map_proj = 'lambert',
 ref_lat   =  41.902320,
 ref_lon   =  12.493420,
 truelat1  =  30.0,
 truelat2  =  60.0,
 stand_lon = -98.0,
 geog_data_path = '/home/WRF/geog'
/

&ungrib
 out_format = 'WPS',
 prefix = 'FILE',
/

&metgrid
 fg_name = 'FILE'
 io_form_metgrid = 2,
/
```

> **N.B.** Use `/home/WRF/geog` in `geog_data_path`

---

# The `namelist.input` file

Select the **namelist.input** using the '*Choose File*' button. Following an example of *INPUT* file.

```
&time_control
run_days                            = 0,
run_hours                           = 12,
run_minutes                         = 0,
run_seconds                         = 0,
start_year                          = 2017, 2017, 2017,
start_month                         = 05,   05,   05,
start_day                           = 11,   11,   11,
start_hour                          = 00,   00,   00,
start_minute                        = 00,   00,   00,
start_second                        = 00,   00,   00,
end_year                            = 2017, 2017, 2017,
end_month                           = 05,   05,   05,
end_day                             = 22,   22,   22,
end_hour                            = 00,   00,   00,
end_minute                          = 00,   00,   00,
end_second                          = 00,   00,   00,
interval_seconds                    = 21600
input_from_file                     = .true.,.true.,.true.,
history_interval                    = 180,  60,   60,
frames_per_outfile                  = 1000, 1000, 1000,
restart                             = .false.,
restart_interval                    = 5000,
io_form_history                     = 2
io_form_restart                     = 2
io_form_input                       = 2
io_form_boundary                    = 2
debug_level                         = 0
/

&domains
time_step                           = 180,
time_step_fract_num                 = 0,
time_step_fract_den                 = 1,
max_dom                             = 1,
e_we                                = 74,    112,   94,
e_sn                                = 61,    97,    91,
e_vert                              = 30,    30,    30,
p_top_requested                     = 5000,
num_metgrid_levels                  = 32,
num_metgrid_soil_levels             = 4,
dx                                  = 30000, 10000,  3333.33,
dy                                  = 30000, 10000,  3333.33,
grid_id                             = 1,     2,     3,
parent_id                           = 0,     1,     2,
i_parent_start                      = 1,     31,    30,
j_parent_start                      = 1,     17,    30,
parent_grid_ratio                   = 1,     3,     3,
parent_time_step_ratio              = 1,     3,     3,
feedback                            = 1,
smooth_option                       = 0
/

&physics
mp_physics                          = 3,     3,     3,
ra_lw_physics                       = 1,     1,     1,
ra_sw_physics                       = 1,     1,     1,
radt                                = 30,    30,    30,
sf_sfclay_physics                   = 1,     1,     1,
sf_surface_physics                  = 2,     2,     2,
bl_pbl_physics                      = 1,     1,     1,
bldt                                = 0,     0,     0,
cu_physics                          = 1,     1,     0,
cudt                                = 5,     5,     5,
isfflx                              = 1,
ifsnow                              = 1,
icloud                              = 1,
surface_input_source                = 1,
num_soil_layers                     = 4,
sf_urban_physics                    = 0,     0,     0,
/

&fdda
/

&dynamics
w_damping                           = 0,
diff_opt                            = 1,      1,      1,
km_opt                              = 4,      4,      4,
diff_6th_opt                        = 0,      0,      0,
diff_6th_factor                     = 0.12,   0.12,   0.12,
base_temp                           = 290.
damp_opt                            = 0,
zdamp                               = 5000.,  5000.,  5000.,
dampcoef                            = 0.2,    0.2,    0.2
khdif                               = 0,      0,      0,
kvdif                               = 0,      0,      0,
non_hydrostatic                     = .true., .true., .true.,
moist_adv_opt                       = 1,      1,      1,     
scalar_adv_opt                      = 1,      1,      1,     
/

&bdy_control
spec_bdy_width                      = 5,
spec_zone                           = 1,
relax_zone                          = 4,
specified                           = .true., .false.,.false.,
nested                              = .false., .true., .true.,
/

&grib2
/

&namelist_quilt
nio_tasks_per_group = 0,
nio_groups = 1,
/
```

---

# Demo

![Video](https://www.youtube.com/embed/vSI9fEwghHw)

---

### Thank you!
#### [www.sci-gaia.eu](https://www.sci-gaia.eu)
