;;;从田螺山出发的古人类移动距离示意图
;;地图大小为：160km * 80km

;;分辨率100m

;;

;;时间段：7000-6600  6200-5800  5400-5000


extensions [gis]

breed [MHs MH]
breed [settlements settlement]
breed [LU a-LU]

globals [elevation aspect slope sea xcoord  ycoord nr_of_houses  t r  sump  iter  h fieldsize  year

  a b side n-1 n-2 n-3 n-4 n-5


 area_strong
 area_middle
 area_weak
 area_all






  ;;6900BP
  xcoord01  ycoord01
  xcoord02  ycoord02
  xcoord03  ycoord03
  xcoord04  ycoord04
  xcoord05  ycoord05
  xcoord06  ycoord06

  ;;6200BP
  xcoord001  ycoord001
  xcoord002  ycoord002
  xcoord003  ycoord003
  xcoord004  ycoord004
  xcoord005  ycoord005
  xcoord006  ycoord006
  xcoord007  ycoord007
  xcoord008  ycoord008
  xcoord009  ycoord009
  xcoord010  ycoord010
  xcoord011  ycoord011
  xcoord012  ycoord012
  xcoord013  ycoord013
  xcoord014  ycoord014
  xcoord015  ycoord015
  xcoord016  ycoord016
  xcoord017  ycoord017
  xcoord018  ycoord018
  ;;5500BP
  xcoord-01  ycoord-01
  xcoord-02  ycoord-02
  xcoord-03  ycoord-03
  xcoord-04  ycoord-04
  xcoord-05  ycoord-05
  xcoord-06  ycoord-06
  xcoord-07  ycoord-07
  xcoord-08  ycoord-08
  xcoord-09  ycoord-09
  xcoord-10  ycoord-10
  xcoord-11  ycoord-11
  xcoord-12  ycoord-12
  xcoord-13  ycoord-13
  xcoord-14  ycoord-14
  xcoord-15  ycoord-15
  xcoord-16  ycoord-16
  xcoord-17  ycoord-17
  xcoord-18  ycoord-18
  xcoord-19  ycoord-19
  xcoord-20  ycoord-20
  xcoord-21  ycoord-21
  xcoord-22  ycoord-22
  xcoord-23  ycoord-23
  xcoord-24  ycoord-24
  xcoord-25  ycoord-25
  xcoord-26  ycoord-26
  xcoord-27  ycoord-27
  xcoord-28  ycoord-28
  xcoord-29  ycoord-29
  xcoord-30  ycoord-30
]


patches-own [
  pelevation paspect pslope psea psoiltype pplant pstandage pheading  ptemp pnum
  ptravelselect_0 ptravelselect_1 ptravelselect_2 ptravelselect_3 ptravelselect_4 ptravelselect_5 ptravelselect_6 ptravelselect_7
  pdanger ptravelcost
  pgathered? p1gathered? pbrowsed? pfished? phunted? pfwcollected?  ptimbercollected? pfield? ppaint?  pcame?
  p_LUfodder  p_timberstock  p_fwstock  p_acornstock p_fruitstock  p_fish  p_game p_paint
  pgatheredtime p1gatheredtime pbrowsedtime pfishedtime phuntedtime pfwcollectedtime  ptimbercollectedtime ppainttime    ;;最近一次访问的时间
  pygathered? py1gathered? pybrowsed? pyfished? pyhunted? pyfwcollected?  pytimbercollected? pypaint?                    ;;今年是否已经被访问过
  pgatheredt  p1gatheredt pbrowsedt pfishedt phuntedt pfwcollectedt  ptimbercollectedt ppaintcollectedt                  ;;同一地区被访问的总次数

  whohuntercome       ;;哪些聚落的人到此访问过
  whofishercome
  whogathercome
  huntcomesitesnumber ;;访问过该区域的遗址数量
  fishcomesitesnumber
  gathercomesitesnumber

  whotimbercome


  pside            ;;记录简化栅格的栅格边长大小
  pn1  pn2  pn3 pn4 pn5  ;;记录不同活动在10*10栅格范围内的访问次数

  psite1 psite2 psite3 psite4 psite5  psite6
]
turtles-own[
 travelcost
]

MHs-own [all-energy  MHfieldsize MHcropyield MHcerealstore MHcerealshare MHLUshare MHLUstore MHgshare  MHgstore MHg1share MHg1store  MHhshare  MHhstore MHfshare MHfstore MHDeficit MHfirewood MHtimber MHpaint
     MHshow?

]
settlements-own [area_LU area_gather area_gather1 area_fields  area_firewood area_timber area_hunt area_fish area_paint area_seafish ]
LU-own [herdsize herd_fodder_demand]

to SETUP

   ca
   reset-ticks
   setup-patches
   init-gis
   Define-resources
   set h 0


end

to setup-pdanger
  ask patches [
    if(ptravelcost >= 3000 and paspect < 30)[set pdanger 2]
    if(ptravelcost >= 3000 and paspect >= 30)[set pdanger 3]
    if(ptravelcost < 3000 and paspect < 30)[set pdanger 1]
    if(ptravelcost < 3000 and paspect >= 30)[set pdanger 1.5]
    if(psoiltype = 4)[set pdanger 3]

    if(pdanger != 1 and pdanger != 1.5 and pdanger != 2 and pdanger != 3 and ptravelcost < 3000)[
      set pdanger 1.5   ;;由于这个地方是水库没有slope和aspect的数据，但是由于都是河谷地区，危险性还是比较高的
      set pslope 1 + random 14
      set paspect 1 + random 90
      set pelevation random 10
    ]
    if(pdanger != 1 and pdanger != 1.5 and pdanger != 2 and pdanger != 3 and ptravelcost >= 3000)[
      set pdanger 3   ;;由于这个地方是水库没有slope和aspect的数据，但是由于都是河谷地区，危险性还是比较高的
      set pslope 1 + random 14
      set paspect 1 + random 90
      set pelevation random 10
    ]
  ]
end

to CHOOSE-SITE


  ;;6900
    if Location6900 = "1" and time = "6900BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord01 ycoord01
        set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
    if Location6900 = "2" and time = "6900BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord02 ycoord02
        set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0
    ]
  ]
    if Location6900 = "3" and time = "6900BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord03 ycoord03
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
    if Location6900 = "4" and time = "6900BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord04 ycoord04
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
    if Location6900 = "5" and time = "6900BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord05 ycoord05
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
    if Location6900 = "6" and time = "6900BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord06 ycoord06
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]



  ;;6200
      if Location6200 = "1" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord001 ycoord001
        set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
    if Location6200 = "2" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord002 ycoord002
        set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0
    ]
  ]
    if Location6200 = "3" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord003 ycoord003
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
    if Location6200 = "4" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord004 ycoord004
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
    if Location6200 = "5" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord005 ycoord005
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
    if Location6200 = "6" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord006 ycoord006
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
      if Location6200 = "7" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord007 ycoord007
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
      if Location6200 = "8" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord008 ycoord008
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
      if Location6200 = "9" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord009 ycoord009
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
      if Location6200 = "10" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord010 ycoord010
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
      if Location6200 = "11" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord011 ycoord011
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
      if Location6200 = "12" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord012 ycoord012
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
      if Location6200 = "13" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord013 ycoord013
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]

      if Location6200 = "14" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord014 ycoord014
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
      if Location6200 = "15" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord015 ycoord015
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
      if Location6200 = "16" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord016 ycoord016
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
      if Location6200 = "17" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord017 ycoord017
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
      if Location6200 = "18" and time = "6200BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord018 ycoord018
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]

  ;;5500
        if Location5500 = "1" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-01 ycoord-01
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
         if Location5500 = "2" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-02 ycoord-02
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
         if Location5500 = "3" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-03 ycoord-03
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
          if Location5500 = "4" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-04 ycoord-04
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
            if Location5500 = "5" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-05 ycoord-05
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
          if Location5500 = "6" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-06 ycoord-06
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
          if Location5500 = "7" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-07 ycoord-07
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
          if Location5500 = "8" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-08 ycoord-08
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
            if Location5500 = "9" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-09 ycoord-09
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
            if Location5500 = "10" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-10 ycoord-10
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
              if Location5500 = "11" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-11 ycoord-11
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
              if Location5500 = "12" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-12 ycoord-12
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
              if Location5500 = "13" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-13 ycoord-13
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
              if Location5500 = "14" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-14 ycoord-14
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
              if Location5500 = "15" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-15 ycoord-15
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
              if Location5500 = "16" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-16 ycoord-16
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
            if Location5500 = "17" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-17 ycoord-17
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
              if Location5500 = "18" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-18 ycoord-18
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
              if Location5500 = "19" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-19 ycoord-19
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
                if Location5500 = "20" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-20 ycoord-20
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
              if Location5500 = "21" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-20 ycoord-20
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
                if Location5500 = "22" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-22 ycoord-22
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
                if Location5500 = "23" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-23 ycoord-23
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
                if Location5500 = "24" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-24 ycoord-24
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
                if Location5500 = "25" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-25 ycoord-25
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
                if Location5500 = "26" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-26 ycoord-26
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
                if Location5500 = "27" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-27 ycoord-27
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
                if Location5500 = "28" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-28 ycoord-28
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
                if Location5500 = "29" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-29 ycoord-29
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]
                if Location5500 = "30" and time = "5500BP"
  [
    crt 7200
    ask turtles
    [setxy xcoord-30 ycoord-30
    set heading h
    set h h + 0.05
    if h = 360 [set h  0]
    set size 10
    set travelcost 0]
  ]

;  if area = "all-hemudu"
;  [
;     create-T1s  7200
;   ask turtles
;  [
;    setxy xcoord06 ycoord06
;
;    set heading h
;    set h h + 0.05
;    if h = 360 [set h  0]
;    set size 10
;  ]
;     create-T2s 7200
;   ask turtles
;  [
;    setxy xcoord01 ycoord01
;
;    set heading h
;    set h h + 0.05
;    if h = 360 [set h  0]
;    set size 10
;  ]
;     create-T3s 7200
;   ask turtles
;  [
;    setxy xcoord02 ycoord02
;
;    set heading h
;    set h h + 0.05
;    if h = 360 [set h  0]
;    set size 10
;  ]
;     create-T4s 7200
;   ask turtles
;  [
;    setxy xcoord03 ycoord03
;
;    set heading h
;    set h h + 0.05
;    if h = 360 [set h  0]
;    set size 10
;  ]
;     create-T5s 7200
;   ask turtles
;  [
;    setxy xcoord04 ycoord04
;
;    set heading h
;    set h h + 0.05
;    if h = 360 [set h  0]
;    set size 10
;  ]
;     create-T6s 7200
;   ask turtles
;  [
;    setxy xcoord05 ycoord05
;    set heading h
;    set h h + 0.05
;    if h = 360 [set h  0]
;    set size 10
;  ]
;  ]
;  if area != "all-hemudu"[     crt 7200
;   ask turtles
;  [
;    setxy xcoord ycoord
;    set heading h
;    set h h + 0.05
;    set size 10
;  ]]


end


to GET-LOCATION
     ask turtles [die]
     setup-turtles
     setup-pdanger
end

to setup-patches

    ;;区域区分
  if (area = "all-hemudu")
  [
    ;;6900BP
    set xcoord01 79
  set ycoord01 53         ;;田螺山

    set xcoord02 55
  set ycoord02 -8         ;;河姆渡

    set xcoord03 -24
  set ycoord03  65        ;;鲻山

    set xcoord04 -80      ;;童家岙
  set ycoord04 122

    set xcoord05 114      ;;傅家山
  set ycoord05  42

    set xcoord06 66      ;;井头山
  set ycoord06 55

    ;;6200BP
  set xcoord001 256 set ycoord001 78   ;12
  set xcoord002 57  set ycoord002 24   ;18
  set xcoord003 57  set ycoord003 3    ;17
  set xcoord004 53  set ycoord004 -9   ;8
  set xcoord005 45  set ycoord005 -11  ;3
  set xcoord006 159 set ycoord006 10   ;23
  set xcoord007 152 set ycoord007 23   ;22
  set xcoord008 125 set ycoord008 27   ;21
  set xcoord009 114 set ycoord009 39   ;19
  set xcoord010 116 set ycoord010 44   ;20
  set xcoord011 80  set ycoord011 51   ;4
  set xcoord012 -4  set ycoord012 27   ;16
  set xcoord013 2   set ycoord013 51   ;15
  set xcoord014 -26 set ycoord014 51   ;14
  set xcoord015 -28 set ycoord015 77   ;7
  set xcoord016 -38 set ycoord016 71   ;2
  set xcoord017 -88 set ycoord017 74   ;13
  set xcoord018 -75 set ycoord018 125  ;1

    ;;5500
  set xcoord-01 256 set ycoord-01 78   ;27
  set xcoord-02 159 set ycoord-02 13   ;23
  set xcoord-03 125 set ycoord-03 27   ;21
  set xcoord-04 152 set ycoord-04 23   ;22
  set xcoord-05 126 set ycoord-05 51   ;5
  set xcoord-06 116 set ycoord-06 44   ;20
  set xcoord-07 114 set ycoord-07 39   ;19
  set xcoord-08 105 set ycoord-08 31   ;48
  set xcoord-09 73  set ycoord-09 20   ;18
  set xcoord-10 53  set ycoord-10 -9   ;8
  set xcoord-11 52  set ycoord-11 -11  ;47
  set xcoord-12 45  set ycoord-12  -11 ;3
  set xcoord-13 27  set ycoord-13 -5   ;46
  set xcoord-14 18  set ycoord-14 22   ;45
  set xcoord-15 11  set ycoord-15 20   ;44
  set xcoord-16 2   set ycoord-16 26   ;16
  set xcoord-17 -12 set ycoord-17 36   ;43
  set xcoord-18 1   set ycoord-18 52   ;15
  set xcoord-19 -12 set ycoord-19 76   ;41
  set xcoord-20 -30 set ycoord-20 79   ;39
  set xcoord-21 -27 set ycoord-21 69   ;40
  set xcoord-22 -28 set ycoord-22 50   ;14
  set xcoord-23 -68 set ycoord-23 43   ;38
  set xcoord-24 -88 set ycoord-24 62   ;37
  set xcoord-25 -90 set ycoord-25 70   ;13
  set xcoord-26 -107 set ycoord-26 68  ;36
  set xcoord-27 -106 set ycoord-27 87  ;35
  set xcoord-26 -107 set ycoord-26 68  ;36
  set xcoord-27 -106 set ycoord-27 87  ;35
  set xcoord-28 -146 set ycoord-28 97  ;31
  set xcoord-29 -149 set ycoord-29 108 ;32
  set xcoord-30 -75 set ycoord-30 125  ;1

  set elevation gis:load-dataset "D:/古人类行为模拟/姚江谷地完整模拟信息/海拔.asc"
  set slope gis:load-dataset "D:/古人类行为模拟/姚江谷地完整模拟信息/坡度.asc"
  set aspect gis:load-dataset "D:/古人类行为模拟/姚江谷地完整模拟信息/坡向.asc"

   if(time = "6900BP")
  [set sea gis:load-dataset "D:/古人类行为模拟/姚江谷地完整模拟信息/6900年海岸线状况.asc"
    gis:apply-raster sea psea]

   if(time = "6200BP")
  [set sea gis:load-dataset "D:/古人类行为模拟/姚江谷地完整模拟信息/6200年海岸线状况.asc"
    gis:apply-raster sea psea]

   if(time = "5500BP")
  [set sea gis:load-dataset "D:/古人类行为模拟/姚江谷地完整模拟信息/5500海岸线02.asc"
    gis:apply-raster sea psea]

  ]




  ;;区域区分
  if (area = "tianluoshan")
  [

  set xcoord -1
  set ycoord -12

  set elevation gis:load-dataset "C:/Users/12524/Desktop/tianluoshanelevation14km/tianluoshan海拔14km.asc"
  set slope gis:load-dataset "C:/Users/12524/Desktop/tianluoshansaa14km/tianluoshan坡度14.asc"
  set aspect gis:load-dataset "C:/Users/12524/Desktop/tianluoshansaa14km/tianluoshan坡向14.asc"

  if(time = "6900BP")
  [set sea gis:load-dataset "C:/Users/12524/Desktop/tianluoshanelevation14km/6900bptianluoshansea.asc"
    gis:apply-raster sea psea]
  ]


  if (area = "fujiashan")
  [

  set xcoord 3
  set ycoord -20

  set elevation gis:load-dataset "C:/Users/12524/Desktop/fujiashanelevation14km/fujiashan海拔14.asc"
  set slope gis:load-dataset "C:/Users/12524/Desktop/fujiashansaa14km/fujiashan坡度14.asc"
  set aspect gis:load-dataset "C:/Users/12524/Desktop/fujiashansaa14km/fujiashan坡向14.asc"
  if(time = "6900BP")
  [set sea gis:load-dataset "C:/Users/12524/Desktop/fujiashanelevation14km/6900bpfujiashansea.asc"
    gis:apply-raster sea psea]
  ]


  if (area = "hemudu")
  [

  set xcoord 0
  set ycoord 20

  set elevation gis:load-dataset "C:/Users/12524/Desktop/hemuduelevation14km/hemudu海拔14.asc"
  set slope gis:load-dataset "C:/Users/12524/Desktop/hemudusaa14km/hemudu坡度14.asc"
  set aspect gis:load-dataset "C:/Users/12524/Desktop/hemudusaa14km/hemudu坡向14.asc"
  if(time = "6900BP")
  [set sea gis:load-dataset "C:/Users/12524/Desktop/hemuduelevation14km/6900bphemudusea.asc"
   gis:apply-raster sea psea]
  ]


  if (area = "zishan")
  [

  set xcoord 5
  set ycoord -9

  set elevation gis:load-dataset "C:/Users/12524/Desktop/zishanelevation14km/zishan海拔14.asc"
  set slope gis:load-dataset "C:/Users/12524/Desktop/zishansaa14km/zishan坡度14.asc"
  set aspect gis:load-dataset "C:/Users/12524/Desktop/zishansaa14km/zishan坡向14.asc"

  ]
    if (area = "jingtoushan")
  [

  set xcoord -1
  set ycoord -29

  set elevation gis:load-dataset "C:/Users/12524/Desktop/jingtoushanelevation14km/jingtoushan海拔14.asc"
  set slope gis:load-dataset "C:/Users/12524/Desktop/jingtoushansaa14km/jingtoushan坡度14.asc"
  set aspect gis:load-dataset "C:/Users/12524/Desktop/jingtoushansaa14km/jingtoushan坡向14.asc"
  if(time = "6900BP")
  [set sea gis:load-dataset "C:/Users/12524/Desktop/jingtoushanelevation14km/6900bpjingtoushansea1.asc"
      gis:apply-raster sea psea]

  ]



    if (area = "xiaodongmen")
  [

  set xcoord 10
  set ycoord 50

  set elevation gis:load-dataset "C:/Users/12524/Desktop/jingtoushanelevation14km/jingtoushan海拔14.asc"
  set slope gis:load-dataset "C:/Users/12524/Desktop/jingtoushansaa14km/jingtoushan坡度14.asc"
  set aspect gis:load-dataset "C:/Users/12524/Desktop/jingtoushansaa14km/jingtoushan坡向14.asc"
  if(time = "6900BP")
  [set sea gis:load-dataset "D:/古人类行为模拟/田螺山海拔坡向坡度图/田螺山海岸线/tianluoshan6900海岸线01.asc"
    gis:apply-raster sea psea]
  if(time = "6200BP")
  [set sea gis:load-dataset "D:/古人类行为模拟/田螺山海拔坡向坡度图/田螺山海岸线/tianluoshan6900海岸线01.asc"
      gis:apply-raster sea psea]
  if(time = "5500BP")
  [set sea gis:load-dataset "D:/古人类行为模拟/田螺山海拔坡向坡度图/田螺山海岸线/tianluoshan6900海岸线01.asc"
      gis:apply-raster sea psea]
  ]


   if (area = "tongjiaao")
  [

  set xcoord 5
  set ycoord 5

  set elevation gis:load-dataset "C:/Users/12524/Desktop/tongjiaaoelevation14km/tongjiaao海拔14.asc"
  set slope gis:load-dataset "C:/Users/12524/Desktop/tongjiaaosaa14km/tongjiaao坡度14.asc"
  set aspect gis:load-dataset "C:/Users/12524/Desktop/tongjiaaosaa14km/tongjiaao坡向14.asc"
;  if(time = "6900BP")
;  [set sea gis:load-dataset "D:/古人类行为模拟/田螺山海拔坡向坡度图/田螺山海岸线/tianluoshan6900海岸线01.asc"
;    gis:apply-raster sea psea]
;  if(time = "6200BP")
;  [set sea gis:load-dataset "D:/古人类行为模拟/田螺山海拔坡向坡度图/田螺山海岸线/tianluoshan6900海岸线01.asc"
;    gis:apply-raster sea psea]
;  if(time = "5500BP")
;  [set sea gis:load-dataset "D:/古人类行为模拟/田螺山海拔坡向坡度图/田螺山海岸线/tianluoshan6900海岸线01.asc"
;    gis:apply-raster sea psea]
   ]

end

to init-gis
  gis:apply-raster elevation pelevation
  gis:apply-raster aspect paspect
  gis:apply-raster slope pslope


  if(time = "6900BP")
  [
  ;;设定最基本的植被分布和地貌情况
  ask patches with [pelevation >= 30 and pelevation <= 100 ]  [set pcolor random-normal 53 0.2 set pplant 0 set psoiltype 1]   ;;青冈和樟科

  ask patches with [pelevation >= 100 and pelevation <= 140]  [set pcolor random-normal 52 0.2 set pplant 0.5 set psoiltype 1] ;;青冈和樟科以及黄连木

  ask patches with [pelevation >= 140 and pelevation <= 180]  [set pcolor random-normal 52 0.2 set pplant 1 set psoiltype 1]   ;;黄连木和杨梅

  ask patches with [pelevation >= 180 and pelevation <= 200]  [set pcolor random-normal 52 0.2 set pplant 1.5 set psoiltype 1] ;;黄连木和漆树科

  ask patches with [pelevation >= 200 and pelevation <= 300]  [set pcolor  random-normal 52 0.2  set pplant 2 set psoiltype 1] ;;漆树科和碧桃(漆树科包含了南酸枣)

  ask patches with [pelevation >= 300 and pelevation <= 400]  [set pcolor random-normal 52 0.2  set pplant 3 set psoiltype 1]  ;;松和图柏以及漆树科

  ask patches with [pelevation >= 400]  [set pcolor random-normal 52 0.2  set pplant 3.5 set psoiltype 1]                      ;;松和图柏以及云杉等等

  ask patches with [pelevation >= 18 and pelevation <= 30]  [set pcolor random-normal 53 0.2  set pplant 4 set psoiltype 1]    ;;存在竹林：可以捡拾一些柴火

  ask patches with [pelevation >= 10 and pelevation <= 18]  [set pcolor random-normal 54 0.2  set pplant 5 set psoiltype 1]     ;;灌丛：可以捡拾一些柴火

  ;ask patches with [pelevation >= 4 and pelevation <= 10]  [set pcolor random-normal 59 0.2  set pplant 6 set psoiltype 2]      ;;湿地 ：含有菱角和鸡头果等水生食物以及各种鱼类

  ask patches with [pelevation <= 10 and pelevation > 1]  [set pcolor random-normal 59 0.2  set pplant 6 set psoiltype 2]      ;;湿地 ：含有菱角和鸡头果等水生食物以及各种鱼类
  let n count patches with [pelevation <= 10 and pelevation > 1 and psoiltype != 3] / 5
  ask min-n-of n patches  with [pelevation <= 10 and pelevation > 1 and psoiltype != 3]  [pelevation] [set psoiltype  3 set pcolor 95] ;;指的是淡水水域

  ;ask patches with [pelevation <= 4 ]  [set pcolor random-normal 59 0.2   set pplant 7 set psoiltype 3]                        ;;湖泊：各种鱼类,水面面积光
    ;海陆过渡带


   if(count patches with [psea = 0] > 10000)[
      ask patches with [psea = 0][ask neighbors4 [set psea  0]]
      ask patches with [psea = 0 and pelevation <= 50]  [ set pcolor blue  set psoiltype 4]                                        ;;海洋
    ]
   ask patches with [pelevation <= 1 ]  [set pcolor blue   set psoiltype 4]     ;;海洋


    ]

  if(time = "6200BP")
  [
  ;;设定最基本的植被分布和地貌情况
  ask patches with [pelevation >= 30 and pelevation <= 100 ]  [set pcolor random-normal 53 0.2 set pplant 0 set psoiltype 1]   ;;青冈和樟科

  ask patches with [pelevation >= 100 and pelevation <= 140]  [set pcolor random-normal 52 0.2 set pplant 0.5 set psoiltype 1] ;;青冈和樟科以及黄连木

  ask patches with [pelevation >= 140 and pelevation <= 180]  [set pcolor random-normal 52 0.2 set pplant 1 set psoiltype 1]   ;;黄连木和杨梅

  ask patches with [pelevation >= 180 and pelevation <= 200]  [set pcolor random-normal 52 0.2 set pplant 1.5 set psoiltype 1] ;;黄连木和漆树科

  ask patches with [pelevation >= 200 and pelevation <= 300]  [set pcolor  random-normal 52 0.2  set pplant 2 set psoiltype 1] ;;漆树科和碧桃(漆树科包含了南酸枣)

  ask patches with [pelevation >= 300 and pelevation <= 400]  [set pcolor random-normal 52 0.2  set pplant 3 set psoiltype 1]  ;;松和图柏以及漆树科

  ask patches with [pelevation >= 400]  [set pcolor random-normal 52 0.2  set pplant 3.5 set psoiltype 1]                      ;;松和图柏以及云杉等等

  ask patches with [pelevation >= 18 and pelevation <= 30]  [set pcolor random-normal 53 0.2  set pplant 4 set psoiltype 1]    ;;存在竹林：可以捡拾一些柴火

  ask patches with [pelevation >= 8 and pelevation <= 18]  [set pcolor random-normal 54 0.2  set pplant 5 set psoiltype 1]     ;;灌丛：可以捡拾一些柴火

  ;ask patches with [pelevation >= 4 and pelevation <= 10]  [set pcolor random-normal 59 0.2  set pplant 6 set psoiltype 2]      ;;湿地 ：含有菱角和鸡头果等水生食物以及各种鱼类

  ask patches with [pelevation <= 8 and pelevation > 1]  [set pcolor random-normal 59 0.2  set pplant 6 set psoiltype 2]      ;;湿地 ：含有菱角和鸡头果等水生食物以及各种鱼类
  let n count patches with [pelevation <= 8 and pelevation > 1 and psoiltype != 3] / 6
  ask min-n-of n patches  with [pelevation <= 8 and pelevation > 1 and psoiltype != 3]  [pelevation] [set psoiltype  3 set pcolor 95] ;;指的是淡水水域

  ;ask patches with [pelevation <= 4 ]  [set pcolor random-normal 59 0.2   set pplant 7 set psoiltype 3]                        ;;湖泊：各种鱼类,水面面积光
    ;海陆过渡带


   ask patches with [pelevation <= 1 ]  [set pcolor blue   set psoiltype 4]     ;;海洋


   if(count patches with [psea = 0] > 10000)[
      ask patches with [psea = 0][ask neighbors4 [set psea  0]]
      ask patches with [psea = 0 and pelevation <= 50]  [ set pcolor blue  set psoiltype 4]                                        ;;海洋
    ]



;  let temp 1
;  ;;湖泊
;  ask patches with [pelevation <= 6 ]  [
;      set sump count patches with [pelevation <= 6]
;      set ptemp temp
;      set temp temp + 1
;    ]
;    set temp 0
;    let num 0
;     ask patches with [ptemp > 0][
;       if(temp <= 100)
;      [ let temp01 random sump
;      if(ptemp = temp01 and psoiltype != 3)[set psoiltype  3 set temp temp + 1 set pnum num set num num + 1]]
;
;      ask patches with [psoiltype = 3 and pnum = 0 and count patches with[psoiltype = 3] < sump / 10000 * 20 * 10][ask neighbors4 with [pelevation <= 6][set pcolor random-normal 59 0.2   set pplant 7 set psoiltype 3 set pnum 0]]
;      ask patches with [psoiltype = 3 and pnum >= 1 and pnum <= 5 and count patches with[psoiltype = 3] < sump / 10000 * 20 * 30][ask neighbors4 with [pelevation <= 6][set pcolor random-normal 59 0.2   set pplant 7 set psoiltype 3 set pnum 1]]
;      ask patches with [psoiltype = 3 and pnum >= 6 and pnum <= 85 and count patches with[psoiltype = 3] < sump / 10000 * 20 * 65][ask neighbors4 with [pelevation <= 6][set pcolor random-normal 59 0.2   set pplant 7 set psoiltype 3 set pnum 6]]
;      ask patches with [psoiltype = 3 and pnum >= 86 and pnum <= 100 and count patches with[psoiltype = 3] < sump / 10000 * 20 * 5][ask neighbors4 with [pelevation <= 6][set pcolor random-normal 59 0.2   set pplant 7 set psoiltype 3 set pnum 86]]
;
;      ]




;   if(count patches with [psea = 0] <= 10000)[
;
;      ask patches with [psea = 0][ask neighbors4 [set psea  0]]
;      ask patches with [psea = 0 and pelevation <= 10]  [ set pcolor blue  set psoiltype 4]                                    ;;海洋
;    ]

  ]

  if(time = "5500BP")
  [
  ;;设定最基本的植被分布和地貌情况
  ask patches with [pelevation >= 30 and pelevation <= 100 ]  [set pcolor random-normal 53 0.2 set pplant 0 set psoiltype 1]   ;;青冈和樟科

  ask patches with [pelevation >= 100 and pelevation <= 140]  [set pcolor random-normal 52 0.2 set pplant 0.5 set psoiltype 1] ;;青冈和樟科以及黄连木

  ask patches with [pelevation >= 140 and pelevation <= 180]  [set pcolor random-normal 52 0.2 set pplant 1 set psoiltype 1]   ;;黄连木和杨梅

  ask patches with [pelevation >= 180 and pelevation <= 200]  [set pcolor random-normal 52 0.2 set pplant 1.5 set psoiltype 1] ;;黄连木和漆树科

  ask patches with [pelevation >= 200 and pelevation <= 300]  [set pcolor  random-normal 52 0.2  set pplant 2 set psoiltype 1] ;;漆树科和碧桃(漆树科包含了南酸枣)

  ask patches with [pelevation >= 300 and pelevation <= 400]  [set pcolor random-normal 52 0.2  set pplant 3 set psoiltype 1]  ;;松和图柏以及漆树科

  ask patches with [pelevation >= 400]  [set pcolor random-normal 52 0.2  set pplant 3.5 set psoiltype 1]                      ;;松和图柏以及云杉等等

  ask patches with [pelevation >= 18 and pelevation <= 30]  [set pcolor random-normal 53 0.2  set pplant 4 set psoiltype 1]    ;;存在竹林：可以捡拾一些柴火

  ask patches with [pelevation >= 6 and pelevation <= 18]  [set pcolor random-normal 54 0.2  set pplant 5 set psoiltype 1]     ;;灌丛：可以捡拾一些柴火

  ;ask patches with [pelevation >= 4 and pelevation <= 10]  [set pcolor random-normal 59 0.2  set pplant 6 set psoiltype 2]      ;;湿地 ：含有菱角和鸡头果等水生食物以及各种鱼类

  ask patches with [pelevation <= 6 and pelevation > 1]  [set pcolor random-normal 59 0.2  set pplant 6 set psoiltype 2]      ;;湿地 ：含有菱角和鸡头果等水生食物以及各种鱼类
  let n count patches with [pelevation <= 6 and pelevation > 1 and psoiltype != 3] / 6
  ask min-n-of n patches  with [pelevation <= 6 and pelevation > 1 and psoiltype != 3]  [pelevation] [set psoiltype  3 set pcolor 95] ;;指的是淡水水域

  ;ask patches with [pelevation <= 4 ]  [set pcolor random-normal 59 0.2   set pplant 7 set psoiltype 3]                        ;;湖泊：各种鱼类,水面面积光
    ;海陆过渡带


   ask patches with [pelevation <= 1 ]  [set pcolor blue   set psoiltype 4]     ;;海洋


   if(count patches with [psea = 0] > 10000)[
      ask patches with [psea = 0][ask neighbors4 [set psea  0]]
      ask patches with [psea = 0 and pelevation <= 50]  [ set pcolor blue  set psoiltype 4]                                        ;;海洋
    ]


  ]


  ask patches with [pslope > 15 and paspect >= 0]
  [set pdanger 2]
  ask patches with [pslope <= 15 ]
  [set pdanger 1]
  ask patches with [pdanger != 1 and pdanger != 2]
  [set pslope 1 + random 15
  set paspect 5
  set pdanger 3
  set pelevation random 50]



  set-initial-patches-vars

end

to  set-initial-patches-vars

    ;;移动成本设定和移动规则设定
  ask patches with [pxcor = xcoord and pycor = ycoord][
    ;;移动成本设定
    set ptravelcost 1

  ]

;  ask patches with [pxcor != -5 or pycor != -71][
;       ;;移动成本设定
;    set ptravelcost  1 + 14 * (ln ((pxcor - xcoord) * (pxcor - xcoord)  + (pycor - ycoord) * (pycor - ycoord)))
;  ]
  ask patches  [

    ;;初始访问变量设定
    set pfield? false
    set pgathered? false
    set p1gathered? false
    set pbrowsed? false
    set pfished? false
    set phunted? false
    set pfwcollected? false
    set ptimbercollected? false
    set ppaint? false
    set pgatheredt 0
    set p1gatheredt 0
    set pbrowsedt 0
    set pfishedt 0
    set phuntedt 0
    set pfwcollectedt 0
    set ptimbercollectedt 0
    set ppaintcollectedt 0

    set pgatheredtime 0
    set p1gatheredtime 0
    set pbrowsedtime 0
    set pfishedtime 0
    set phuntedtime 0
    set pfwcollectedtime 0
    set ptimbercollectedtime 0
    set ppainttime 0

  ]

    ;;设定树龄
    assign-forest-texture
end

to   assign-forest-texture
   ask patches with [psoiltype = 1]
   [set pstandage random (500 -  1) + 1 ]   ;;standage是树龄的意思
end


to setup-turtles
   set-Default-shape MHs "person"
   set-Default-shape settlements "house"
   if area  != "all-hemudu"
  [
    ;;;家庭数做出修改
  if time = "6900BP" [set nr_of_houses households  create-LU 1 * nr_of_houses [set size 3 setxy xcoord ycoord]]
  if time = "6200BP" [set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord ycoord]]
  if time = "5500BP" [set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord ycoord]]
   create-MHs nr_of_houses [set color white set size 5 setxy xcoord ycoord]
   create-settlements 1 [setxy xcoord ycoord  set size 2]
   set-initial-turtle-vars

  ]

  if area = "all-hemudu"
  [

    ;; 6900
    if time = "6900BP" and Location6900 = "1"[ set nr_of_houses households  create-LU 1 * nr_of_houses [set size 3 setxy xcoord01 ycoord01] create-MHs nr_of_houses [set color white set size 5 setxy xcoord01 ycoord01] create-settlements 1 [setxy xcoord01 ycoord01  set size 2]]
    if time = "6900BP" and Location6900 = "2"[ set nr_of_houses households  create-LU 1 * nr_of_houses [set size 3 setxy xcoord02 ycoord02] create-MHs nr_of_houses [set color white set size 5 setxy xcoord02 ycoord02] create-settlements 1 [setxy xcoord02 ycoord02  set size 2]]
    if time = "6900BP" and Location6900 = "3"[ set nr_of_houses households  create-LU 1 * nr_of_houses [set size 3 setxy xcoord03 ycoord03] create-MHs nr_of_houses [set color white set size 5 setxy xcoord03 ycoord03] create-settlements 1 [setxy xcoord03 ycoord03  set size 2]]
    if time = "6900BP" and Location6900 = "4"[ set nr_of_houses households  create-LU 1 * nr_of_houses [set size 3 setxy xcoord04 ycoord04] create-MHs nr_of_houses [set color white set size 5 setxy xcoord04 ycoord04] create-settlements 1 [setxy xcoord04 ycoord04  set size 2]]
    if time = "6900BP" and Location6900 = "5"[ set nr_of_houses households  create-LU 1 * nr_of_houses [set size 3 setxy xcoord05 ycoord05] create-MHs nr_of_houses [set color white set size 5 setxy xcoord05 ycoord05] create-settlements 1 [setxy xcoord05 ycoord05  set size 2]]
    if time = "6900BP" and Location6900 = "6"[ set nr_of_houses households  create-LU 1 * nr_of_houses [set size 3 setxy xcoord06 ycoord06] create-MHs nr_of_houses [set color white set size 5 setxy xcoord06 ycoord06] create-settlements 1 [setxy xcoord06 ycoord06  set size 2]]


    ;;6200
    if time = "6200BP" and Location6200 = "1"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord001 ycoord001] create-MHs nr_of_houses [set color white set size 5 setxy xcoord001 ycoord001] create-settlements 1 [setxy xcoord001 ycoord001  set size 2]]
    if time = "6200BP" and Location6200 = "2"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord002 ycoord002] create-MHs nr_of_houses [set color white set size 5 setxy xcoord002 ycoord002] create-settlements 1 [setxy xcoord002 ycoord002  set size 2]]
    if time = "6200BP" and Location6200 = "3"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord003 ycoord003] create-MHs nr_of_houses [set color white set size 5 setxy xcoord003 ycoord003] create-settlements 1 [setxy xcoord003 ycoord003  set size 2]]
    if time = "6200BP" and Location6200 = "4"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord004 ycoord004] create-MHs nr_of_houses [set color white set size 5 setxy xcoord004 ycoord004] create-settlements 1 [setxy xcoord004 ycoord004  set size 2]]
    if time = "6200BP" and Location6200 = "5"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord005 ycoord005] create-MHs nr_of_houses [set color white set size 5 setxy xcoord005 ycoord005] create-settlements 1 [setxy xcoord005 ycoord005  set size 2]]
    if time = "6200BP" and Location6200 = "6"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord006 ycoord006] create-MHs nr_of_houses [set color white set size 5 setxy xcoord006 ycoord006] create-settlements 1 [setxy xcoord006 ycoord006  set size 2]]
    if time = "6200BP" and Location6200 = "7"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord007 ycoord007] create-MHs nr_of_houses [set color white set size 5 setxy xcoord007 ycoord007] create-settlements 1 [setxy xcoord007 ycoord007  set size 2]]
    if time = "6200BP" and Location6200 = "8"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord008 ycoord008] create-MHs nr_of_houses [set color white set size 5 setxy xcoord008 ycoord008] create-settlements 1 [setxy xcoord008 ycoord008  set size 2]]
    if time = "6200BP" and Location6200 = "9"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord009 ycoord009] create-MHs nr_of_houses [set color white set size 5 setxy xcoord009 ycoord009] create-settlements 1 [setxy xcoord009 ycoord009  set size 2]]
    if time = "6200BP" and Location6200 = "10"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord010 ycoord010] create-MHs nr_of_houses [set color white set size 5 setxy xcoord010 ycoord010] create-settlements 1 [setxy xcoord010 ycoord010  set size 2]]
    if time = "6200BP" and Location6200 = "11"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord011 ycoord011] create-MHs nr_of_houses [set color white set size 5 setxy xcoord011 ycoord011] create-settlements 1 [setxy xcoord011 ycoord011  set size 2]]
    if time = "6200BP" and Location6200 = "12"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord012 ycoord012] create-MHs nr_of_houses [set color white set size 5 setxy xcoord012 ycoord012] create-settlements 1 [setxy xcoord012 ycoord012  set size 2]]
    if time = "6200BP" and Location6200 = "13"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord013 ycoord013] create-MHs nr_of_houses [set color white set size 5 setxy xcoord013 ycoord013] create-settlements 1 [setxy xcoord013 ycoord013  set size 2]]
    if time = "6200BP" and Location6200 = "14"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord014 ycoord014] create-MHs nr_of_houses [set color white set size 5 setxy xcoord014 ycoord014] create-settlements 1 [setxy xcoord014 ycoord014  set size 2]]
    if time = "6200BP" and Location6200 = "15"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord015 ycoord015] create-MHs nr_of_houses [set color white set size 5 setxy xcoord015 ycoord015] create-settlements 1 [setxy xcoord015 ycoord015  set size 2]]
    if time = "6200BP" and Location6200 = "16"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord016 ycoord016] create-MHs nr_of_houses [set color white set size 5 setxy xcoord016 ycoord016] create-settlements 1 [setxy xcoord016 ycoord016  set size 2]]
    if time = "6200BP" and Location6200 = "17"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord017 ycoord017] create-MHs nr_of_houses [set color white set size 5 setxy xcoord017 ycoord017] create-settlements 1 [setxy xcoord017 ycoord017  set size 2]]
    if time = "6200BP" and Location6200 = "18"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord018 ycoord018] create-MHs nr_of_houses [set color white set size 5 setxy xcoord018 ycoord018] create-settlements 1 [setxy xcoord018 ycoord018  set size 2]]


    ;;5500
    if time = "5500BP" and Location5500 = "1"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-01 ycoord-01] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-01 ycoord-01] create-settlements 1 [setxy xcoord-01 ycoord-01  set size 2]]
    if time = "5500BP" and Location5500 = "2"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-02 ycoord-02] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-02 ycoord-02] create-settlements 1 [setxy xcoord-02 ycoord-02  set size 2]]
    if time = "5500BP" and Location5500 = "3"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-03 ycoord-03] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-03 ycoord-03] create-settlements 1 [setxy xcoord-03 ycoord-03  set size 2]]
    if time = "5500BP" and Location5500 = "4"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-04 ycoord-04] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-04 ycoord-04] create-settlements 1 [setxy xcoord-04 ycoord-04  set size 2]]
    if time = "5500BP" and Location5500 = "5"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-05 ycoord-05] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-05 ycoord-05] create-settlements 1 [setxy xcoord-05 ycoord-05  set size 2]]
    if time = "5500BP" and Location5500 = "6"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-06 ycoord-06] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-06 ycoord-06] create-settlements 1 [setxy xcoord-06 ycoord-06  set size 2]]
    if time = "5500BP" and Location5500 = "7"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-07 ycoord-07] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-07 ycoord-07] create-settlements 1 [setxy xcoord-07 ycoord-07  set size 2]]
    if time = "5500BP" and Location5500 = "8"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-08 ycoord-08] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-08 ycoord-08] create-settlements 1 [setxy xcoord-08 ycoord-08  set size 2]]
    if time = "5500BP" and Location5500 = "9"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-09 ycoord-09] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-09 ycoord-09] create-settlements 1 [setxy xcoord-09 ycoord-09  set size 2]]
    if time = "5500BP" and Location5500 = "10"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-10 ycoord-10] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-10 ycoord-10] create-settlements 1 [setxy xcoord-10 ycoord-10  set size 2]]
    if time = "5500BP" and Location5500 = "11"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-11 ycoord-11] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-11 ycoord-11] create-settlements 1 [setxy xcoord-11 ycoord-11  set size 2]]
    if time = "5500BP" and Location5500 = "12"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-12 ycoord-12] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-12 ycoord-12] create-settlements 1 [setxy xcoord-12 ycoord-12  set size 2]]
    if time = "5500BP" and Location5500 = "13"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-13 ycoord-13] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-13 ycoord-13] create-settlements 1 [setxy xcoord-13 ycoord-13  set size 2]]
    if time = "5500BP" and Location5500 = "14"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-14 ycoord-14] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-14 ycoord-14] create-settlements 1 [setxy xcoord-14 ycoord-14  set size 2]]
    if time = "5500BP" and Location5500 = "15"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-15 ycoord-15] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-15 ycoord-15] create-settlements 1 [setxy xcoord-15 ycoord-15  set size 2]]
    if time = "5500BP" and Location5500 = "16"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-16 ycoord-16] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-16 ycoord-16] create-settlements 1 [setxy xcoord-16 ycoord-16  set size 2]]
    if time = "5500BP" and Location5500 = "17"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-17 ycoord-17] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-17 ycoord-17] create-settlements 1 [setxy xcoord-17 ycoord-17  set size 2]]
    if time = "5500BP" and Location5500 = "18"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-18 ycoord-18] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-18 ycoord-18] create-settlements 1 [setxy xcoord-18 ycoord-18  set size 2]]
    if time = "5500BP" and Location5500 = "19"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-19 ycoord-19] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-19 ycoord-19] create-settlements 1 [setxy xcoord-19 ycoord-19  set size 2]]
    if time = "5500BP" and Location5500 = "20"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-20 ycoord-20] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-20 ycoord-20] create-settlements 1 [setxy xcoord-20 ycoord-20  set size 2]]
    if time = "5500BP" and Location5500 = "21"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-21 ycoord-21] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-21 ycoord-21] create-settlements 1 [setxy xcoord-21 ycoord-21  set size 2]]
    if time = "5500BP" and Location5500 = "22"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-22 ycoord-22] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-22 ycoord-22] create-settlements 1 [setxy xcoord-22 ycoord-22  set size 2]]
    if time = "5500BP" and Location5500 = "23"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-23 ycoord-23] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-23 ycoord-23] create-settlements 1 [setxy xcoord-23 ycoord-23  set size 2]]
    if time = "5500BP" and Location5500 = "24"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-24 ycoord-24] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-24 ycoord-24] create-settlements 1 [setxy xcoord-24 ycoord-24  set size 2]]
    if time = "5500BP" and Location5500 = "25"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-25 ycoord-25] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-25 ycoord-25] create-settlements 1 [setxy xcoord-25 ycoord-25  set size 2]]
    if time = "5500BP" and Location5500 = "26"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-26 ycoord-26] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-26 ycoord-26] create-settlements 1 [setxy xcoord-26 ycoord-26  set size 2]]
    if time = "5500BP" and Location5500 = "27"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-27 ycoord-27] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-27 ycoord-27] create-settlements 1 [setxy xcoord-27 ycoord-27  set size 2]]
    if time = "5500BP" and Location5500 = "28"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-28 ycoord-28] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-28 ycoord-28] create-settlements 1 [setxy xcoord-28 ycoord-28  set size 2]]
    if time = "5500BP" and Location5500 = "29"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-29 ycoord-29] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-29 ycoord-29] create-settlements 1 [setxy xcoord-29 ycoord-29  set size 2]]
    if time = "5500BP" and Location5500 = "30"[ set nr_of_houses households  create-LU 2 * nr_of_houses [set size 3 setxy xcoord-30 ycoord-30] create-MHs nr_of_houses [set color white set size 5 setxy xcoord-30 ycoord-30] create-settlements 1 [setxy xcoord-30 ycoord-30  set size 2]]
  ]



  set-initial-turtle-vars
end

to set-initial-turtle-vars

  ask LU [set herdsize  nr_of_houses]
  ask one-of MHs [set MHshow? true]
    if(time = "6900BP")
  [ask MHs [ set all-energy 4380000 set MHfieldsize 0.2 ]];;一个方格 10000  ，一个和家庭 2000m2面积水稻田
    if(time = "6200BP")
    [ask MHs [ set all-energy 4380000 set MHfieldsize  0.25]];;一个方格 10000  ，一个和家庭 2500m2面积水稻田
    if(time = "5500BP")
    [ask MHs [ set all-energy 4380000 set MHfieldsize 0.3 ]];;一个方格 10000  ，一个和家庭 3000m2面积水稻田

end

;;定义资源

to Define-resources



;
;     ask patches[
;    if time = "6200BP" or time = "5500BP"[
;
;     if(pplant = 0)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.15 set p_timberstock 0.1 set p_fwstock 0.1 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00012  * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.15 set p_timberstock  0.25 set  p_fwstock 0.15 set  p_acornstock 0.25 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.0001 * 50 ]if(pslope >= 15) [set  p_game 0.0002 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.1 set p_timberstock 2.5 set  p_fwstock 0.3 set  p_acornstock 0.75 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.00024 * 50]if(pslope >= 15) [set  p_game 0.00015 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.05 set p_timberstock 0.1 set  p_fwstock 0.5 set  p_acornstock 0.75 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.00036 * 50]if(pslope >= 15) [set  p_game 0.0002 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.05 set p_timberstock 0.4 set  p_fwstock 0.75 set  p_acornstock 0.5 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00024 * 50]if(pslope >= 15) [set  p_game 0.0002 * 50]]
;    ]
;    if(pplant = 0.5)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.004 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00012 * 50]if(pslope >= 15) [set  p_game 0.0001 * 50]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.001 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.003 * 50 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.00024  * 50]if(pslope >= 15) [set  p_game 0.0001 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.04 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00025 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00024 * 50]if(pslope >= 15) [set  p_game 0.00015 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.001 * 50 set  p_fwstock 0.008 * 50 set  p_acornstock 0.015 * 50 set p_fruitstock 0.0003 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00036 * 50]if(pslope >= 15) [set  p_game 0.0002 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.008 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00015 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00024 * 50]if(pslope >= 15) [set  p_game 0.0002 * 50]]
;    ]
;     if(pplant = 1)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.005 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 set p_paint 0 if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.001 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.003 * 50 set p_fruitstock 0 set p_fish 0 set p_paint 0.2 * 50 if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.03 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00025 * 50  set p_fish 0 set p_paint 0.3 * 50 if(pslope <= 15) [set  p_game 0.00024 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.001 * 50 set  p_fwstock 0.008 * 50 set  p_acornstock 0.015 * 50 set p_fruitstock 0.0003 * 50 set p_fish 0 set p_paint 0.4 * 50 if(pslope <= 15) [set  p_game 0.00036 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00015 * 50 set p_fish 0 set p_paint 0.1 * 50 if(pslope <= 15) [set  p_game 0.00018 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;    ]
;    if(pplant = 1.5) ;;漆树
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_paint 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00012 ]if(pslope >= 15) [set  p_game 0.00012]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.003 * 50 set p_fruitstock 0 set p_paint 0.2 * 50 set p_fish 0    if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.03 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00025 * 50 set p_paint 0.3 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00024 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.005 * 50 set  p_fwstock 0.008 * 50 set  p_acornstock 0.015 * 50 set p_fruitstock 0.0003 * 50 set p_paint 0.4 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00036 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00015 * 50 set p_paint 0.1 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00018 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;    ]
;    if(pplant = 2)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_paint 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.002 * 50 set p_fruitstock 0 set p_paint 0.2 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.03 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.007 * 50 set p_fruitstock 0.00025 * 50 set p_paint 0.3 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00024 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.01 * 50 set  p_fwstock 0.008 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.0003 * 50 set p_paint 0.4 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00036 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.007 * 50 set p_fruitstock 0.00015 * 50 set p_paint 0.1 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00018 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;    ]
;    if(pplant = 3)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_paint 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.0015 * 50 set p_fruitstock 0 set p_paint 0.2 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.03 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0.00025 * 50 set p_paint 0.3 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00024 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.02 * 50 set  p_fwstock 0.008 * 50  set  p_acornstock 0.005 * 50 set p_fruitstock 0.0003 * 50 set p_paint 0.4 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00036 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0.00015 * 50 set p_paint 0.1 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00018 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;    ]
;    if(pplant = 3.5)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.0015 * 50 set p_fruitstock 0 set p_fish 0    if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.02 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0.00025 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00024 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.01 * 50 set  p_fwstock 0.004 * 50 set  p_acornstock 0.005 * 50 set p_fruitstock 0.0003 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00036 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.01 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0.00015 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00018 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;    ]
;    if(pplant = 4)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.0035 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.0015 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0  set  p_game 0.00012 * 50]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.0035 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.0025 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0 set p_fish 0   set  p_game 0.00018 * 50]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.0025 * 50 set p_timberstock 0.01 * 50 set  p_fwstock 0.005 * 50 set  p_acornstock 0.005 * 50 set p_fruitstock 0 set p_fish 0   set  p_game 0.00024 * 50]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.0015 * 50 set p_timberstock 0.00 * 50 set  p_fwstock 0.01 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0 set p_fish 0   set  p_game 0.00036 * 50 ]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.0015 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.005 * 50 set p_fruitstock 0 set p_fish 0  set  p_game 0.00018 * 50]
;   ]
;    if(pplant = 5)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.004 * 50 set p_timberstock 0.00 set p_fwstock 0.0015 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0  set  p_game 0.00012 * 50]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.004 * 50 set p_timberstock  0.00 set  p_fwstock 0.0025 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0   set  p_game 0.00018 * 50]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.003 * 50 set p_timberstock 0.00 set  p_fwstock 0.005 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0   set  p_game 0.00024 * 50 ]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.002 * 50 set p_timberstock 0.00 set  p_fwstock 0.01 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0   set  p_game 0.00036 * 50 ]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.002 * 50 set p_timberstock 0.00 set  p_fwstock 0.015 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0  set  p_game 0.00018 * 50 ]
;    ]
;    if(psoiltype = 2);;浅水湿地
;    [
;       set p_LUfodder 0.003 set p_timberstock 0 set p_fwstock 0 set  p_acornstock 0 set p_fruitstock random 10 / 1000   set p_fish 0  set p_game 0.00012 * 50
;
;    ]
;    if(psoiltype = 3);;湿地(可能的湖泊河流)
;    [
;      set p_LUfodder 0 set p_timberstock 0 set p_fwstock 0.00 set  p_acornstock 0 set p_fruitstock 0 set p_fish  random-normal 4 1 / 100
;    ]
;    if(psoiltype = 4) ;;海洋
;    [
;       set p_fish  random-normal 5 2 / 10000 * 50
;    ]
;
;
;
;        if(paspect >= 90 and paspect <= 180 )
;    [
;      set p_LUfodder p_LUfodder * 1.025    set p_timberstock p_timberstock * 1.025   set p_acornstock p_acornstock * 1.025     set p_fruitstock p_fruitstock * 1.025   ;;坡向对于森林的影响
;    ]
;
;
;
;
;
;    if(psoiltype = 1 )[
;      if(pslope <= 15  and p_game > 0 and p_game <= 0.0002 * 50)[set pdanger 0.5 ]
;      if(pslope <= 15  and p_game > 0.0002 * 50 and p_game <= 0.0003 * 50)[set pdanger 0.75]
;      if(pslope <= 15  and p_game > 0.0003 * 50 and p_game <= 0.0004 * 50)[set pdanger 1]
;      if(pslope <= 15  and p_game > 0.0004 * 50 and p_game <= 0.0006 * 50)[set pdanger 1.25]
;      if(pslope <= 15  and p_game > 0.0006 * 50)[set pdanger 1.5]
;
;
;      if(pslope <= 35 and pslope > 15 and p_game >= 0 and p_game <= 0.0002 * 50)[set pdanger 1]
;      if(pslope <= 35 and pslope > 15  and p_game > 0.0002 * 50 and p_game <= 0.0003 * 50)[set pdanger 1.5]
;      if(pslope <= 35 and pslope > 15  and p_game > 0.0003 * 50 and p_game <= 0.0004 * 50)[set pdanger 2]
;      if(pslope <= 35 and pslope > 15  and p_game > 0.0004 * 50 and p_game <= 0.0005 * 50)[set pdanger 2.5]
;      if(pslope <= 35 and pslope > 15  and p_game > 0.0005 * 50)[set pdanger 3]
;
;      if(pslope > 35  and  p_game >= 0 and p_game <= 0.0002 * 50)[set pdanger 2]
;      if(pslope > 35  and  p_game >= 0.0002 * 50 and p_game <= 0.0003 * 50)[set pdanger 3]
;      if(pslope > 35  and  p_game >= 0.0003 * 50 and p_game <= 0.0004 * 50)[set pdanger 4]
;      if(pslope < 35  and  p_game >= 0.0004 * 50 and p_game <= 0.0006 * 50)[set pdanger 5]
;      if(pslope > 35  and  p_game >= 0.0006 * 50)[set pdanger 6]
;
;
;
;
;    ]
;    if(psoiltype = 2)[
;       set pdanger 0.5
;    ]
;    if(psoiltype = 3)[
;      if(pelevation <= 0)[
;        set pdanger 1
;      ]
;      if(pelevation >= 0 and pelevation <= 1)[
;        set pdanger 3
;      ]
;      if(pelevation  < 1)[
;        set pdanger 5
;      ]
;    ]
;    if(psoiltype = 4)[
;       set pdanger 3
;      ]
;
;    if(pdanger != 0.5 and pdanger != 0.75 and pdanger != 1 and pdanger != 1.25 and pdanger != 1.5 and pdanger != 2 and pdanger != 2.5 and pdanger != 3)[
;      set pdanger 1.5 + random 10 / 10  ;;由于这个地方是水库没有slope和aspect的数据，但是由于都是河谷地区，危险性还是比较高的
;      set pslope 1 + random 14
;      set paspect 1 + random 90
;      set pelevation random 10
;    ]
;
;  ]
;  ]
;
;
;
;
;






  ask patches [

    if time = "6900BP" or time =  "6200BP" or time = "5500BP"[

     ;;森林

       if(pplant = 0)
    [
      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.15 set p_timberstock 0.1 set p_fwstock 0.1 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.15 set p_timberstock  0.25 set  p_fwstock 0.15 set  p_acornstock 0.25 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.00015 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.1 set p_timberstock 2.5 set  p_fwstock 0.3 set  p_acornstock 0.75 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.0002 * 50]if(pslope >= 15) [set  p_game 0.0001 * 50]]
      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.05 set p_timberstock 0.1 set  p_fwstock 0.5 set  p_acornstock 0.75 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.0003 * 50]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.05 set p_timberstock 0.4 set  p_fwstock 0.75 set  p_acornstock 0.5 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 50]if(pslope >= 15) [set  p_game 0.0001 * 50]]
    ]
     if(pplant = 0.5)
    [
      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.004 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.0001 * 50]if(pslope >= 15) [set  p_game 0.00005 * 50]]
      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.001 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.003 * 50 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.0001  * 50]if(pslope >= 15) [set  p_game 0.00005 * 50]]
      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.04 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00025 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.0002 * 50]if(pslope >= 15) [set  p_game 0.0001 * 50]]
      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.001 * 50 set  p_fwstock 0.008 * 50 set  p_acornstock 0.015 * 50 set p_fruitstock 0.0003 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.0003 * 50]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.008 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00015 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 50]if(pslope >= 15) [set  p_game 0.0001 * 50]]
    ]
     if(pplant = 1)
    [
      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.005 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 set p_paint 0 if(pslope <= 15) [set  p_game 0.0001 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.001 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.003 * 50 set p_fruitstock 0 set p_fish 0 set p_paint 0.2 * 50 if(pslope <= 15) [set  p_game 0.0001 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.03 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00025 * 50  set p_fish 0 set p_paint 0.3 * 50 if(pslope <= 15) [set  p_game 0.0002 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.001 * 50 set  p_fwstock 0.008 * 50 set  p_acornstock 0.015 * 50 set p_fruitstock 0.0003 * 50 set p_fish 0 set p_paint 0.4 * 50 if(pslope <= 15) [set  p_game 0.0003 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00015 * 50 set p_fish 0 set p_paint 0.1 * 50 if(pslope <= 15) [set  p_game 0.00015 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
    ]
    if(pplant = 1.5) ;;漆树
    [
      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_paint 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.0001 ]if(pslope >= 15) [set  p_game 0.0001]]
      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.003 * 50 set p_fruitstock 0 set p_paint 0.2 * 50 set p_fish 0    if(pslope <= 15) [set  p_game 0.0001 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.03 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00025 * 50 set p_paint 0.3 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.0002 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.005 * 50 set  p_fwstock 0.008 * 50 set  p_acornstock 0.015 * 50 set p_fruitstock 0.0003 * 50 set p_paint 0.4 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.0003 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00015 * 50 set p_paint 0.1 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
    ]
    if(pplant = 2)
    [
      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_paint 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.0001 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.002 * 50 set p_fruitstock 0 set p_paint 0.2 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.0001 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.03 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.007 * 50 set p_fruitstock 0.00025 * 50 set p_paint 0.3 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.0002 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.01 * 50 set  p_fwstock 0.008 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.0003 * 50 set p_paint 0.4 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.0003 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.007 * 50 set p_fruitstock 0.00015 * 50 set p_paint 0.1 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
    ]
    if(pplant = 3)
    [
      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_paint 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.0001 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.0015 * 50 set p_fruitstock 0 set p_paint 0.2 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.0001 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.03 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0.00025 * 50 set p_paint 0.3 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.0002 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.02 * 50 set  p_fwstock 0.008 * 50  set  p_acornstock 0.005 * 50 set p_fruitstock 0.0003 * 50 set p_paint 0.4 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.0003 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0.00015 * 50 set p_paint 0.1 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
    ]
    if(pplant = 3.5)
    [
      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.0001 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.0015 * 50 set p_fruitstock 0 set p_fish 0    if(pslope <= 15) [set  p_game 0.0001 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.02 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0.00025 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.0002 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.01 * 50 set  p_fwstock 0.004 * 50 set  p_acornstock 0.005 * 50 set p_fruitstock 0.0003 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.0003 * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.01 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0.00015 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
    ]
    if(pplant = 4)
    [
      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.0035 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.0015 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0  set  p_game 0.0001 * 50]
      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.0035 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.0025 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0 set p_fish 0   set  p_game 0.00015 * 50]
      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.0025 * 50 set p_timberstock 0.01 * 50 set  p_fwstock 0.005 * 50 set  p_acornstock 0.005 * 50 set p_fruitstock 0 set p_fish 0   set  p_game 0.0002 * 50]
      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.0015 * 50 set p_timberstock 0.00 * 50 set  p_fwstock 0.01 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0 set p_fish 0   set  p_game 0.0003 * 50 ]
      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.0015 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.005 * 50 set p_fruitstock 0 set p_fish 0  set  p_game 0.00015 * 50]
    ]
    if(pplant = 5)
    [
      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.004 * 50 set p_timberstock 0.00 set p_fwstock 0.0015 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0  set  p_game 0.0001 * 50]
      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.004 * 50 set p_timberstock  0.00 set  p_fwstock 0.0025 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0   set  p_game 0.00015 * 50]
      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.003 * 50 set p_timberstock 0.00 set  p_fwstock 0.005 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0   set  p_game 0.0002 * 50 ]
      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.002 * 50 set p_timberstock 0.00 set  p_fwstock 0.01 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0   set  p_game 0.0003 * 50 ]
      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.002 * 50 set p_timberstock 0.00 set  p_fwstock 0.015 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0  set  p_game 0.00015 * 50 ]
    ]
    if(psoiltype = 2);;浅水湿地
    [
       set p_LUfodder 0.003 set p_timberstock 0 set p_fwstock 0 set  p_acornstock 0 set p_fruitstock random 10 / 1000   set p_fish 0  set p_game 0.0001 * 50

    ]
    if(psoiltype = 3);;湿地(可能的湖泊河流)
    [
      set p_LUfodder 0 set p_timberstock 0 set p_fwstock 0.00 set  p_acornstock 0 set p_fruitstock 0 set p_fish  random-normal 3 1 / 100
    ]
    if(psoiltype = 4) ;;海洋
    [
       set p_fish  random-normal 5 2 / 10000 * 50
    ]
    ]
;    if(pplant = 0)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.15 set p_timberstock 0.1 set p_fwstock 0.1 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 200 ]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.15 set p_timberstock  0.25 set  p_fwstock 0.15 set  p_acornstock 0.25 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.00015 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.1 set p_timberstock 2.5 set  p_fwstock 0.3 set  p_acornstock 0.75 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.0002 * 200]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.05 set p_timberstock 0.1 set  p_fwstock 0.5 set  p_acornstock 0.75 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.0003 * 200]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.05 set p_timberstock 0.4 set  p_fwstock 0.75 set  p_acornstock 0.5 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 200]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;    ]
;     if(pplant = 0.5)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 200 set p_timberstock 0.004 * 200 set p_fwstock 0.001 * 200 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.0001 * 200]if(pslope >= 15) [set  p_game 0.00005 * 200]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 200 set p_timberstock  0.001 * 200 set  p_fwstock 0.002 * 200 set  p_acornstock 0.003 * 200 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.0001  * 200]if(pslope >= 15) [set  p_game 0.00005 * 200]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 200 set p_timberstock 0.04 * 200 set  p_fwstock 0.003 * 200 set  p_acornstock 0.01 * 200 set p_fruitstock 0.00025 * 200 set p_fish 0  if(pslope <= 15) [set  p_game 0.0002 * 200]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 200 set p_timberstock 0.001 * 200 set  p_fwstock 0.008 * 200 set  p_acornstock 0.015 * 200 set p_fruitstock 0.0003 * 200 set p_fish 0  if(pslope <= 15) [set  p_game 0.0003 * 200]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 200 set p_timberstock 0.008 * 200 set  p_fwstock 0.015 * 200 set  p_acornstock 0.01 * 200 set p_fruitstock 0.00015 * 200 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 200]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;    ]
;     if(pplant = 1)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 200 set p_timberstock 0.005 * 200 set p_fwstock 0.001 * 200 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 set p_paint 0 if(pslope <= 15) [set  p_game 0.0001 * 200 ]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 200 set p_timberstock  0.001 * 200 set  p_fwstock 0.002 * 200 set  p_acornstock 0.003 * 200 set p_fruitstock 0 set p_fish 0 set p_paint 0.2 * 200 if(pslope <= 15) [set  p_game 0.0001 * 200 ]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 200 set p_timberstock 0.03 * 200 set  p_fwstock 0.003 * 200 set  p_acornstock 0.01 * 200 set p_fruitstock 0.00025 * 200  set p_fish 0 set p_paint 0.3 * 200 if(pslope <= 15) [set  p_game 0.0002 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 200 set p_timberstock 0.001 * 200 set  p_fwstock 0.008 * 200 set  p_acornstock 0.015 * 200 set p_fruitstock 0.0003 * 200 set p_fish 0 set p_paint 0.4 * 200 if(pslope <= 15) [set  p_game 0.0003 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 200 set p_timberstock 0.002 * 200 set  p_fwstock 0.015 * 200 set  p_acornstock 0.01 * 200 set p_fruitstock 0.00015 * 200 set p_fish 0 set p_paint 0.1 * 200 if(pslope <= 15) [set  p_game 0.00015 * 200 ]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;    ]
;    if(pplant = 1.5) ;;漆树
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 200 set p_timberstock 0.002 * 200 set p_fwstock 0.001 * 200 set  p_acornstock 0 set p_fruitstock 0 set p_paint 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.0001 ]if(pslope >= 15) [set  p_game 0.0001]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 200 set p_timberstock  0.005 * 200 set  p_fwstock 0.002 * 200 set  p_acornstock 0.003 * 200 set p_fruitstock 0 set p_paint 0.2 * 200 set p_fish 0    if(pslope <= 15) [set  p_game 0.0001 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 200 set p_timberstock 0.03 * 200 set  p_fwstock 0.003 * 200 set  p_acornstock 0.01 * 200 set p_fruitstock 0.00025 * 200 set p_paint 0.3 * 200 set p_fish 0  if(pslope <= 15) [set  p_game 0.0002 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 200 set p_timberstock 0.005 * 200 set  p_fwstock 0.008 * 200 set  p_acornstock 0.015 * 200 set p_fruitstock 0.0003 * 200 set p_paint 0.4 * 200 set p_fish 0  if(pslope <= 15) [set  p_game 0.0003 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 200 set p_timberstock 0.002 * 200 set  p_fwstock 0.015 * 200 set  p_acornstock 0.01 * 200 set p_fruitstock 0.00015 * 200 set p_paint 0.1 * 200 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 200 ]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;    ]
;    if(pplant = 2)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 200 set p_timberstock 0.002 * 200 set p_fwstock 0.001 * 200 set  p_acornstock 0 set p_fruitstock 0 set p_paint 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.0001 * 200 ]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 200 set p_timberstock  0.005 * 200 set  p_fwstock 0.002 * 200 set  p_acornstock 0.002 * 200 set p_fruitstock 0 set p_paint 0.2 * 200 set p_fish 0 if(pslope <= 15) [set  p_game 0.0001 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 200 set p_timberstock 0.03 * 200 set  p_fwstock 0.003 * 200 set  p_acornstock 0.007 * 200 set p_fruitstock 0.00025 * 200 set p_paint 0.3 * 200 set p_fish 0 if(pslope <= 15) [set  p_game 0.0002 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 200 set p_timberstock 0.01 * 200 set  p_fwstock 0.008 * 200 set  p_acornstock 0.01 * 200 set p_fruitstock 0.0003 * 200 set p_paint 0.4 * 200 set p_fish 0  if(pslope <= 15) [set  p_game 0.0003 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 200 set p_timberstock 0.002 * 200 set  p_fwstock 0.015 * 200 set  p_acornstock 0.007 * 200 set p_fruitstock 0.00015 * 200 set p_paint 0.1 * 200 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 200 ]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;    ]
;    if(pplant = 3)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 200 set p_timberstock 0.002 * 200 set p_fwstock 0.001 * 200 set  p_acornstock 0 set p_fruitstock 0 set p_paint 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.0001 * 200 ]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 200 set p_timberstock  0.005 * 200 set  p_fwstock 0.002 * 200 set  p_acornstock 0.0015 * 200 set p_fruitstock 0 set p_paint 0.2 * 200 set p_fish 0  if(pslope <= 15) [set  p_game 0.0001 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 200 set p_timberstock 0.03 * 200 set  p_fwstock 0.003 * 200 set  p_acornstock 0.0025 * 200 set p_fruitstock 0.00025 * 200 set p_paint 0.3 * 200 set p_fish 0  if(pslope <= 15) [set  p_game 0.0002 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 200 set p_timberstock 0.02 * 200 set  p_fwstock 0.008 * 200  set  p_acornstock 0.005 * 200 set p_fruitstock 0.0003 * 200 set p_paint 0.4 * 200 set p_fish 0  if(pslope <= 15) [set  p_game 0.0003 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 200 set p_timberstock 0.002 * 200 set  p_fwstock 0.015 * 200 set  p_acornstock 0.0025 * 200 set p_fruitstock 0.00015 * 200 set p_paint 0.1 * 200 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 200 ]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;    ]
;    if(pplant = 3.5)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 200 set p_timberstock 0.002 * 200 set p_fwstock 0.001 * 200 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.0001 * 200 ]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 200 set p_timberstock  0.005 * 200 set  p_fwstock 0.002 * 200 set  p_acornstock 0.0015 * 200 set p_fruitstock 0 set p_fish 0    if(pslope <= 15) [set  p_game 0.0001 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 200 set p_timberstock 0.02 * 200 set  p_fwstock 0.003 * 200 set  p_acornstock 0.0025 * 200 set p_fruitstock 0.00025 * 200 set p_fish 0  if(pslope <= 15) [set  p_game 0.0002 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 200 set p_timberstock 0.01 * 200 set  p_fwstock 0.004 * 200 set  p_acornstock 0.005 * 200 set p_fruitstock 0.0003 * 200 set p_fish 0  if(pslope <= 15) [set  p_game 0.0003 * 200 ]if(pslope >= 15) [set  p_game 0.00015 * 200]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 200 set p_timberstock 0.002 * 200 set  p_fwstock 0.01 * 200 set  p_acornstock 0.0025 * 200 set p_fruitstock 0.00015 * 200 set p_fish 0 if(pslope <= 15) [set  p_game 0.00015 * 200 ]if(pslope >= 15) [set  p_game 0.0001 * 200]]
;    ]
;    if(pplant = 4)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.0035 * 200 set p_timberstock 0.002 * 200 set p_fwstock 0.0015 * 200 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0  set  p_game 0.0001 * 200]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.0035 * 200 set p_timberstock  0.005 * 200 set  p_fwstock 0.0025 * 200 set  p_acornstock 0.0025 * 200 set p_fruitstock 0 set p_fish 0   set  p_game 0.00015 * 200]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.0025 * 200 set p_timberstock 0.01 * 200 set  p_fwstock 0.005 * 200 set  p_acornstock 0.005 * 200 set p_fruitstock 0 set p_fish 0   set  p_game 0.0002 * 200]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.0015 * 200 set p_timberstock 0.00 * 200 set  p_fwstock 0.01 * 200 set  p_acornstock 0.01 * 200 set p_fruitstock 0 set p_fish 0   set  p_game 0.0003 * 200 ]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.0015 * 200 set p_timberstock 0.002 * 200 set  p_fwstock 0.015 * 200 set  p_acornstock 0.005 * 200 set p_fruitstock 0 set p_fish 0  set  p_game 0.00015 * 200]
;    ]
;    if(pplant = 5)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.004 * 200 set p_timberstock 0.00 set p_fwstock 0.0015 * 200 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0  set  p_game 0.0001 * 200]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.004 * 200 set p_timberstock  0.00 set  p_fwstock 0.0025 * 200 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0   set  p_game 0.00015 * 200]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.003 * 200 set p_timberstock 0.00 set  p_fwstock 0.005 * 200 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0   set  p_game 0.0002 * 200 ]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.002 * 200 set p_timberstock 0.00 set  p_fwstock 0.01 * 200 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0   set  p_game 0.0003 * 200 ]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.002 * 200 set p_timberstock 0.00 set  p_fwstock 0.015 * 200 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0  set  p_game 0.00015 * 200 ]
;    ]
;    if(psoiltype = 2);;浅水湿地
;    [
;       set p_LUfodder 0.003 set p_timberstock 0 set p_fwstock 0 set  p_acornstock 0 set p_fruitstock random 10 / 1000 set p_fish  random-normal 4 3 / 10000 * 200;;猎物数量极少
;    ]
;    if(psoiltype = 3);;湿地(可能的湖泊河流)
;    [
;      set p_LUfodder 0 set p_timberstock 0 set p_fwstock 0.00 set  p_acornstock 0 set p_fruitstock 0 set p_fish  random-normal 6 2 / 10000 * 200
;    ]
;    if(psoiltype = 4) ;;海洋
;    [
;       set p_fish  random-normal 5 2 / 10000 * 200
;    ]

    if(paspect >= 90 and paspect <= 180 )
    [
      set p_LUfodder p_LUfodder * 1.025    set p_timberstock p_timberstock * 1.025   set p_acornstock p_acornstock * 1.025     set p_fruitstock p_fruitstock * 1.025   ;;坡向对于森林的影响
    ]

;     ask patches with [p_game = 0.0001 * 50][set p_game random-normal 2 1 / 10000 * 50]
;     ask patches with [p_game = 0.00015 * 50][set p_game random-normal 3 1 / 10000 * 50]
;     ask patches with [p_game = 0.0002 * 50][set p_game random-normal 4 1 / 10000 * 50]
;     ask patches with [p_game = 0.00025 * 50][set p_game random-normal 5 1 / 10000 * 50]
;     ask patches with [p_game = 0.0003 * 50][set p_game random-normal 6 1 / 10000 * 50]



    if(psoiltype = 1 )[
      if(pslope <= 15  and p_game > 0 and p_game <= 0.0002 * 50)[set pdanger 0.5 ]
      if(pslope <= 15  and p_game > 0.0002 * 50 and p_game <= 0.0003 * 50)[set pdanger 0.75]
      if(pslope <= 15  and p_game > 0.0003 * 50 and p_game <= 0.0004 * 50)[set pdanger 1]
      if(pslope <= 15  and p_game > 0.0004 * 50 and p_game <= 0.0006 * 50)[set pdanger 1.25]
      if(pslope <= 15  and p_game > 0.0006 * 50)[set pdanger 1.5]


      if(pslope <= 35 and pslope > 15 and p_game >= 0 and p_game <= 0.0002 * 50)[set pdanger 1]
      if(pslope <= 35 and pslope > 15  and p_game > 0.0002 * 50 and p_game <= 0.0003 * 50)[set pdanger 1.5]
      if(pslope <= 35 and pslope > 15  and p_game > 0.0003 * 50 and p_game <= 0.0004 * 50)[set pdanger 2]
      if(pslope <= 35 and pslope > 15  and p_game > 0.0004 * 50 and p_game <= 0.0005 * 50)[set pdanger 2.5]
      if(pslope <= 35 and pslope > 15  and p_game > 0.0005 * 50)[set pdanger 3]

      if(pslope > 35  and  p_game >= 0 and p_game <= 0.0002 * 50)[set pdanger 2]
      if(pslope > 35  and  p_game >= 0.0002 * 50 and p_game <= 0.0003 * 50)[set pdanger 3]
      if(pslope > 35  and  p_game >= 0.0003 * 50 and p_game <= 0.0004 * 50)[set pdanger 4]
      if(pslope < 35  and  p_game >= 0.0004 * 50 and p_game <= 0.0006 * 50)[set pdanger 5]
      if(pslope > 35  and  p_game >= 0.0006 * 50)[set pdanger 6]




    ]
    if(psoiltype = 2)[
       set pdanger 0.5
    ]
    if(psoiltype = 3)[
      if(pelevation <= 0)[
        set pdanger 1
      ]
      if(pelevation >= 0 and pelevation <= 1)[
        set pdanger 3
      ]
      if(pelevation  < 1)[
        set pdanger 5
      ]
    ]
    if(psoiltype = 4)[
       set pdanger 3
      ]

    if(pdanger != 0.5 and pdanger != 0.75 and pdanger != 1 and pdanger != 1.25 and pdanger != 1.5 and pdanger != 2 and pdanger != 2.5 and pdanger != 3)[
      set pdanger 1.5 + random 10 / 10  ;;由于这个地方是水库没有slope和aspect的数据，但是由于都是河谷地区，危险性还是比较高的
      set pslope 1 + random 14
      set paspect 1 + random 90
      set pelevation random 10
    ]
  ]

;   ask patches with [p_game = 0.0001 * 50][set p_game random-normal 2 1 / 10000 * 50]
;   ask patches with [p_game = 0.00015 * 50][set p_game random-normal 3 1 / 10000 * 50]
;   ask patches with [p_game = 0.0002 * 50][set p_game random-normal 4 1 / 10000 * 50]
;   ask patches with [p_game = 0.00025 * 50][set p_game random-normal 5 1 / 10000 * 50]
;   ask patches with [p_game = 0.0003 * 50][set p_game random-normal 6 1 / 10000 * 50]
;
;   ask patches with [p_LUfodder = 0.001 * 50][set p_LUfodder random-normal 1 0.5 / 1000 * 50]
;   ask patches with [p_LUfodder = 0.0015 * 50][set p_LUfodder random-normal 1.5 0.5 / 1000 * 50]
;   ask patches with [p_LUfodder = 0.002 * 50][set p_LUfodder random-normal 2 0.5 / 1000 * 50]
;   ask patches with [p_LUfodder = 0.0025 * 50][set p_LUfodder random-normal 2.5 0.5 / 1000 * 50]
;   ask patches with [p_LUfodder = 0.003 * 50][set p_LUfodder random-normal 3 0.5 / 1000 * 50]
;   ask patches with [p_LUfodder = 0.0035 * 50][set p_LUfodder random-normal 3.5 0.5 / 1000 * 50]

;  ;;给这些数据赋予随机性
;   ask patches with [p_game = 0.0001 * 200][set p_game random-normal 2 1 / 10000 * 200]
;   ask patches with [p_game = 0.00015 * 200][set p_game random-normal 3 1 / 10000 * 200]
;   ask patches with [p_game = 0.0002 * 200][set p_game random-normal 4 1 / 10000 * 200]
;   ask patches with [p_game = 0.00025 * 200][set p_game random-normal 5 1 / 10000 * 200]
;   ask patches with [p_game = 0.0003 * 200][set p_game random-normal 6 1 / 10000 * 200]
;
;   ask patches with [p_LUfodder = 0.001 * 200][set p_LUfodder random-normal 1 0.5 / 1000 * 200]
;   ask patches with [p_LUfodder = 0.0015 * 200][set p_LUfodder random-normal 1.5 0.5 / 1000 * 200]
;   ask patches with [p_LUfodder = 0.002 * 200][set p_LUfodder random-normal 2 0.5 / 1000 * 200]
;   ask patches with [p_LUfodder = 0.0025 * 200][set p_LUfodder random-normal 2.5 0.5 / 1000 * 200]
;   ask patches with [p_LUfodder = 0.003 * 200][set p_LUfodder random-normal 3 0.5 / 1000 * 200]
;   ask patches with [p_LUfodder = 0.0035 * 200][set p_LUfodder random-normal 3.5 0.5 / 1000 * 200]


;  ;;梅花鹿分布设定
;  let p count patches with [psoiltype = 1 and psoiltype = 2] ;;陆地的总栅格数量
;  let all_mei p / 100 * 1.8    ;;区域范围内总的梅花鹿的数量
;  let p1 all_mei / 100 * 10    ;;湿地中鹿的分布数量
;  let p2 all_mei / 100 * 20    ;;灌丛中鹿的分布数量
;  let p3 all_mei / 100 * 65    ;;灌丛中鹿的分布数量
;  let p4 all_mei / 100 * 5    ;;灌丛中鹿的分布数量
;  ask max-n-of p1   patches with [psoiltype = 2] [p_game] [set p_game p_game + 63000 ]
;  ask max-n-of p2   patches with [psoiltype = 1 and pplant = 4 or pplant = 5] [p_game] [set p_game p_game + 63000]
;  ask max-n-of p3   patches with [psoiltype = 1 and pelevation >= 30 and pelevation <= 300] [p_game] [set p_game p_game + 63000]
;  ask max-n-of p4   patches with [psoiltype = 1 and pelevation > 300] [p_game] [set p_game  p_game + 63000]
;;
;  ;;野猪分布设定
;  let all_pig p / 100 * 1.8    ;;区域范围内总的梅花鹿的数量
;  let g1 all_pig / 100 * 10    ;;湿地中鹿的分布数量
;  let g2 all_pig / 100 * 20    ;;灌丛中鹿的分布数量
;  let g3 all_pig / 100 * 65    ;;灌丛中鹿的分布数量
;  let g4 all_pig / 100 * 5    ;;灌丛中鹿的分布数量
;  ask max-n-of g1   patches with [psoiltype = 2] [p_game] [set p_game p_game + 600000 ]
;  ask max-n-of g2   patches with [psoiltype = 1 and pplant = 4 or pplant = 5] [p_game] [set p_game p_game + 600000]
;  ask max-n-of g3   patches with [psoiltype = 1 and pelevation >= 30 and pelevation <= 300] [p_game] [set p_game p_game + 600000]
;  ask max-n-of g4   patches with [psoiltype = 1 and pelevation > 300] [p_game] [set p_game p_game + 600000]





end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to GET-TC
    define-travelcost
  if(count turtles =  0)
  [
; ask patches  [
;    ;;移动成本设定
;    set ptravelcost ln (ptravelcost + 1)
;  ]
  stop]
end

to go
  if time = "6900BP" and Location6900 = "1"
  [inityear
  set year year + 1
  ]
  if time = "6200BP" and Location6200 = "1"
  [inityear
  set year year + 1
  ]
  if time = "5500BP" and Location5500 = "1"
  [inityear
  set year year + 1
  ]

 nextsite
    define-MHS
  if year = 1 and time = "6900BP"[
    if to-open = "yes"
    [openfield]

  ;;收集木材不应该出现资源不足的现象，但是我的设定里面出现了，说明有一些问题
    collect-timber
    collect-paint
    ]
    if year = 1 and time = "6200BP"[
    if to-open = "yes"
    [openfield]
  ;;收集木材不应该出现资源不足的现象，但是我的设定里面出现了，说明有一些问题
    collect-timber
    collect-paint
    ]
    if year = 1 and time = "5500BP"[
    if to-open = "yes"
    [openfield]
  ;;收集木材不应该出现资源不足的现象，但是我的设定里面出现了，说明有一些问题
    collect-timber
    collect-paint
    ]
 define-deficit
 return
 gather
 fish
 hunt
 butcher
 gather-firewood
 ;畜牧部分可以屏蔽
 ;feed-LU



 area-measure
 show-dots
 year-end

  if time = "6900BP" and Location6900 = "6" [tick
   env_change
   forest-dynamics
  ]
  if time = "6200BP" and Location6900 = "18" [tick
   env_change
   forest-dynamics
  ]
  if time = "5500BP" and Location6900 = "30" [tick
   env_change
   forest-dynamics
  ]


end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to define-travelcost


;;;;;
;;;;; 对于森林中的不同植被类型，移动速度也会有所不同
  if area != "all-hemudu"[
      if ticks = 0
  [ ask patches[ if(pycor >= 70 or pycor <= -70 or pxcor >= 70 or pxcor <= -70)
    [set ptravelcost 100000]]]
    ask turtles
  [
  if(pxcor >= 70 or pxcor <= -70 or pycor >= 70 or pycor <= -70)
    [
    die
    ]
  ]
;   if (area = "fujiashan")
;    [
;
;      if(pxcor > 490 or pxcor < -490 or pycor > 490 or pycor < -490)
;    [
;    die
;    ]
;    ]
;  ]
    ask turtles with [psoiltype = 1 and pslope <= 15 and pxcor < 500 and pxcor > -500 and pycor < 500 and pycor > -500 ] [
    forward 1.5
    set travelcost travelcost + 1.5 * 7
    set ptravelcost travelcost
    set t travelcost
    set pheading heading
    ask neighbors4 [set ptravelcost t]

  ]
   ask turtles with [psoiltype = 1 and pslope > 15 and pslope <= 35 and pxcor < 800 and pxcor > -800 and pycor < 400 and pycor > -400] [
    forward 1.5
    set travelcost travelcost + 2.5 * 7
    set ptravelcost travelcost
    set t travelcost
    ask neighbors4 [set ptravelcost t]
  ]
     ask turtles with [psoiltype = 1 and pslope > 35 and pxcor < 800 and pxcor > -800 and pycor < 400 and pycor > -400] [
    forward 1.5
    set travelcost travelcost + 3.5 * 7
    set ptravelcost travelcost
    set t travelcost
    ask neighbors4 [set ptravelcost t]
  ]
    ask turtles with [psoiltype = 2 and pxcor < 800 and pxcor > -800 and pycor < 400 and pycor > -400 ] [
    forward 1.5
    set travelcost travelcost + 3 * 7
    set ptravelcost travelcost
    set t travelcost
    ask neighbors4 [set ptravelcost t]
    ]
    ask turtles with [ psoiltype = 3 and pxcor < 800 and pxcor > -800 and pycor < 400 and pycor > -400 ] [
    forward 1.5
    set travelcost travelcost + 10 * 7
    set ptravelcost travelcost
    set t travelcost
    ask neighbors4 [set ptravelcost t]
    ]
    ask turtles with [ psoiltype = 4 and pxcor < 800 and pxcor > -800 and pycor < 400 and pycor > -400 ] [
    forward 1.5
    set travelcost travelcost + 10 * 7
    set ptravelcost travelcost
    set t travelcost
    ask neighbors4 [set ptravelcost t]
    ]


  ]

  if area = "all-hemudu"[
    if ticks = 0
  [ ask patches[ if(pycor >= 800 or pycor <= -800 or pxcor >= 400 or pxcor <= -400)
    [set ptravelcost 100000]]]
    ask turtles
  [
      if(pxcor >= 800 or pxcor <= -800 or pycor >= 400 or pycor <= -400)
    [
    die
    ]
  ]
;   if (area = "fujiashan")
;    [
;
;      if(pxcor > 490 or pxcor < -490 or pycor > 490 or pycor < -490)
;    [
;    die
;    ]
;    ]
;  ]

;;;;;
;;;;; 对于森林中的不同植被类型，移动速度也会有所不同
  ask turtles with [psoiltype = 1 and pslope <= 15 and pxcor < 800 and pxcor > -800 and pycor < 400 and pycor > -400 ] [
    forward 1.5
    set travelcost travelcost + 1.5 * 14
    set ptravelcost travelcost
    set t travelcost
    set pheading heading
    ask neighbors4 [set ptravelcost t]

  ]
   ask turtles with [psoiltype = 1 and pslope > 15 and pslope <= 35 and pxcor < 800 and pxcor > -800 and pycor < 400 and pycor > -400] [
    forward 1.5
    set travelcost travelcost + 2.5 * 14
    set ptravelcost travelcost
    set t travelcost
    ask neighbors4 [set ptravelcost t]
  ]
     ask turtles with [psoiltype = 1 and pslope > 35 and pxcor < 800 and pxcor > -800 and pycor < 400 and pycor > -400] [
    forward 1.5
    set travelcost travelcost + 3.5 * 14
    set ptravelcost travelcost
    set t travelcost
    ask neighbors4 [set ptravelcost t]
  ]
    ask turtles with [psoiltype = 2 and pxcor < 800 and pxcor > -800 and pycor < 400 and pycor > -400 ] [
    forward 1.5
    set travelcost travelcost + 3 * 14
    set ptravelcost travelcost
    set t travelcost
    ask neighbors4 [set ptravelcost t]
    ]
    ask turtles with [ psoiltype = 3 and pxcor < 800 and pxcor > -800 and pycor < 400 and pycor > -400] [
    forward 1.5
    set ptravelcost travelcost + 2 * 14
    set t travelcost
    ask neighbors4 [set ptravelcost t]
    ]
    ask turtles with [ psoiltype = 4 and pxcor < 800 and pxcor > -800 and pycor < 400 and pycor > -400 ] [
    forward 1.5
    set travelcost travelcost + 10 * 14
    set ptravelcost travelcost
    set t travelcost
    ask neighbors4 [set ptravelcost t]
    ]
  ]

end

to inityear

  ask patches
  [set pygathered? false set py1gathered? false set pybrowsed? false  set pyfished? false set pyhunted? false set pyfwcollected? false set pytimbercollected? false set pypaint? false set pcame? false]

end


to nextsite
 ask one-of MHs [set MHshow? true]
 ask LU [set herd_fodder_demand 1]
 ask turtles with [shape = "dot"] [die]
 ask MHs [set MHfirewood 0 set MHtimber 0 set MHhstore 0 set MHgstore 0 set MHfstore 0 set MHg1store 0 set MHLUstore 0 set MHDeficit 0 set MHpaint 0]
 ask settlements [set area_LU 0 set area_gather 0 set area_fields 0  set area_firewood 0 set area_timber 0 set area_hunt 0 set area_paint 0]
 ask patches with [ptravelcost = 0]
 [set ptravelcost 1100000]


    ask patches [
    ;;通过对资源数量，距离远近以及危险系数进行加权求和的倒数
    ;;因为资源会因为前一年的活动有所变动，所以这里在每年开始的时候都要重置

;    set ptravelselect_0 (random 3) * (1000 * p_acornstock)  / ((ptravelcost) * pdanger )                  ;;采集橡果时如何做出选择
;    set ptravelselect_1 (random 5) * (1000 * p_fruitstock)  / ( ln(ptravelcost) * pdanger  )              ;;采集蔬果时如何做出选择
;    set ptravelselect_2 (1000 * p_timberstock)  / ( ln(ptravelcost) * pdanger )                           ;;取材时如何做出选择
;    if(psoiltype = 1)[set ptravelselect_3 (random 2) * (10000 * p_game) / ( ln(ptravelcost) * pdanger )]  ;;森林打猎时如何做出选择
;    if(psoiltype = 2)[set ptravelselect_3 (random 5) * (10000 * p_game) / ( ln(ptravelcost) * pdanger )]  ;;湿地打猎时如何做出选择
;    set ptravelselect_4  (1 + random 5) * (1000 * p_fish)  / ( ln(ptravelcost) * pdanger )                ;;捕鱼时如何做出选择
;    set ptravelselect_5  (1 + random 2) * (1000 * p_fwstock) / ( (ptravelcost) * pdanger )                ;;取柴时如何做出选择
;    set ptravelselect_6  (1 + random 3) * (1000 * p_LUfodder)  / ( (ptravelcost) * pdanger )              ;;放牧选择
;    set ptravelselect_7  (1 + random 3) * (1000 * p_paint)  / ( ln(ptravelcost) * pdanger )               ;;采漆选择


    set ptravelselect_0 households * (1000 * p_acornstock)  / ((ptravelcost) * pdanger )                                ;;采集橡果时如何做出选择
    set ptravelselect_1 households * (1000 * p_fruitstock)  / ( ln(ptravelcost) * pdanger  )                            ;;采集蔬果时如何做出选择
    set ptravelselect_2 households * (1000 * p_timberstock)  / ( ln(ptravelcost) * pdanger )                             ;;取材时如何做出选择
    if(psoiltype = 1) [set ptravelselect_3 households * (10000 * p_game) / ( ln(ptravelcost) * pdanger )]               ;;森林打猎时如何做出选择
    if(psoiltype = 2) [set ptravelselect_3 households * (10000 * p_game) / ( ln(ptravelcost) * pdanger )]               ;;湿地打猎时如何做出选择
    set ptravelselect_4  households * (1000 * p_fish)  / ( ln(ptravelcost) * pdanger )                                  ;;捕鱼时如何做出选择
    set ptravelselect_5  households * (1000 * p_fwstock) / ( (ptravelcost) * pdanger )                                  ;;取柴时如何做出选择
    set ptravelselect_6  households * (1000 * p_LUfodder)  / ( (ptravelcost) * pdanger )                                ;;放牧选择
    set ptravelselect_7  households * (1000 * p_paint)  / ( ln(ptravelcost) * pdanger )                                 ;;采漆选择
  ]
end


to define-MHS
  ;;每个时间段的比例应该有有所不同
  if time = "6900BP"  [ask MHs [set MHhshare 41 set MHgshare 30 set MHg1share 3 set MHfshare 25 set MHLUshare 1]]
  if time = "6200BP"  [ask MHs [set MHhshare 45 set MHgshare 25 set MHg1share 3 set MHfshare 25 set MHLUshare 2]]
  if time = "5500BP"  [ask MHs [set MHhshare 45 set MHgshare 20 set MHg1share 3  set MHfshare 28 set MHLUshare 4]]
end


to openfield

    if(time = "5500BP")
  [
     ask MHs
     [
       set MHcropyield (1200 + random 50 )  * (MHfieldsize)        ;;每公顷的产量  良渚在同时期大概是2400，这里取一个折中的值
       set MHcerealstore MHcropyield * 3460
       set MHcerealshare (MHcropyield * 3460) / all-energy * 100
     ]
  ]
    if(time = "6200BP")
  [
     ask MHs
     [
       set MHcropyield (900 + random 50) * (MHfieldsize)
       set MHcerealstore MHcropyield * 3460
       set MHcerealshare (MHcropyield * 3460) / all-energy * 100
     ]
  ]
    if(time = "6900BP")
  [
     ask MHs
     [
       set MHcropyield (800 + random 50) * (MHfieldsize)
       set MHcerealstore MHcropyield * 3460
       set MHcerealshare (MHcropyield * 3460) / all-energy * 100
     ]
  ]

  ask one-of MHs [set fieldsize MHfieldsize * households ]
  if fieldsize < 1 [set fieldsize 1]
  ask settlements
  [
    loop[
        ifelse fieldsize > 0
      [move-to min-one-of patches with [pfield? = false and psoiltype = 2] [ptravelcost]
        ask patch-here [

        set pfield? true]
        set fieldsize fieldsize - 1]
        [
        return
        stop]
  ]
  ]

end

to collect-timber
;  if(ticks = 0)
;  [ask MHs [loop
;  [
;    ;;收集樟科
;    ifelse 0 <= MHtimber and MHtimber <= 0.5  ;;只要没收集完就一直收集，一年的总量为 1
;    [move-to max-one-of patches with [pytimbercollected? = false or ticks = ptimbercollectedtime + 25 and pplant = 0 or pplant = 0.5 and pstandage >= 25 and pstandage <= 50 ] [ptravelselect_2]  set MHtimber MHtimber + [p_timberstock] of patch-here ask patch-here  [ set ptimbercollected? true set pytimbercollected? true  set ptimbercollectedtime ticks set ptimbercollectedt ptimbercollectedt + 1]]
;    [stop]
;  ]
;  ]
;
;  ask MHs [loop
;  [
;    ;;收集黄连木
;    ifelse 0.5 < MHtimber and MHtimber <= 0.75  ;;只要没收集完就一直收集，一年的总量为 1
;   [move-to max-one-of patches with [pytimbercollected? = false or ticks  = ptimbercollectedtime + 5  and pplant = 0.5 or pplant = 1 or pplant = 1.5 and pstandage <= 10] [ptravelselect_2]  set MHtimber MHtimber + [p_timberstock] of patch-here ask patch-here  [  set ptimbercollected? true set pytimbercollected? true set ptimbercollectedtime  ticks set ptimbercollectedt ptimbercollectedt + 1]]
;    [stop]
;  ]
;  ]
;  ask MHs [loop
;  [
;    ;;收集圆柏
;    ifelse 0.75 < MHtimber and MHtimber <= 1  ;;只要没收集完就一直收集，一年的总量为 1
;    [move-to max-one-of patches with [pytimbercollected? = false or ticks  = ptimbercollectedtime + 25 and pplant = 3 or pplant = 3.5 or pplant = 2 and pstandage >= 25 and pstandage <= 50] [ptravelselect_2]  set MHtimber MHtimber + [p_timberstock] of patch-here ask patch-here  [  set ptimbercollected? true set pytimbercollected? true set ptimbercollectedtime  ticks set ptimbercollectedt ptimbercollectedt + 1]]
;      [stop]
;  ]
;  ]
;  ]


  ask MHs [loop
  [
    ;;收集樟科
    ifelse 0 <= MHtimber and MHtimber <= 0.075  ;;只要没收集完就一直收集，一年的总量为 1
    [move-to max-one-of patches with [pytimbercollected? = false or ticks = ptimbercollectedtime + 25 and pplant = 0 or pplant = 0.5 or pplant  = 1 and pstandage >= 25 and pstandage <= 50 ] [ptravelselect_2]  set MHtimber MHtimber + [p_timberstock] of patch-here ask patch-here  [ set ptimbercollected? true set pytimbercollected? true  set ptimbercollectedtime ticks set ptimbercollectedt ptimbercollectedt + 1
        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]


      ]]
    [stop]
    ]
  ]

  ask MHs [loop
  [
    ;;收集黄连木
    ifelse 0.1 >= MHtimber and MHtimber > 0.075  ;;只要没收集完就一直收集，一年的总量为 1
   [move-to max-one-of patches with [pytimbercollected? = false or ticks  = ptimbercollectedtime + 5  and  pplant = 1.5 or pplant = 2  and pstandage <= 10] [ptravelselect_2]  set MHtimber MHtimber + [p_timberstock] of patch-here ask patch-here  [  set ptimbercollected? true set pytimbercollected? true set ptimbercollectedtime  ticks set ptimbercollectedt ptimbercollectedt + 1
        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]

      ]]
    [stop]
  ]
  ]
  ask MHs [loop
  [
    ;;收集圆柏
    ifelse 0.15 >= MHtimber and MHtimber > 0.1  ;;只要没收集完就一直收集，一年的总量为 1
    [move-to max-one-of patches with [pytimbercollected? = false or ticks  = ptimbercollectedtime + 25 and  pplant = 2 or pplant = 3 or pplant = 3.5 and pstandage >= 25 and pstandage <= 50] [ptravelselect_2]  set MHtimber MHtimber + [p_timberstock] of patch-here ask patch-here  [  set ptimbercollected? true set pytimbercollected? true set ptimbercollectedtime  ticks set ptimbercollectedt ptimbercollectedt + 1
        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]


      ]]
      [stop]
  ]
  ]



ask MHs [return]
end




;;这里还需要修改
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
to collect-paint
  if(time = "6900BP")
  [
    ask MHs [loop
  [

    ifelse  MHpaint <= 1  ;;只要没收集完就一直收集，一年的总量为 1
      [move-to max-one-of patches with [ppaint? = false or ticks = 20 or ticks = 40  and pstandage >= 10] [ptravelselect_7]  set MHpaint MHpaint + [p_paint] of patch-here ask patch-here  [  set ppaint? true set pypaint? true set ppainttime  ticks set ppaintcollectedt ppaintcollectedt + 1
        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]


        ]]
    [stop]
  ]
  ]
  ]
  if( time = "6200BP")
  [
    ask MHs [loop
  [

    ifelse  MHpaint <= 1.5  ;;只要没收集完就一直收集，一年的总量为 1
      [move-to max-one-of patches with [ppaint? = false or ticks = 20 or ticks = 40  and pstandage >= 10] [ptravelselect_7]  set MHpaint MHpaint + [p_paint] of patch-here ask patch-here  [  set ppaint? true set pypaint? true set ppainttime  ticks set ppaintcollectedt ppaintcollectedt + 1
        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]

        ]]
    [stop]
  ]
  ]
  ]
  if(time = "5500BP")
  [
    ask MHs [loop
  [

    ifelse  MHpaint <= 2  ;;只要没收集完就一直收集，一年的总量为 2
      [move-to max-one-of patches with [ppaint? = false or ticks = 20 or ticks = 40  and pstandage >= 10] [ptravelselect_7]  set MHpaint MHpaint + [p_paint] of patch-here ask patch-here  [  set ppaint? true set pypaint? true set ppainttime  ticks set ppaintcollectedt ppaintcollectedt + 1
        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]

        ]]
    [stop]
  ]
  ]
  ]

end


to define-deficit
  ask MHs [set MHDeficit (100 - MHcerealshare) / 100]
end


to return
  ;;6900
    if Location6900 = "1" and time = "6900BP"
  [ask MHs  [setxy xcoord01 ycoord01]]
    if Location6900 = "2" and time = "6900BP"
  [ask MHs  [setxy xcoord02 ycoord02]]
    if Location6900 = "3" and time = "6900BP"
  [ask MHs  [setxy xcoord03 ycoord03]]
    if Location6900 = "4" and time = "6900BP"
  [ask MHs  [setxy xcoord04 ycoord04]]
    if Location6900 = "5" and time = "6900BP"
  [ask MHs  [setxy xcoord05 ycoord05]]
    if Location6900 = "6" and time = "6900BP"
  [ask MHs  [setxy xcoord06 ycoord06]]

  ;;6200
      if Location6200 = "1" and time = "6200BP"
  [ask MHs  [setxy xcoord001 ycoord001]]
      if Location6200 = "2" and time = "6200BP"
  [ask MHs  [setxy xcoord002 ycoord002]]
      if Location6200 = "3" and time = "6200BP"
  [ask MHs  [setxy xcoord003 ycoord003]]
      if Location6200 = "4" and time = "6200BP"
  [ask MHs  [setxy xcoord004 ycoord004]]
      if Location6200 = "5" and time = "6200BP"
  [ask MHs  [setxy xcoord005 ycoord005]]
      if Location6200 = "6" and time = "6200BP"
  [ask MHs  [setxy xcoord006 ycoord006]]
      if Location6200 = "7" and time = "6200BP"
  [ask MHs  [setxy xcoord007 ycoord007]]
      if Location6200 = "8" and time = "6200BP"
  [ask MHs  [setxy xcoord008 ycoord008]]
      if Location6200 = "9" and time = "6200BP"
  [ask MHs  [setxy xcoord009 ycoord009]]
      if Location6200 = "10" and time = "6200BP"
  [ask MHs  [setxy xcoord010 ycoord010]]
      if Location6200 = "11" and time = "6200BP"
  [ask MHs  [setxy xcoord011 ycoord011]]
      if Location6200 = "12" and time = "6200BP"
  [ask MHs  [setxy xcoord012 ycoord012]]
      if Location6200 = "13" and time = "6200BP"
  [ask MHs  [setxy xcoord013 ycoord013]]
      if Location6200 = "14" and time = "6200BP"
  [ask MHs  [setxy xcoord014 ycoord014]]
      if Location6200 = "15" and time = "6200BP"
  [ask MHs  [setxy xcoord015 ycoord015]]
      if Location6200 = "16" and time = "6200BP"
  [ask MHs  [setxy xcoord016 ycoord016]]
      if Location6200 = "17" and time = "6200BP"
  [ask MHs  [setxy xcoord017 ycoord017]]
      if Location6200 = "18" and time = "6200BP"
  [ask MHs  [setxy xcoord018 ycoord018]]

  ;;5500
       if Location5500 = "1" and time = "5500BP"
  [ask MHs  [setxy xcoord-01 ycoord-01]]
       if Location5500 = "2" and time = "5500BP"
  [ask MHs  [setxy xcoord-02 ycoord-02]]
       if Location5500 = "3" and time = "5500BP"
  [ask MHs  [setxy xcoord-03 ycoord-03]]
       if Location5500 = "4" and time = "5500BP"
  [ask MHs  [setxy xcoord-04 ycoord-04]]
       if Location5500 = "5" and time = "5500BP"
  [ask MHs  [setxy xcoord-05 ycoord-05]]
       if Location5500 = "6" and time = "5500BP"
  [ask MHs  [setxy xcoord-06 ycoord-06]]
       if Location5500 = "7" and time = "5500BP"
  [ask MHs  [setxy xcoord-07 ycoord-07]]
       if Location5500 = "8" and time = "5500BP"
  [ask MHs  [setxy xcoord-08 ycoord-08]]
       if Location5500 = "9" and time = "5500BP"
  [ask MHs  [setxy xcoord-09 ycoord-09]]
       if Location5500 = "10" and time = "5500BP"
  [ask MHs  [setxy xcoord-10 ycoord-10]]
       if Location5500 = "11" and time = "5500BP"
  [ask MHs  [setxy xcoord-11 ycoord-11]]
       if Location5500 = "12" and time = "5500BP"
  [ask MHs  [setxy xcoord-12 ycoord-12]]
       if Location5500 = "13" and time = "5500BP"
  [ask MHs  [setxy xcoord-13 ycoord-13]]
       if Location5500 = "14" and time = "5500BP"
  [ask MHs  [setxy xcoord-14 ycoord-14]]
       if Location5500 = "15" and time = "5500BP"
  [ask MHs  [setxy xcoord-15 ycoord-15]]
       if Location5500 = "16" and time = "5500BP"
  [ask MHs  [setxy xcoord-16 ycoord-16]]
       if Location5500 = "17" and time = "5500BP"
  [ask MHs  [setxy xcoord-17 ycoord-17]]
       if Location5500 = "18" and time = "5500BP"
  [ask MHs  [setxy xcoord-18 ycoord-18]]
       if Location5500 = "19" and time = "5500BP"
  [ask MHs  [setxy xcoord-19 ycoord-19]]
       if Location5500 = "20" and time = "5500BP"
  [ask MHs  [setxy xcoord-20 ycoord-20]]
       if Location5500 = "21" and time = "5500BP"
  [ask MHs  [setxy xcoord-21 ycoord-21]]
       if Location5500 = "22" and time = "5500BP"
  [ask MHs  [setxy xcoord-22 ycoord-22]]
       if Location5500 = "23" and time = "5500BP"
  [ask MHs  [setxy xcoord-23 ycoord-23]]
       if Location5500 = "24" and time = "5500BP"
  [ask MHs  [setxy xcoord-24 ycoord-24]]
       if Location5500 = "25" and time = "5500BP"
  [ask MHs  [setxy xcoord-25 ycoord-25]]
       if Location5500 = "26" and time = "5500BP"
  [ask MHs  [setxy xcoord-26 ycoord-26]]
       if Location5500 = "27" and time = "5500BP"
  [ask MHs  [setxy xcoord-27 ycoord-27]]
       if Location5500 = "28" and time = "5500BP"
  [ask MHs  [setxy xcoord-28 ycoord-28]]
       if Location5500 = "29" and time = "5500BP"
  [ask MHs  [setxy xcoord-29 ycoord-29]]
       if Location5500 = "30" and time = "5500BP"
  [ask MHs  [setxy xcoord-30 ycoord-30]]
  end

to fish

  ;;;是否会在农田捕鱼呢，是有可能的

  ask MHs
  [
      loop[
      ifelse MHfstore <= MHDeficit * (MHfshare * 0.01)
      [move-to max-one-of patches with [psoiltype = 2 or psoiltype = 3 and pyfished? = false and pfield? = false  ] [ptravelselect_4]  ;先标记这个地区是否捕过鱼，然后每次间隔一年后才能再捕捉  and ticks - pfishedt != 2
          set MHfstore MHfstore + [p_fish] of patch-here  ask patch-here [set pfished? true set pyfished? true set pfishedtime ticks set pfishedt pfishedt + 1

;        if time = "6900BP" and Location6900 = "1" and whofishercome != 0 and whofishercome - fishcomesitesnumber * 100 != 1 and fishcomesitesnumber <= 6 [set whofishercome whofishercome + 100 set fishcomesitesnumber fishcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "2" and whofishercome != 0 and whofishercome - fishcomesitesnumber * 100 != 2 and fishcomesitesnumber <= 6 [set whofishercome whofishercome + 100 set fishcomesitesnumber fishcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "3" and whofishercome != 0 and whofishercome - fishcomesitesnumber * 100 != 3 and fishcomesitesnumber <= 6 [set whofishercome whofishercome + 100 set fishcomesitesnumber fishcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "4" and whofishercome != 0 and whofishercome - fishcomesitesnumber * 100 != 4 and fishcomesitesnumber <= 6 [set whofishercome whofishercome + 100 set fishcomesitesnumber fishcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "5" and whofishercome != 0 and whofishercome - fishcomesitesnumber * 100 != 5 and fishcomesitesnumber <= 6 [set whofishercome whofishercome + 100 set fishcomesitesnumber fishcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "6" and whofishercome != 0 and whofishercome - fishcomesitesnumber * 100 != 6 and fishcomesitesnumber <= 6 [set whofishercome whofishercome + 100 set fishcomesitesnumber fishcomesitesnumber + 1]
;
;        if time = "6900BP" and Location6900 = "1" and whofishercome = 0 [set whofishercome 1 set fishcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "2" and whofishercome = 0 [set whofishercome 2 set fishcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "3" and whofishercome = 0 [set whofishercome 3 set fishcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "4" and whofishercome = 0 [set whofishercome 4 set fishcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "5" and whofishercome = 0 [set whofishercome 5 set fishcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "6" and whofishercome = 0 [set whofishercome 6 set fishcomesitesnumber 1]

        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]


        ]
          ask neighbors with [p_fruitstock > 0.008][set p1gathered? true set py1gathered? true set p1gatheredtime ticks set p1gatheredt p1gatheredt + 1

        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]

        ]
      ]
      [stop]
      ]

  ]

  if(count patches with [psoiltype = 4] > 10000)
  [


  ask MHs
  [
      loop[
      ifelse MHfstore <= MHDeficit * (MHfshare * 0.01)
      [move-to max-one-of patches with [psoiltype = 2 or psoiltype = 3  and pyfished? = false and pfield? = false ] [ptravelselect_4]  ;先标记这个地区是否捕过鱼，然后每次间隔一年后才能再捕捉  and ticks - pfishedt != 2
          set MHfstore MHfstore + [p_fish] of patch-here  ask patch-here [set pfished? true set pyfished? true set pfishedtime ticks set pfishedt pfishedt + 1

;        if time = "6900BP" and Location6900 = "1" and whofishercome != 0 and whofishercome - fishcomesitesnumber * 100 != 1 and fishcomesitesnumber <= 6 [set whofishercome whofishercome + 100 set fishcomesitesnumber fishcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "2" and whofishercome != 0 and whofishercome - fishcomesitesnumber * 100 != 2 and fishcomesitesnumber <= 6 [set whofishercome whofishercome + 100 set fishcomesitesnumber fishcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "3" and whofishercome != 0 and whofishercome - fishcomesitesnumber * 100 != 3 and fishcomesitesnumber <= 6 [set whofishercome whofishercome + 100 set fishcomesitesnumber fishcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "4" and whofishercome != 0 and whofishercome - fishcomesitesnumber * 100 != 4 and fishcomesitesnumber <= 6 [set whofishercome whofishercome + 100 set fishcomesitesnumber fishcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "5" and whofishercome != 0 and whofishercome - fishcomesitesnumber * 100 != 5 and fishcomesitesnumber <= 6 [set whofishercome whofishercome + 100 set fishcomesitesnumber fishcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "6" and whofishercome != 0 and whofishercome - fishcomesitesnumber * 100 != 6 and fishcomesitesnumber <= 6 [set whofishercome whofishercome + 100 set fishcomesitesnumber fishcomesitesnumber + 1]
;
;
;
;        if time = "6900BP" and Location6900 = "1" and whofishercome = 0 [set whofishercome 1 set fishcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "2" and whofishercome = 0 [set whofishercome 2 set fishcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "3" and whofishercome = 0 [set whofishercome 3 set fishcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "4" and whofishercome = 0 [set whofishercome 4 set fishcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "5" and whofishercome = 0 [set whofishercome 5 set fishcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "6" and whofishercome = 0 [set whofishercome 6 set fishcomesitesnumber 1]

        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]

          ]

        ]
      [stop]
      ]

  ]

  ]

end


;to fish_sea
;    ask MHs
;  [
;
;      loop[
;      ifelse MHfstore <= MHDeficit * (MHfshare * 0.01)
;      [move-to max-one-of patches with [psoiltype = 4 and pyfished? = false ] [ptravelselect_4]  ;先标记这个地区是否捕过鱼，然后每次间隔一年后才能再捕捉  and ticks - pfishedt != 2
;          set MHfstore MHfstore + [p_fish] of patch-here  ask patch-here [set pfished? true set pyfished? true set pfishedtime ticks set pfishedt pfishedt + 1 ]]
;      [stop]
;  ]
;  ]
;end

to gather

  ;;收集橡果
  ask MHs
    [loop
      [if MHgstore <  MHDeficit * (MHgshare * 0.01)
        [move-to max-one-of patches with [psoiltype = 1 and pygathered? = false and p_acornstock != 0] [ptravelselect_0]  set MHgstore MHgstore + [p_acornstock] of patch-here ask patch-here [set pgathered? true set pygathered? true set pgatheredtime ticks set pgatheredt pgatheredt + 1
        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]

        ]]
        if MHgstore >=  MHDeficit * (MHgshare * 0.01) [stop]]]

  ;;收集陆生水果
    ask MHs
    [loop
      [if MHg1store <  MHDeficit * (MHg1share * 0.01)
        [move-to max-one-of patches with [psoiltype = 1 and py1gathered? = false and pfield? != true and p_fruitstock != 0] [ptravelselect_1]  set MHg1store MHg1store + [p_fruitstock] of patch-here ask patch-here [set p1gathered? true set py1gathered? true set p1gatheredtime ticks set p1gatheredt p1gatheredt + 1

;        if time = "6900BP" and Location6900 = "1" and whogathercome != 0 and whogathercome - gathercomesitesnumber * 100 != 1 and gathercomesitesnumber <= 6 [set whogathercome whogathercome + 100 set gathercomesitesnumber gathercomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "2" and whogathercome != 0 and whogathercome - gathercomesitesnumber * 100 != 2 and gathercomesitesnumber <= 6 [set whogathercome whogathercome + 100 set gathercomesitesnumber gathercomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "3" and whogathercome != 0 and whogathercome - gathercomesitesnumber * 100 != 3 and gathercomesitesnumber <= 6 [set whogathercome whogathercome + 100 set gathercomesitesnumber gathercomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "4" and whogathercome != 0 and whogathercome - gathercomesitesnumber * 100 != 4 and gathercomesitesnumber <= 6 [set whogathercome whogathercome + 100 set gathercomesitesnumber gathercomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "5" and whogathercome != 0 and whogathercome - gathercomesitesnumber * 100 != 5 and gathercomesitesnumber <= 6 [set whogathercome whogathercome + 100 set gathercomesitesnumber gathercomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "6" and whogathercome != 0 and whogathercome - gathercomesitesnumber * 100 != 6 and gathercomesitesnumber <= 6 [set whogathercome whogathercome + 100 set gathercomesitesnumber gathercomesitesnumber + 1]
;
;
;        if time = "6900BP" and Location6900 = "1" and whogathercome = 0 [set whogathercome 1 set gathercomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "2" and whogathercome = 0 [set whogathercome 2 set gathercomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "3" and whogathercome = 0 [set whogathercome 3 set gathercomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "4" and whogathercome = 0 [set whogathercome 4 set gathercomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "5" and whogathercome = 0 [set whogathercome 5 set gathercomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "6" and whogathercome = 0 [set whogathercome 6 set gathercomesitesnumber 1]

        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]

      ]]
       if MHg1store >=  MHDeficit * (MHg1share * 0.01) [stop]]]

end





to hunt
ask MHs
  [
;  [loop
;    [ifelse MHhstore < MHDeficit * (MHhshare * 0.01)
;     [
;        ask max-n-of 100 patches with [pyhunted? = false and psoiltype = 1 or psoiltype = 2]  [ptravelselect_3]
;        [set MHhstore MHhstore + [p_game] of patch-here   ask patch-here [set phunted? true set pyhunted? true set phuntedtime ticks set phuntedt phuntedt + 1]
;    ]
;    [stop]
;  ]
   loop
    [
      if MHhstore < MHDeficit * (MHhshare * 0.01)
      [set MHhstore MHhstore + sum [p_game] of max-n-of 3 patches with [pyhunted? = false and psoiltype = 1 or psoiltype = 2 and pfield? != true  ] [ptravelselect_3]  ask max-n-of 3 patches  with [pyhunted? = false and psoiltype = 1 or psoiltype = 2 and pfield? != true  ]  [ptravelselect_3] [set phunted? true set pyhunted? true set phuntedtime ticks set phuntedt phuntedt + 1

;        if time = "6900BP" and Location6900 = "1" and whohuntercome != 0 and whohuntercome - huntcomesitesnumber * 100 != 1 and huntcomesitesnumber <= 6 [set whohuntercome whohuntercome + 100 set huntcomesitesnumber huntcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "2" and whohuntercome != 0 and whohuntercome - huntcomesitesnumber * 100 != 2 and huntcomesitesnumber <= 6 [set whohuntercome whohuntercome + 100 set huntcomesitesnumber huntcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "3" and whohuntercome != 0 and whohuntercome - huntcomesitesnumber * 100 != 3 and huntcomesitesnumber <= 6 [set whohuntercome whohuntercome + 100 set huntcomesitesnumber huntcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "4" and whohuntercome != 0 and whohuntercome - huntcomesitesnumber * 100 != 4 and huntcomesitesnumber <= 6 [set whohuntercome whohuntercome + 100 set huntcomesitesnumber huntcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "5" and whohuntercome != 0 and whohuntercome - huntcomesitesnumber * 100 != 5 and huntcomesitesnumber <= 6 [set whohuntercome whohuntercome + 100 set huntcomesitesnumber huntcomesitesnumber + 1]
;        if time = "6900BP" and Location6900 = "6" and whohuntercome != 0 and whohuntercome - huntcomesitesnumber * 100 != 6 and huntcomesitesnumber <= 6 [set whohuntercome whohuntercome + 100 set huntcomesitesnumber huntcomesitesnumber + 1]
;
;
;        if time = "6900BP" and Location6900 = "1" and whohuntercome = 0 [set whohuntercome 1 set huntcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "2" and whohuntercome = 0 [set whohuntercome 2 set huntcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "3" and whohuntercome = 0 [set whohuntercome 3 set huntcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "4" and whohuntercome = 0 [set whohuntercome 4 set huntcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "5" and whohuntercome = 0 [set whohuntercome 5 set huntcomesitesnumber 1]
;        if time = "6900BP" and Location6900 = "6" and whohuntercome = 0 [set whohuntercome 6 set huntcomesitesnumber 1]

        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]

      ]]
      if MHhstore >= MHDeficit * (MHhshare * 0.01)[stop]]
    ]

end

to butcher
  ask MHs [set MHLUstore (MHDeficit * MHLUshare * 0.01)]
end

to feed-LU
  ask min-n-of nr_of_houses LU [who] [
    loop
    [
      ifelse herd_fodder_demand > 0
      [set herd_fodder_demand herd_fodder_demand - sum [p_LUfodder] of max-n-of 100 patches with [psoiltype = 1 or  psoiltype = 2 and pybrowsed? = false and pfield? = false] [ptravelselect_6]  ask max-n-of 100 patches  with [psoiltype = 1 or psoiltype = 2 and pybrowsed? = false and pfield? = false]  [ptravelselect_6] [set pbrowsed? true set pybrowsed? true set pbrowsedtime ticks set pbrowsedt pbrowsedt + 1]]
      [ask LU [set herd_fodder_demand 0] stop]]
    ]

end



to gather-firewood
  ask MHs
  [
    loop
  [ifelse MHfirewood <= 1
      [move-to max-one-of patches with [pyfwcollected? = false] [ptravelselect_5]  set MHfirewood MHfirewood + [p_fwstock] of patch-here ask patch-here  [ set pyfwcollected? true set pfwcollected? true set pfwcollectedtime ticks set pfwcollectedt pfwcollectedt + 1

        if time = "6900BP" and Location6900 = "1"  [set psite1 true]
        if time = "6900BP" and Location6900 = "2"  [set psite2 true]
        if time = "6900BP" and Location6900 = "3"  [set psite3 true]
        if time = "6900BP" and Location6900 = "4"  [set psite4 true]
        if time = "6900BP" and Location6900 = "5"  [set psite5 true]
        if time = "6900BP" and Location6900 = "6"  [set psite6 true]


      ]] ;sprout 1 [set shape "white_dot" set color white  set size 1 if count turtles-here > 2 [ht]]]]
              [stop]]]
end


to forest-dynamics
  ask patches with [psoiltype = 1 ]
  [
    ifelse pstandage < 500
    [set pstandage pstandage + 1]
    [set pstandage 1]
  ]
end

to env_change
    ask patches with [pytimbercollected? = true] [set p_timberstock (p_timberstock * 0.5) set p_fwstock (p_fwstock * 0.8)]
    ask patches with [pytimbercollected? = false and pstandage < 20 and p_timberstock <= 0.03] [set p_timberstock (p_timberstock * 1.02) set p_fwstock (p_fwstock * 1.02)]
    ask patches with [pybrowsed? = true and psoiltype = 1] [set p_timberstock (p_timberstock * 0.98) (set p_LUfodder (p_LUfodder * 1.02)) set p_fwstock (p_fwstock * 0.98) set p_acornstock (p_acornstock * 0.98) set p_fruitstock (p_fruitstock * 0.98) ]
    ask patches with [pybrowsed? = true and psoiltype = 2] [set p_fruitstock (p_fruitstock * 0.98) ]
    ask patches with [pyhunted? = true][set p_game (p_game * 0.98)]
    ask patches with [pyhunted? = false and p_game <= 0.0006][set p_game (p_game * 1.01)]
    ask patches with [pyfished? = true and psoiltype = 2][set p_fish (p_fish * 0.8)] ;;浅水湿地相对湖泊/河流/海洋生物交互差一些，所以在被捕鱼后，产量会在第二年有所降低
    ask patches with [pyfished? = false and p_fish <= 0.0006 and psoiltype = 2][set p_fish (p_fish * 1.02)]
    ask patches with [psoiltype = 1 and pstandage >= 400][set p_timberstock (p_timberstock * 0.99) set p_fwstock (p_fwstock * 1.01) set p_acornstock (p_acornstock * 0.99) set p_game (p_game * 0.99)]
    ask patches with [psoiltype = 1 and pstandage <= 50 and p_acornstock <= 0.03][ set p_acornstock (p_acornstock * 1.01) set p_game (p_game * 1.01)]


end


to area-measure
ask settlements
 [
    set area_LU count patches with [pbrowsed? = true]
    set area_gather count patches with [pgathered? = true]
    set area_gather1 count patches with [p1gathered? = true]
    set area_fields count patches with [pfield? = true]
    set area_hunt count patches with [phunted? = true]
    set area_fish count patches with [pfished? = true and psoiltype != 4]
    set area_seafish count patches with [pfished? = true and psoiltype = 4]
    set area_timber count patches with [ptimbercollected? = true]
    set area_firewood count patches with [pfwcollected? = true]
    set area_paint count patches with [ppaint? = true]
  ]
end



to show-dots

  if count settlements = 0 [  create-settlements 1 [setxy 0 0  set size 2]]
  ask one-of settlements
  [
   ;[ask max-n-of (10 * sqrt count patches with [phunted? = true]) patches with [phunted? = true][distance myself] [sprout 1[set shape "red_dot" set color red set size 1.5]]]; ;


    ask n-of (count patches with [phunted? = true]  ) patches with [phunted? = true]   [sprout 1[set shape "dot" set color red set size 4.5]]
    ask n-of (count patches with [pfished? = true ] ) patches with [pfished? = true ] [sprout 1 [set shape "dot"set color black set size 4.5]]
    ask n-of (count patches with [p1gathered? = true] ) patches with [p1gathered? = true ] [sprout 1 [set shape "dot" set color 25 set size 4.5]]
    ask n-of (count patches with [ppaint? = true ]  ) patches with [ppaint? = true ] [sprout 1 [set shape "triangle"set color brown set size 4.5]]
    ask n-of (count patches with [pfwcollected? = true] ) patches with [pfwcollected? = true] [sprout 1 [set shape "triangle" set color 112 set size 4.5]]
    ask n-of (count patches with [pbrowsed? = true]) patches with [pbrowsed? = true] [sprout 1 [set shape "dot" set color white set size 4.5]]
    ask n-of (count patches with [pgathered? = true] ) patches with [pgathered? = true ] [sprout 1 [set shape "dot" set color 135 set size 3.5]]
    ask n-of (count patches with [ptimbercollected? = true] ) patches with [ptimbercollected? = true ] [sprout 1 [set shape "triangle" set color 100 set size 4.5]]
    ask n-of (count patches with [pfield? = true]  ) patches with [pfield? = true] [sprout 1 [set shape "dot" set color yellow set size 5.5]]
    ; ask one-of settlements [ask patch-here [sprout 1 [set shape "circle" set color 0 set size 10.5]]]

  ]
end

to show-areahunt
    ;[ask max-n-of (10 * sqrt count patches with [phunted? = true]) patches with [phunted? = true][distance myself] [sprout 1[set shape "red_dot" set color red set size 1.5]]]; ;
    ask n-of (count patches with [ phunted? = true and whohuntercome = 1]  ) patches with [phunted? = true and whohuntercome = 1]   [sprout 1[set shape "dot" set color 15 set size 2.5]]
    ask n-of (count patches with [ phunted? = true and whohuntercome = 2]  ) patches with [phunted? = true and whohuntercome = 2]   [sprout 1[set shape "dot" set color 15 set size 2.5]]
    ask n-of (count patches with [ phunted? = true and whohuntercome = 3]  ) patches with [phunted? = true and whohuntercome = 3]   [sprout 1[set shape "dot" set color 15 set size 2.5]]
    ask n-of (count patches with [ phunted? = true and whohuntercome = 4]  ) patches with [phunted? = true and whohuntercome = 4]   [sprout 1[set shape "dot" set color 15 set size 2.5]]
    ask n-of (count patches with [ phunted? = true and whohuntercome = 5]  ) patches with [phunted? = true and whohuntercome = 5]   [sprout 1[set shape "dot" set color 15 set size 2.5]]
    ask n-of (count patches with [ phunted? = true and whohuntercome = 6]  ) patches with [phunted? = true and whohuntercome = 6]   [sprout 1[set shape "dot" set color 15 set size 2.5]]

    ask n-of (count patches with [ phunted? = true and whohuntercome > 100 and whohuntercome < 200]  ) patches with [phunted? = true and whohuntercome > 100 and whohuntercome < 200]   [sprout 1[set shape "dot" set color 75 set size 2.5]]  ;;叠置两次
    ask n-of (count patches with [ phunted? = true and whohuntercome > 200 and whohuntercome < 300]  ) patches with [phunted? = true and whohuntercome > 200 and whohuntercome < 300]   [sprout 1[set shape "dot" set color 85 set size 2.5]]  ;;叠置三次
    ask n-of (count patches with [ phunted? = true and whohuntercome > 300 and whohuntercome < 400]  ) patches with [phunted? = true and whohuntercome > 300 and whohuntercome < 400]   [sprout 1[set shape "dot" set color 95 set size 2.5]]  ;;叠置四次
    ask n-of (count patches with [ phunted? = true and whohuntercome > 400 and whohuntercome < 500]  ) patches with [phunted? = true and whohuntercome > 400 and whohuntercome < 500]   [sprout 1[set shape "dot" set color 105 set size 2.5]] ;;叠置五次
    ask n-of (count patches with [ phunted? = true and whohuntercome > 500 and whohuntercome < 600]  ) patches with [phunted? = true and whohuntercome > 500 and whohuntercome < 600]   [sprout 1[set shape "dot" set color 115 set size 2.5]] ;;叠置六次


    ask n-of (count patches with [ pfished? = true and whofishercome = 1]  ) patches with [pfished? = true and whofishercome = 1]   [sprout 1[set shape "dot" set color 0 set size 2.5]]
    ask n-of (count patches with [ pfished? = true and whofishercome = 2]  ) patches with [pfished? = true and whofishercome = 2]   [sprout 1[set shape "dot" set color 0 set size 2.5]]
    ask n-of (count patches with [ pfished? = true and whofishercome = 3]  ) patches with [pfished? = true and whofishercome = 3]   [sprout 1[set shape "dot" set color 0 set size 2.5]]
    ask n-of (count patches with [ pfished? = true and whofishercome = 4]  ) patches with [pfished? = true and whofishercome = 4]   [sprout 1[set shape "dot" set color 0 set size 2.5]]
    ask n-of (count patches with [ pfished? = true and whofishercome = 5]  ) patches with [pfished? = true and whofishercome = 5]   [sprout 1[set shape "dot" set color 0 set size 2.5]]
    ask n-of (count patches with [ pfished? = true and whofishercome = 6]  ) patches with [pfished? = true and whofishercome = 6]   [sprout 1[set shape "dot" set color 0 set size 2.5]]

    ask n-of (count patches with [ pfished? = true and whofishercome > 100 and whofishercome < 200]  ) patches with [pfished? = true and whofishercome > 100 and whofishercome < 200]   [sprout 1[set shape "dot" set color 75 set size 2.5]]  ;;叠置两次
    ask n-of (count patches with [ pfished? = true and whofishercome > 200 and whofishercome < 300]  ) patches with [pfished? = true and whofishercome > 200 and whofishercome < 300]   [sprout 1[set shape "dot" set color 85 set size 2.5]]  ;;叠置三次
    ask n-of (count patches with [ pfished? = true and whofishercome > 300 and whofishercome < 400]  ) patches with [pfished? = true and whofishercome > 300 and whofishercome < 400]   [sprout 1[set shape "dot" set color 95 set size 2.5]]  ;;叠置四次
    ask n-of (count patches with [ pfished? = true and whofishercome > 400 and whofishercome < 500]  ) patches with [pfished? = true and whofishercome > 400 and whofishercome < 500]   [sprout 1[set shape "dot" set color 105 set size 2.5]] ;;叠置五次
    ask n-of (count patches with [ pfished? = true and whofishercome > 500 and whofishercome < 600]  ) patches with [pfished? = true and whofishercome > 500 and whofishercome < 600]   [sprout 1[set shape "dot" set color 115 set size 2.5]] ;;叠置六次


    ask n-of (count patches with [ p1gathered? = true and whogathercome = 1]  ) patches with [p1gathered? = true and whogathercome = 1]   [sprout 1[set shape "dot" set color 25 set size 2.5]]
    ask n-of (count patches with [ p1gathered? = true and whogathercome = 2]  ) patches with [p1gathered? = true and whogathercome = 2]   [sprout 1[set shape "dot" set color 25 set size 2.5]]
    ask n-of (count patches with [ p1gathered? = true and whogathercome = 3]  ) patches with [p1gathered? = true and whogathercome = 3]   [sprout 1[set shape "dot" set color 25 set size 2.5]]
    ask n-of (count patches with [ p1gathered? = true and whogathercome = 4]  ) patches with [p1gathered? = true and whogathercome = 4]   [sprout 1[set shape "dot" set color 25 set size 2.5]]
    ask n-of (count patches with [ p1gathered? = true and whogathercome = 5]  ) patches with [p1gathered? = true and whogathercome = 5]   [sprout 1[set shape "dot" set color 25 set size 2.5]]
    ask n-of (count patches with [ p1gathered? = true and whogathercome = 6]  ) patches with [p1gathered? = true and whogathercome = 6]   [sprout 1[set shape "dot" set color 25 set size 2.5]]

    ask n-of (count patches with [ p1gathered? = true and whogathercome > 100 and whogathercome < 200]  ) patches with [p1gathered? = true and whogathercome > 100 and whogathercome < 200]   [sprout 1[set shape "dot" set color 75 set size 2.5]]  ;;叠置两次
    ask n-of (count patches with [ p1gathered? = true and whogathercome > 200 and whogathercome < 300]  ) patches with [p1gathered? = true and whogathercome > 200 and whogathercome < 300]   [sprout 1[set shape "dot" set color 85 set size 2.5]]  ;;叠置三次
    ask n-of (count patches with [ p1gathered? = true and whogathercome > 300 and whogathercome < 400]  ) patches with [p1gathered? = true and whogathercome > 300 and whogathercome < 400]   [sprout 1[set shape "dot" set color 95 set size 2.5]]  ;;叠置四次
    ask n-of (count patches with [ p1gathered? = true and whogathercome > 400 and whogathercome < 500]  ) patches with [p1gathered? = true and whogathercome > 400 and whogathercome < 500]   [sprout 1[set shape "dot" set color 105 set size 2.5]] ;;叠置五次
    ask n-of (count patches with [ p1gathered? = true and whogathercome > 500 and whogathercome < 600]  ) patches with [p1gathered? = true and whogathercome > 500 and whogathercome < 600]   [sprout 1[set shape "dot" set color 115 set size 2.5]] ;;叠置六次


    ask n-of (count patches with [ ptimbercollected? = true and whotimbercome = 1]  ) patches with [ptimbercollected? = true and whotimbercome = 1]   [sprout 1[set shape "dot" set color 11 set size 2.5]]
    ask n-of (count patches with [ ptimbercollected? = true and whotimbercome = 2]  ) patches with [ptimbercollected? = true and whotimbercome = 2]   [sprout 1[set shape "dot" set color 15 set size 2.5]]
    ask n-of (count patches with [ ptimbercollected? = true and whotimbercome = 3]  ) patches with [ptimbercollected? = true and whotimbercome = 3]   [sprout 1[set shape "dot" set color 18 set size 2.5]]
    ask n-of (count patches with [ ptimbercollected? = true and whotimbercome = 4]  ) patches with [ptimbercollected? = true and whotimbercome = 4]   [sprout 1[set shape "dot" set color 123 set size 2.5]]
    ask n-of (count patches with [ ptimbercollected? = true and whotimbercome = 5]  ) patches with [ptimbercollected? = true and whotimbercome = 5]   [sprout 1[set shape "dot" set color 125 set size 2.5]]
    ask n-of (count patches with [ ptimbercollected? = true and whotimbercome = 6]  ) patches with [ptimbercollected? = true and whotimbercome = 6]   [sprout 1[set shape "dot" set color 128 set size 2.5]]



;  ask n-of (count patches with [phuntedt > 0 and phuntedt <= 5]  ) patches with [phunted? = true]   [sprout 1[set shape "dot" set color 9 set size 2.5]]
;  ask n-of (count patches with [phuntedt > 5 and phuntedt <= 10]  ) patches with [phunted? = true]   [sprout 1[set shape "dot" set color 25 set size 2.5]]
;  ask n-of (count patches with [phuntedt > 10 and phuntedt <= 15]  ) patches with [phunted? = true]   [sprout 1[set shape "dot" set color 35 set size 2.5]]
;  ask n-of (count patches with [phuntedt > 15 and phuntedt <= 20]  ) patches with [phunted? = true]   [sprout 1[set shape "dot" set color 45 set size 2.5]]
;  ask n-of (count patches with [phuntedt > 20]  ) patches with [phunted? = true]   [sprout 1[set shape "dot" set color black set size 2.5]]

end

to show-areagather
  ask n-of (count patches with [pgatheredt > 0 and phuntedt <= 10]  ) patches with [pgathered? = true]   [sprout 1[set shape "dot" set color 9 set size 2.5]]

  ask n-of (count patches with [pgatheredt > 10 and phuntedt <= 25]  ) patches with [pgathered? = true]   [sprout 1[set shape "dot" set color 35 set size 2.5]]

  ask n-of (count patches with [pgatheredt > 25]  ) patches with [pgathered? = true]   [sprout 1[set shape "dot" set color 135 set size 2.5]]

end

to show-areafish
  ask n-of (count patches with [pfishedt > 0 and pfishedt <= 10]  ) patches with [pfished? = true]   [sprout 1[set shape "dot" set color 9 set size 2.5]]

  ask n-of (count patches with [pfishedt > 10 and pfishedt <= 25]  ) patches with [pfished? = true]   [sprout 1[set shape "dot" set color 35 set size 2.5]]

  ask n-of (count patches with [pfishedt > 25]  ) patches with [pfished? = true]   [sprout 1[set shape "dot" set color 135 set size 2.5]]

end


to all-die

  ask turtles  [die]

end

to year-end

  ask MHs [return]
  ask LU [return]

end






;
;       if(pplant = 0)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.15 set p_timberstock 0.1 set p_fwstock 0.1 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00012  * 50 ]if(pslope >= 15) [set  p_game 0.00015 * 50]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.15 set p_timberstock  0.25 set  p_fwstock 0.15 set  p_acornstock 0.25 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.0001 * 50 ]if(pslope >= 15) [set  p_game 0.0002 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.1 set p_timberstock 2.5 set  p_fwstock 0.3 set  p_acornstock 0.75 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.00024 * 50]if(pslope >= 15) [set  p_game 0.00015 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.05 set p_timberstock 0.1 set  p_fwstock 0.5 set  p_acornstock 0.75 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.00036 * 50]if(pslope >= 15) [set  p_game 0.0002 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.05 set p_timberstock 0.4 set  p_fwstock 0.75 set  p_acornstock 0.5 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00024 * 50]if(pslope >= 15) [set  p_game 0.0002 * 50]]
;    ]
;    if(pplant = 0.5)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.004 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00012 * 50]if(pslope >= 15) [set  p_game 0.0001 * 50]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.001 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.003 * 50 set p_fruitstock 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.00024  * 50]if(pslope >= 15) [set  p_game 0.0001 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.04 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00025 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00024 * 50]if(pslope >= 15) [set  p_game 0.00015 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.001 * 50 set  p_fwstock 0.008 * 50 set  p_acornstock 0.015 * 50 set p_fruitstock 0.0003 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00036 * 50]if(pslope >= 15) [set  p_game 0.0002 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.008 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00015 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00024 * 50]if(pslope >= 15) [set  p_game 0.0002 * 50]]
;    ]
;     if(pplant = 1)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.005 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 set p_paint 0 if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.0001 * 50]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.001 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.003 * 50 set p_fruitstock 0 set p_fish 0 set p_paint 0.2 * 50 if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.03 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00025 * 50  set p_fish 0 set p_paint 0.3 * 50 if(pslope <= 15) [set  p_game 0.00024 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.001 * 50 set  p_fwstock 0.008 * 50 set  p_acornstock 0.015 * 50 set p_fruitstock 0.0003 * 50 set p_fish 0 set p_paint 0.4 * 50 if(pslope <= 15) [set  p_game 0.00036 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00015 * 50 set p_fish 0 set p_paint 0.1 * 50 if(pslope <= 15) [set  p_game 0.00018 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;    ]
;    if(pplant = 1.5) ;;漆树
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_paint 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00012 ]if(pslope >= 15) [set  p_game 0.00012]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.003 * 50 set p_fruitstock 0 set p_paint 0.2 * 50 set p_fish 0    if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.03 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00025 * 50 set p_paint 0.3 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00024 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.005 * 50 set  p_fwstock 0.008 * 50 set  p_acornstock 0.015 * 50 set p_fruitstock 0.0003 * 50 set p_paint 0.4 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00036 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.00015 * 50 set p_paint 0.1 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00018 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;    ]
;    if(pplant = 2)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_paint 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.002 * 50 set p_fruitstock 0 set p_paint 0.2 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.03 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.007 * 50 set p_fruitstock 0.00025 * 50 set p_paint 0.3 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00024 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.01 * 50 set  p_fwstock 0.008 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0.0003 * 50 set p_paint 0.4 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00036 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.007 * 50 set p_fruitstock 0.00015 * 50 set p_paint 0.1 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00018 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;    ]
;    if(pplant = 3)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_paint 0 set p_fish 0  if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.0015 * 50 set p_fruitstock 0 set p_paint 0.2 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.03 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0.00025 * 50 set p_paint 0.3 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00024 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.02 * 50 set  p_fwstock 0.008 * 50  set  p_acornstock 0.005 * 50 set p_fruitstock 0.0003 * 50 set p_paint 0.4 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00036 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0.00015 * 50 set p_paint 0.1 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00018 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;    ]
;    if(pplant = 3.5)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.003 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.001 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0 if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.003 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.002 * 50 set  p_acornstock 0.0015 * 50 set p_fruitstock 0 set p_fish 0    if(pslope <= 15) [set  p_game 0.00012 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.002 * 50 set p_timberstock 0.02 * 50 set  p_fwstock 0.003 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0.00025 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00024 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.001 * 50 set p_timberstock 0.01 * 50 set  p_fwstock 0.004 * 50 set  p_acornstock 0.005 * 50 set p_fruitstock 0.0003 * 50 set p_fish 0  if(pslope <= 15) [set  p_game 0.00036 * 50 ]if(pslope >= 15) [set  p_game 0.00018 * 50]]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.001 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.01 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0.00015 * 50 set p_fish 0 if(pslope <= 15) [set  p_game 0.00018 * 50 ]if(pslope >= 15) [set  p_game 0.00012 * 50]]
;    ]
;    if(pplant = 4)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.0035 * 50 set p_timberstock 0.002 * 50 set p_fwstock 0.0015 * 50 set  p_acornstock 0 set p_fruitstock 0 set p_fish 0  set  p_game 0.00012 * 50]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.0035 * 50 set p_timberstock  0.005 * 50 set  p_fwstock 0.0025 * 50 set  p_acornstock 0.0025 * 50 set p_fruitstock 0 set p_fish 0   set  p_game 0.00018 * 50]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.0025 * 50 set p_timberstock 0.01 * 50 set  p_fwstock 0.005 * 50 set  p_acornstock 0.005 * 50 set p_fruitstock 0 set p_fish 0   set  p_game 0.00024 * 50]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.0015 * 50 set p_timberstock 0.00 * 50 set  p_fwstock 0.01 * 50 set  p_acornstock 0.01 * 50 set p_fruitstock 0 set p_fish 0   set  p_game 0.00036 * 50 ]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.0015 * 50 set p_timberstock 0.002 * 50 set  p_fwstock 0.015 * 50 set  p_acornstock 0.005 * 50 set p_fruitstock 0 set p_fish 0  set  p_game 0.00018 * 50]
;   ]
;    if(pplant = 5)
;    [
;      if pstandage > 0 and pstandage <= 10 [ set p_LUfodder 0.004 * 50 set p_timberstock 0.00 set p_fwstock 0.0015 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0  set  p_game 0.00012 * 50]
;      if pstandage > 10 and pstandage <= 25 [set p_LUfodder 0.004 * 50 set p_timberstock  0.00 set  p_fwstock 0.0025 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0   set  p_game 0.00018 * 50]
;      if pstandage > 25 and pstandage <= 70 [set p_LUfodder 0.003 * 50 set p_timberstock 0.00 set  p_fwstock 0.005 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0   set  p_game 0.00024 * 50 ]
;      if pstandage > 70 and pstandage <= 250 [set p_LUfodder 0.002 * 50 set p_timberstock 0.00 set  p_fwstock 0.01 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0   set  p_game 0.00036 * 50 ]
;      if pstandage > 250  and pstandage <= 500 [set p_LUfodder 0.002 * 50 set p_timberstock 0.00 set  p_fwstock 0.015 * 50 set  p_acornstock 0.000 set p_fruitstock 0 set p_fish 0  set  p_game 0.00018 * 50 ]
;    ]
;    if(psoiltype = 2);;浅水湿地
;    [
;       set p_LUfodder 0.003 set p_timberstock 0 set p_fwstock 0 set  p_acornstock 0 set p_fruitstock random 10 / 1000   set p_fish 0  set p_game 0.00012 * 50
;
;    ]
;    if(psoiltype = 3);;湿地(可能的湖泊河流)
;    [
;      set p_LUfodder 0 set p_timberstock 0 set p_fwstock 0.00 set  p_acornstock 0 set p_fruitstock 0 set p_fish  random-normal 4 1 / 100
;    ]
;    if(psoiltype = 4) ;;海洋
;    [
;       set p_fish  random-normal 5 2 / 10000 * 50
;    ]
;



;;给patches再设定一个标记属性，如果已经有海龟到达就不需要重复的海龟过来了

to simplify




  if time = "6900BP"

  [

  ;正式版， 根据具体涉足面积设定 xy的上下限
let x -200
let y -200

;x 530 y 320

crt 96 * 60



  ask turtles with [xcor = 0 and ycor = 0] [

    if  x <= 380  [
      if y <= 200  [
            let target-patch patch x y move-to  target-patch  ask patch-here [
	           set pn1 count patches with [pfield? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
          	 set pn2 count patches with [pfished? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
          	 set pn3 count patches with [p1gathered? = true or pgathered? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
          	 set pn4 count patches with [pfwcollected? = true or ptimbercollected? = true or ppaint? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
          	 set pn5 count patches with [phunted? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
             let n count patches with [phunted? = true or pfished? = true or  p1gathered? = true or pfwcollected? = true or pgathered? = true or ptimbercollected? = true or pfield? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
      if n >= 15 [set pside  4]
      if n >= 5 and n < 15 [set pside  3]   ;;这里的区分方式根据模型的结果进行修改
          if n < 5 and n >= 1[set pside  2]]

        set y y + 10
        if y > 200 [set y -200 set x x + 10]
      ]
    ]


  ]

  ]




  if time =  "6200BP"

  [
    ;正式版， 根据具体涉足面积设定 xy的上下限
let x -250
let y -300

;x 530 y 320

crt 96 * 60



  ask turtles with [xcor = 0 and ycor = 0] [

    if  x <= 400  [
      if y <= 200  [
            let target-patch patch x y move-to  target-patch  ask patch-here [
	           set pn1 count patches with [pfield? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
          	 set pn2 count patches with [pfished? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
          	 set pn3 count patches with [p1gathered? = true or pgathered? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
          	 set pn4 count patches with [pfwcollected? = true or ptimbercollected? = true or ppaint? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
          	 set pn5 count patches with [phunted? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
             let n count patches with [phunted? = true or pfished? = true or  p1gathered? = true or pfwcollected? = true or pgathered? = true or ptimbercollected? = true or pfield? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
      if n >= 15 [set pside  4]
      if n >= 5 and n < 15 [set pside  3]   ;;这里的区分方式根据模型的结果进行修改
          if n < 5 and n >= 1[set pside  2]]

        set y y + 10
        if y > 200 [set y -300 set x x + 10]
      ]
    ]


  ]

  ]



  if time = "5500BP"
  [

  ;正式版， 根据具体涉足面积设定 xy的上下限
let x -425
let y -275

;x 530 y 320

crt 96 * 60



  ask turtles with [xcor = 0 and ycor = 0] [

    if  x <= 530  [
      if y <= 320  [
            let target-patch patch x y move-to  target-patch  ask patch-here [
	           set pn1 count patches with [pfield? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
          	 set pn2 count patches with [pfished? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
          	 set pn3 count patches with [p1gathered? = true or pgathered? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
          	 set pn4 count patches with [pfwcollected? = true or ptimbercollected? = true or ppaint? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
          	 set pn5 count patches with [phunted? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
             let n count patches with [phunted? = true or pfished? = true or  p1gathered? = true or pfwcollected? = true or pgathered? = true or ptimbercollected? = true or pfield? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
      if n >= 15 [set pside  4]
      if n >= 5 and n < 15 [set pside  3]   ;;这里的区分方式根据模型的结果进行修改
          if n < 5 and n >= 1[set pside  2]]

        set y y + 10
        if y > 320 [set y -275 set x x + 10]
      ]
    ]


  ]

  ]



 ;;测试版本
;let x 0
;let y 0
;
;;x 530 y 320
;
;crt 100
;
;
;
;  ask turtles with [xcor = 0 and ycor = 0] [
;
;    if  x <= 100  [
;      if y <= 100  [
;            let target-patch patch x y move-to  target-patch  ask patch-here [
;	           set pn1 count patches with [pfield? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
;          	 set pn2 count patches with [pfished? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
;          	 set pn3 count patches with [p1gathered? = true or pgathered? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
;          	 set pn4 count patches with [pfwcollected? = true or ptimbercollected? = true or ppaint? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
;          	 set pn5 count patches with [phunted? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
;             let n count patches with [phunted? = true or pfished? = true or  p1gathered? = true or pfwcollected? = true or pgathered? = true or ptimbercollected? = true or pfield? = true and pxcor >= x - 5 and pxcor < x + 5 and pycor  >= y - 5 and pycor < y + 5]
;      if n >= 15 [set pside  4]
;      if n >= 5 and n < 15 [set pside  3]   ;;这里的区分方式根据模型的结果进行修改
;          if n < 5 and n >= 1[set pside  2]]
;
;        set y y + 10
;        if y > 100 [set y 0 set x x + 10]
;      ]
;    ]
;
;
;  ]







  ask turtles with [shape = "default"][

    ;直接用turtle来画图也是可以的，不在patch上输出而是显示出不同大小的turtle就可以了


	   ask patch-here [
      if psoiltype = 1 and pside = 4[
        if pn5 > 0 [sprout 1[set shape "square" set color red set size 8]]
        if pn4 > 0 [sprout 1[set shape "square" set color brown set size 6]]
        if pn3 > 0 [sprout 1[set shape "square" set color 135 set size 3]]]
      if psoiltype = 2 or psoiltype = 3 and pside = 4[
        if pn2 > 0 [sprout 1[set shape "square" set color 95 set size 8]]
        if pn3 > 0 [sprout 1[set shape "square" set color 135 set size 6]]
        if pn1 > 0 [sprout 1[set shape "square" set color yellow set size 3]]]

    ]


		ask patch-here [
      if psoiltype = 1 and pside = 3[
        if pn5 > 0 [sprout 1[set shape "square" set color red set size 6]]
        if pn4 > 0 [sprout 1[set shape "square" set color brown set size 4]]
        if pn3 > 0 [sprout 1[set shape "square" set color 135 set size 2]]]
      if psoiltype = 2 or psoiltype = 3 and pside = 3[
        if pn2 > 0 [sprout 1[set shape "square" set color 95 set size 6]]
        if pn3 > 0 [sprout 1[set shape "square" set color 135 set size 4]]
        if pn1 > 0 [sprout 1[set shape "square" set color yellow set size 2]]]

    ]

	  ask patch-here [
      if psoiltype = 1 and pside = 2[
        if pn5 > 0 [sprout 1[set shape "square" set color red set size 4]]
        if pn4 > 0 [sprout 1[set shape "square" set color brown set size 2]]
        if pn3 > 0 [sprout 1[set shape "square" set color 135 set size 1]]]
      if psoiltype = 2 or psoiltype = 3 and pside = 2[
        if pn2 > 0 [sprout 1[set shape "square" set color 95 set size 4]]
        if pn3 > 0 [sprout 1[set shape "square" set color 135 set size 2]]
        if pn1 > 0 [sprout 1[set shape "square" set color yellow set size 1]]]

    ]

  ]

   ask turtles with [shape != "square"] [die]


;         if n >= 5 and n < 10  	ask patch-here [sprout 1[set shape "square" set color red set size 50]]
;         if n < 5  	ask patch-here [sprout 1[set shape "square" set color red set size 20]]

 ;; 在patch中设定一个变量 pside 来存储一个区域的需要的边框大小，这个记得在patch中的属性中添加
;     ask patch-here [
;      if n >= 15 [set pside  4]
;      if n >= 5 and n < 15 [set pside  3]   ;;这里的区分方式根据模型的结果进行修改
;      if n < 5 and n >= 1[set pside  2]
;
;]
;
;  ]
;
;set a 0
;set b 0
;
;
;  loop [ifelse count patches with [pcame? = true] > 0[
;    ask patches with [pxcor = a  and pycor = b][set side pside  set n-1 pn1 set n-2 pn2 set n-3 pn3 set n-4 pn4 set n-5 pn5  set pcame?  false]
;        ask patches with [pxcor >= a - side and pxcor < a + side and pycor >= b - side and pycor < b + side and psoiltype = 1][
;      if n-5 > 0[set pcolor red]
;    ]
;        ask patches with [pxcor >= a - side + 1 and pxcor < a + side - 1 and pycor >= b - side + 1 and pycor < b + side - 1][
;      if n-4 > 0[set pcolor brown]
;    ]
;        ask patches with [pxcor >= a - side + 2 and pxcor < a + side - 2 and pycor >= b - side + 2 and pycor < b + side - 2][
;      if n-3 > 0[set pcolor green]
;    ]
;
;        ask patches with [pxcor >= a - side and pxcor < a + side and pycor >= b - side and pycor < b + side and psoiltype = 2 or psoiltype = 3][
;      if n-2 > 0[set pcolor black]
;    ]
;        ask patches with [pxcor >= a - side + 1 and pxcor < a + side - 1 and pycor >= b - side + 1 and pycor < b + side - 1][
;      if n-3 > 0[set pcolor green]
;    ]
;        ask patches with [pxcor >= a - side + 2 and pxcor < a + side - 2 and pycor >= b - side + 2 and pycor < b + side - 2][
;      if n-1 > 0[set pcolor yellow]
;    ]
;    if a <= 100 and b < 100 [set b b + 10]
;    if a < 100 and b = 100 [set a a + 10 set b 0]
;  ]
;    [stop]]






;    ask patches with [pcame? = true and psoiltype = 1]
;    [
;    let a pxcor
;    let b pycor
;    let n pside
;    let n-1 pn1
;    let n-2 pn2
;    let n-3 pn3
;    let n-4 pn4
;    let n-5 pn5
;    if n-5 > 0 [
;         ask patches with[pxcor >= a - n  and pxcor < a + n and pycor < b + n and pycor >= b - n and psoiltype = 1]
;      ;;如果有打猎足迹
;          [set pcolor red]
;    ]
;    if n-4 > 0[
;     ask patches with[pxcor >= a - n + 1  and pxcor < a + n - 1 and pycor < b + n - 1 and pycor >= b - n + 1 and psoiltype = 1]
;      ;;如果有木材相关的收集足迹
;          [set pcolor brown]
;    ]
;    if n-3 > 0[
;     ask patches with[pxcor >= a - n + 2 and pxcor < a + n  -  2 and pycor < b + n - 2 and pycor >= b - n + 2 and psoiltype = 1]
;      ;;如果有采集足迹
;        [set pcolor green]
;    ]
;
;
;;    这里是不是需要把判断放在patch选择上呢？
;;    在patch中调用patch是否有问题？
;
;  ]
;    ask patches with [pcame? = true and psoiltype = 2]
;    [
;    let a pxcor
;    let b pycor
;    let n pside
;    let n-1 pn1
;    let n-2 pn2
;    let n-3 pn3
;    let n-4 pn4
;    let n-5 pn5
;     ;;湿地部分
;    if n-2 > 0[
;     ask patches with[pxcor >= a - n  and pxcor < a + n and pycor < b + n and pycor >= b - n and psoiltype = 2]
;     ;;如果有捕鱼的足迹
;          [set pcolor black]
;     ]
;    if n-3 > 0[
;     ask patches with[pxcor >= a - n + 1  and pxcor < a + n - 1  and pycor < b + n - 1 and pycor >= b - n + 1 and psoiltype = 2]
;     ;;如果有采集的足迹
;          [set pcolor green]
;     ]
;    if n-1 > 0[
;     ask patches with[pxcor >= a - n + 2 and pxcor < a + n  - 2 and pycor < b + n - 2 and pycor >= b - n + 2 and psoiltype = 1]
;      ;;如果有水稻种植
;          [set pcolor yellow]
;     ]
;
;
;    ]


  ;;实在不行就用全局变量来存储数据 然后用循环来做

 ; ask turtles [die]

end

to simplify-map

  ask patches with [psoiltype = 1][set pcolor 8]
  ask patches with [psoiltype = 2 or psoiltype = 3][set pcolor white]

end

to separetesites
               crt 1
  ask turtles with [shape = "default"]  [
;1
              ask patches with [phunted? = true and psite1 = true][sprout 1[set shape "circle" set color 135 set size 3.5] ]
              ask patches with [pfished? = true and psite1 = true][sprout 1[set shape "square" set color 135 set size 3.5] ]
              ask patches with [ppaint? = true or pfwcollected? = true or ptimbercollected? = true and psite1 = true][sprout 1[set shape "triangle" set color 135 set size 3.5] ]
              ask patches with [p1gathered? = true or pgathered? = true and psite1 = true][sprout 1[set shape "pentagon" set color 135 set size 3.5] ]

;2
              ask patches with [phunted? = true and psite2 = true][sprout 1[set shape "circle" set color 125 set size 3.5] ]
              ask patches with [pfished? = true and psite2 = true][sprout 1[set shape "square" set color 125 set size 3.5] ]
              ask patches with [ppaint? = true or pfwcollected? = true or ptimbercollected? = true and psite2 = true][sprout 1[set shape "triangle" set color 125 set size 3.5] ]
              ask patches with [p1gathered? = true or pgathered? = true and psite2 = true][sprout 1[set shape "pentagon" set color 125 set size 3.5] ]

;3
              ask patches with [phunted? = true and psite3 = true][sprout 1[set shape "circle" set color 115 set size 3.5] ]
              ask patches with [pfished? = true and psite3 = true][sprout 1[set shape "square" set color 115 set size 3.5] ]
              ask patches with [ppaint? = true or pfwcollected? = true or ptimbercollected? = true and psite3 = true][sprout 1[set shape "triangle" set color 115 set size 3.5] ]
              ask patches with [p1gathered? = true or pgathered? = true and psite3 = true][sprout 1[set shape "pentagon" set color 115 set size 3.5] ]

;4
              ask patches with [phunted? = true and psite4 = true][sprout 1[set shape "circle" set color 15 set size 3.5] ]
              ask patches with [pfished? = true and psite4 = true][sprout 1[set shape "square" set color 15 set size 3.5] ]
              ask patches with [ppaint? = true or pfwcollected? = true or ptimbercollected? = true and psite4 = true][sprout 1[set shape "triangle" set color 15 set size 3.5] ]
              ask patches with [p1gathered? = true or pgathered? = true and psite4 = true][sprout 1[set shape "pentagon" set color 15 set size 3.5] ]

;5
              ask patches with [phunted? = true and psite5 = true][sprout 1[set shape "circle" set color 45 set size 3.5] ]
              ask patches with [pfished? = true and psite5 = true][sprout 1[set shape "square" set color 45 set size 3.5] ]
              ask patches with [ppaint? = true or pfwcollected? = true or ptimbercollected? = true and psite5 = true][sprout 1[set shape "triangle" set color 45 set size 3.5] ]
              ask patches with [p1gathered? = true or pgathered? = true and psite5 = true][sprout 1[set shape "pentagon" set color 45 set size 3.5] ]

;6
              ask patches with [phunted? = true and psite6 = true][sprout 1[set shape "circle" set color 65 set size 3.5] ]
              ask patches with [pfished? = true and psite6 = true][sprout 1[set shape "square" set color 65 set size 3.5] ]
              ask patches with [ppaint? = true or pfwcollected? = true and ptimbercollected? = true and psite6 = true][sprout 1[set shape "triangle" set color 65 set size 3.5] ]
              ask patches with [p1gathered? = true or pgathered? = true and psite6 = true][sprout 1[set shape "pentagon" set color 65 set size 3.5] ]
]

  ask turtles with [shape = "default"] [die]
end



to count_square

set area_strong  count patches with [pside = 4]
set area_middle count patches with [pside = 3]
set area_weak count patches with [pside = 2]
set area_all count patches with [pside != 0]

end



to show-dots_simple

  if count settlements = 0 [  create-settlements 1 [setxy 0 0  set size 2]]
  ask one-of settlements
  [
   ;[ask max-n-of (10 * sqrt count patches with [phunted? = true]) patches with [phunted? = true][distance myself] [sprout 1[set shape "red_dot" set color red set size 1.5]]]; ;


    ask n-of (count patches with [phunted? = true]  ) patches with [phunted? = true]   [sprout 1[set shape "dot" set color red set size 4.5]]
    ask n-of (count patches with [pfished? = true ] ) patches with [pfished? = true ] [sprout 1 [set shape "dot"set color 100 set size 4.5]]
    ask n-of (count patches with [p1gathered? = true] ) patches with [p1gathered? = true ] [sprout 1 [set shape "dot" set color 100 set size 4.5]]
    ask n-of (count patches with [ppaint? = true ]  ) patches with [ppaint? = true ] [sprout 1 [set shape "triangle"set color white set size 4.5]]
    ask n-of (count patches with [pfwcollected? = true] ) patches with [pfwcollected? = true] [sprout 1 [set shape "triangle" set color white set size 4.5]]
    ask n-of (count patches with [pbrowsed? = true]) patches with [pbrowsed? = true] [sprout 1 [set shape "dot" set color white set size 4.5]]
    ask n-of (count patches with [pgathered? = true] ) patches with [pgathered? = true ] [sprout 1 [set shape "dot" set color 100 set size 3.5]]
    ask n-of (count patches with [ptimbercollected? = true] ) patches with [ptimbercollected? = true ] [sprout 1 [set shape "triangle" set color white set size 4.5]]
    ask n-of (count patches with [pfield? = true]  ) patches with [pfield? = true] [sprout 1 [set shape "square" set color yellow set size 5.5]]
    ; ask one-of settlements [ask patch-here [sprout 1 [set shape "circle" set color 0 set size 10.5]]]

  ]
end


to back-map

   setup-patches
   init-gis

end
@#$#@#$#@
GRAPHICS-WINDOW
591
10
2200
820
-1
-1
1.0
1
10
1
1
1
0
1
1
1
-800
800
-400
400
0
0
1
ticks
30.0

BUTTON
421
349
484
382
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
48
315
117
348
NIL
SETUP
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
30
106
168
151
time
time
"5500BP" "6200BP" "6900BP"
1

INPUTBOX
378
115
533
175
households
25.0
1
0
Number

BUTTON
392
284
512
317
NIL
GET-LOCATION\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
239
350
314
383
NIL
GET-TC\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
30
185
168
230
area
area
"tianluoshan" "hemudu" "zishan" "fujiashan" "tongjiaao" "jingtoushan" "all-hemudu"
6

CHOOSER
214
61
352
106
Location6900
Location6900
"1" "2" "3" "4" "5" "6"
5

BUTTON
226
283
338
316
NIL
CHOOSE-SITE
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
32
485
122
530
area-hunting
count patches with [phunted? = true]
17
1
11

MONITOR
148
488
238
533
area-fishing
count patches with[pfished? = true]
17
1
11

MONITOR
32
425
110
470
area-field
count patches with [pfield? = true]
17
1
11

MONITOR
133
426
236
471
area-gathering
count patches with [pgathered? = true]
17
1
11

MONITOR
261
426
364
471
area-browsing
count patches with [pbrowsed? = true]
17
1
11

MONITOR
406
427
484
472
area-fruit
count patches with [p1gathered? = true]
17
1
11

MONITOR
262
486
391
531
area-fwcollecting
count patches with [pfwcollected? = true]
17
1
11

MONITOR
406
487
555
532
area-timbercollecting
count patches with [ptimbercollected? = true]
17
1
11

MONITOR
29
546
126
591
area-getpaint
count patches with [ppaint? = true]
17
1
11

CHOOSER
215
114
353
159
Location6200
Location6200
"1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18"
17

CHOOSER
211
182
349
227
Location5500
Location5500
"1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30"
0

BUTTON
34
697
176
730
NIL
show-areahunt
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
202
699
344
732
NIL
show-areagather\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
357
701
484
734
NIL
show-areafish
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
157
773
240
806
NIL
all-die
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
5
770
154
803
NIL
show-dots_simple\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
30
41
168
86
to-open
to-open
"yes" "no"
0

MONITOR
383
41
440
86
年
year
17
1
11

BUTTON
258
773
348
806
NIL
simplify
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
364
774
484
807
NIL
simplify-map
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
36
832
163
865
NIL
separetesites
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
175
831
295
864
NIL
count_square
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
37
606
134
651
 area_strong 
area_strong
17
1
11

MONITOR
155
607
245
652
 area_middle
area_middle
17
1
11

MONITOR
265
608
343
653
 area_weak
area_weak
17
1
11

MONITOR
364
610
429
655
area_all
area_all
17
1
11

BUTTON
332
830
422
863
NIL
back-map
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
