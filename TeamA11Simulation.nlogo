turtles-own
  [ sick?                ;; if true, the turtle is infectious
    my-chance-recover    ;; if old? is chnance-recover-elders else chance-recover
    remaining-immunity   ;; how many days of immunity the turtle has left
    sick-time            ;; how long, in minutes, the turtle has been infectious
    age                  ;; how many days old the turtle is
    minutesinroom         ;; time in a room
    contagionperday      ;; If you are an infected person, you can infect 9 people per day
    minsofexposure        ;; minutes exposed to the virus per day
    facemasks            ;; degree of exposure by mask
    disinfection         ;; degree of exposure by disinfection
    vaccinedoses           ;; number of doses vaccinated
    daysvaccineeffectiveness       ;;days to reach vaccine effectiveness

    area                 ; which area the turtle is currently in
    bedroom              ; which bedroom this turtle owns
    reacheddestination
    destination

]
patches-own
[
  wall  ;;wall
  salon ;; lounge
  room  ;; what room it is
  owner ;; which turtle owns the room
]

globals
  [ %infected            ;; what % of the population is infectious
    %immune              ;; what % of the population is immune
    lifespan             ;; the lifespan of a turtle
    immunity-duration    ;; how many days immunity lasts
    ended-simulation?    ; if the simulation is ended because no one is sick
    hours
    minutes                   ; 8 hours a day are assumed in the flat
    totalcontagionsperday    ;; contagion counter per day
    contagionsforplot    ;; for the plot
    dosefrequency
    deaths
]

;; The setup is divided into procedures
to setup
  clear-all
  setup-labels
  setup-patches
  setup-constants
  setup-turtles
  setup-bedrooms
  setup-walls
  update-global-variables
  update-display
  reset-ticks
end


to setup-bedrooms
  let sorted-turtles sort turtles
  foreach sorted-turtles [
    x -> ask x [ ; x is the turtle
      set bedroom ( word "bedroom" (who + 1) ) ;sets each turtle's bedroom as bedroom + turtle's id number
    ]
  ]
end

to setup-labels

    ;Labels
  ask patch 35 65[
    set plabel-color white
    set plabel "Bedroom 1"
  ]
  ask patch 95 65[
    set plabel-color black
    set plabel "Kitchen"
  ]
  ask patch 77 43[
    set plabel-color white
    set plabel "Corridor"
  ]
   ask patch 35 20[
    set plabel-color white
    set plabel "Living Room"
  ]
   ask patch 71 20[
    set plabel-color white
    set plabel "Toilet"
  ]
   ask patch 115 20[
    set plabel-color white
    set plabel "Bedroom 2"
  ]
    ask patch 165 65[
    set plabel-color white
    set plabel "Bedroom 3"
  ]

    ask patch 165 20[
    set plabel-color black
    set plabel "Bedroom 4"
  ]

end

to setup-patches

  set-default-shape turtles "person"

  ask patches with [pxcor < 71 and pycor < 79 and pxcor > 0 and pycor > 50] [
    set room "bedroom1"
    set pcolor gray
    set owner turtle 0
    set salon true
  ]

  ask patches with [pxcor < 112 and pycor < 79 and pxcor > 71 and pycor > 50] [
    set room "kitchen"
    set pcolor yellow
    set owner "public"
    set salon true
  ]

  ask patches with [pxcor < 176 and pycor < 50 and pxcor > 0 and pycor > 36] [
    set room "corridor"
    set pcolor white
    set owner "public"
  ]

  ask patches with [pxcor < 132 and pycor < 79 and pxcor > 112 and pycor > 49] [
    set room "corridor"
    set pcolor white
    set owner "public"
  ]

  ask patches with [pxcor < 50 and pycor < 36 and pxcor > 0 and pycor > 0] [
    set room "living room"
    set pcolor orange
    set owner "public"
    set salon true
  ]

  ask patches with [pxcor > 50 and pxcor < 82 and pycor < 36 and pycor > 0] [
    set room "bathroom"
    set pcolor blue
    set owner "public"
    set salon true
  ]

  ask patches with [pxcor < 132 and pycor < 36 and pxcor > 82 and pycor > 0] [
    set room "bedroom2"
    set pcolor violet
    set owner turtle 1
    set salon true
  ]

  ask patches with [pxcor < 176 and pycor < 36 and pxcor > 132 and pycor > 0] [
    set room "bedroom4"
    set pcolor cyan
    set owner turtle 1
    set salon true
  ]

  ask patches with [pxcor < 176 and pycor < 80 and pxcor > 132 and pycor > 50] [
    set room "bedroom3"
    set pcolor pink
    set owner turtle 1
    set salon true
  ]

end

to setup-walls

  ask patches with [pxcor <= 130 and pxcor >= 0 and pycor = 79]
    [set pcolor brown set wall true]
  ask patches with [pxcor <= 132 and pxcor >= 130 and pycor = 79]
    [set pcolor brown set wall true]
  ask patches with [pycor <= 79 and pycor >= 50 and pxcor = 132]
    [set pcolor brown set wall true]
  ask patches with [pycor <= 35 and pycor >= 0 and pxcor = 132]
    [set pcolor brown set wall true]
  ask patches with [pycor <= 79 and pycor >= 0 and pxcor = 0]
    [set pcolor brown set wall true]

  ask patches with [pxcor <= 175 and pxcor >= 0 and pycor = 0]
    [set pcolor brown set wall true]
  ask patches with [pxcor <= 132 and pxcor >= 44 and pycor = 0]
    [set pcolor brown set wall true]
  ask patches with [pxcor <= 112 and pxcor >= 109 and pycor = 50]
    [set pcolor brown set wall true]
  ask patches with [pxcor <= 49 and pxcor >= 0 and pycor = 50]
    [set pcolor brown set wall true]
  ask patches with [pxcor <= 85 and pxcor >= 80 and pycor = 36]
    [set pcolor brown set wall true]
  ask patches with [pxcor <= 85 and pxcor >= 80 and pycor = 36]
    [set pcolor brown set wall true]
  ask patches with [pxcor <= 70 and pxcor >= 0 and pycor = 36]
    [set pcolor brown set wall true]
  ask patches with [pxcor <= 132 and pxcor >= 94 and pycor = 36]
    [set pcolor brown set wall true]

  ask patches with [pycor <= 79 and pycor >= 50 and pxcor = 71]
    [set pcolor brown set wall true]
  ask patches with [pycor <= 79 and pycor >= 50 and pxcor = 112]
    [set pcolor brown set wall true]
  ask patches with [pycor <= 36 and pycor >= 0 and pxcor = 82]
    [set pcolor brown set wall true]
  ask patches with [pycor <= 36 and pycor >= 0 and pxcor = 50]
    [set pcolor brown set wall true]
  ask patches with [pxcor <= 99 and pxcor >= 59 and pycor = 50]
    [set pcolor brown set wall true]

  ask patches with [pxcor >= 133 and pycor = 79 and pxcor <= 175]
    [set pcolor brown set wall true]
  ask patches with [pxcor >= 133 and pycor = 50 and pxcor <= 140]
    [set pcolor brown set wall true]
  ask patches with [pxcor >= 150 and pycor = 50 and pxcor <= 175]
    [set pcolor brown set wall true]
  ask patches with [pycor < 80 and pycor >= 0 and pxcor = 176]
    [set pcolor brown set wall true]
  ask patches with [pycor < 80 and pycor >= 0 and pxcor = 176]
    [set pcolor brown set wall true]
  ask patches with [pxcor <= 175 and pxcor >= 150 and pycor = 36]
    [set pcolor brown set wall true]
  ask patches with [pxcor <= 140 and pxcor >= 132 and pycor = 36]
    [set pcolor brown set wall true]

  ask patches with [pxcor <= 40 and pxcor >= 30 and pycor = 36]
    [set pcolor black set wall false]

end



;; We create a variable number of turtles of which 10 are infectious,
;; and distribute them randomly
to setup-turtles
    create-turtles initial-number-people
    [ ;;setxy random-xcor random-ycor
      setxy 1 + random 122 37 + random 13
      set age random lifespan

      ;;ifelse age > 365 * 60 [ set old? true ] [ set old? false ]
      set sick-time 0
      set remaining-immunity 0
      set facemasks (1)
      set disinfection 1
      set size 9  ;; easier to see
      get-healthy
      set vaccinedoses 0 ;; 0 dosis de vaccinedoses
      set reacheddestination false

       ]
  ask n-of ((use_mask * count turtles ) / 100) turtles [
    set facemasks  (0.05) ;; risk is low
  ]

  ask n-of ((use_disinfectant * count turtles ) / 100) turtles [
    set disinfection  (0.05) ;; risk is low
  ]

  ask n-of ((10 * count turtles ) / 100) turtles [
    set vaccinedoses vaccinedoses + 1 ;; 10% of tenants with the first dose
  ]

  ask n-of 1 turtles
    [ get-sick ]
end


to get-sick ;; turtle procedure
  set sick? true
  set remaining-immunity 0
  set totalcontagionsperday totalcontagionsperday + 1
end

to get-healthy ;; turtle procedure
  set sick? false
  set remaining-immunity 0
  set sick-time 0

end

to become-immune ;; turtle procedure
  set sick? false
  set sick-time 0
  set remaining-immunity immunity-duration
end

;; This sets up basic constants of the model.
to setup-constants
  set lifespan 90 * 365      ;; 90 times 365 days = 50 years = 32850 days old
  ;;set immunity-duration 260  ;; this value is approximated for the sake of testing, not based in scientific knowledge.
  set immunity-duration 213   ;; By the end of the exercise, two months of immunity were left
  set ended-simulation? false
  set dosefrequency 7
end

to go
  if not ended-simulation?
  [ set minutes minutes + 1;
    ask turtles [
      set label ""
    ifelse (who >= 0 and who <= 3)
    [

       set label word "Tenant" (who + 1)

    ]
    [

      set label "visitor"
    ]
     set label-color black
     get-older


      ifelse reacheddestination
      [ set destination choose-destination
        move ]
      [ move ]


     if sick? [ recover-or-die ]
     if sick? and contagionperday < 9 [infect ]   ;; People you can infect in a day

  ]


   update-display
   if minutes mod 480 = 0 [  ;; Yes (8*60min), 8 hours a day are assumed at the flat
      reset   ;; restart time in room and number of people infected per day
      update-global-variables
      if vaccination[vaccinate]

      ]
   tick
  ]
end

to-report choose-destination
  let roomDestination random 5 ;; which room they decide to move to
  let destinationpatch one-of patches with [pcolor = white]
  if roomDestination = 0 [set destination one-of patches with [pcolor = orange]]
  if roomDestination = 1 [set destination one-of patches with [pcolor = blue]]
  if roomDestination = 2 [set destination one-of patches with [pcolor = yellow]]
  if roomDestination = 3 [set destination one-of patches with [pcolor = grey]]
  if roomDestination = 4 [set destination one-of patches with [pcolor = violet]]
  print ([pcolor] of destination)
  report destination
end

to update-global-variables
  if count turtles > 0
    [ set %infected (count turtles with [ sick? ] / count turtles) * 100
      set %immune (count turtles with [ immune? ] / count turtles) * 100
      set ended-simulation? %infected = 0
      set contagionsforplot totalcontagionsperday
      set totalcontagionsperday 0
  ] ;;the simulation ends when no turtles are infected
end

to update-display
  ask turtles
    [
      set color ifelse-value sick? [ red ] [ ifelse-value immune? [ grey ] [ green ] ] ]
end

;;Turtle counting variables are advanced.
to get-older ;; turtle procedure
  ;;ifelse age > lifespan [ die ] [if age > 60 * 360 [ set old? true ] ]
  if immune? [ set remaining-immunity remaining-immunity - 1 ]
  if sick? [ set sick-time sick-time + 1 ]
  if vaccinedoses > 0 [set daysvaccineeffectiveness daysvaccineeffectiveness + 1]
end

to move ;; turtle procedure

;ask self [
;    let localdestination destination
;  ]
;
;    ifelse patch-ahead 1 != nobody
;      [ ifelse ([wall] of patch-ahead 1) = true  ;;if a wall
;      [rt random 180 fd 1] ;; Random turn and move forward 180 and turn again
;
;        ; [ifelse [ destination ] of patch-here = true ;; if it is in the destination
;          [ifelse destination = patch-here;; if it is in the destination
;          [
;            set reacheddestination true
;            doactivity
;          ]
;          [ ifelse [wall] of patch-ahead 1 = true ;; if there is a wall ahead
;            [rt random 180] ;; rotate 180 degrees
;            [ ifelse pxcor + 1 > 175 or pxcor - 1 < 0 or pycor + 1 > 79 or pycor - 1 < 0 or [wall] of patch-right-and-ahead 90 1 = true or [wall] of patch-right-and-ahead -90 1 = true
;              [rt random 180] ;; Rotate 180 degrees if you reach the boundaries of the area or there is a wall to the right or left
;              [fd 1]
;            ]
;      ]
;  ]]

;    [
;      rt random 100
;      lt random 100
;      ;; if a wall
;
;      rt random 360  ;; Rotate in case of error
;      fd 1
;    ]



  rt random 100
  lt random 100
  ;; Si es una pared
 ifelse patch-ahead 1 != nobody
  [    ifelse ([wall] of patch-ahead 1) = true  ;; if it's a wall
    [rt 180 fd 1] ;; random turn and move forward 180 turn
    [      ifelse [salon] of patch-here = true ;; If you are in a room
      [doactivity]
      [        ifelse [wall] of patch-ahead 1 = true ;; If there is a wall ahead
       [rt 180] ;; rotate 180 degrees
        [          ifelse pxcor + 1 > 175 or pxcor - 1 < 0 or pycor + 1 > 79 or pycor - 1 < 0 or [wall] of patch-right-and-ahead 90 1 = true or [wall] of patch-right-and-ahead -90 1 = true
          [rt 180] ;; turn 180 degrees if you reach the boundaries of the area or there is a wall to the right or left
          [fd 1]
        ]

    ]]


  ]


  [rt random 360 ] ;; rotate on error
  ;;check if turtle is owner of the bedroom1 if not it does a 180 and randomly roams the corridor
   if ([room] of patch-ahead 2) = "bedroom1" ;; Si hay una pared adelante
  [
  ifelse (check-if-can-enter-bedroom "bedroom1") = true[
 ; print (word "Turtle " (who + 1) " is in " bedroom)
    ][rt 180]]
   ;;check if turtle is owner of the bedroom2 if not it does a 180 and randomly roams the corridor
    if ([room] of patch-ahead 2) = "bedroom2" ;; Si hay una pared adelante
  [
  ifelse (check-if-can-enter-bedroom "bedroom2") = true[
 ; print (word "Turtle " (who + 1) " is in " bedroom)
    ][rt 180]]

     if ([room] of patch-ahead 2) = "bedroom3" ;; Si hay una pared adelante
  [
  ifelse (check-if-can-enter-bedroom "bedroom3") = true[
 ; print (word "Turtle " (who + 1) " is in " bedroom)
    ][rt 180]]

     if ([room] of patch-ahead 2) = "bedroom4" ;; Si hay una pared adelante
  [
  ifelse (check-if-can-enter-bedroom "bedroom4") = true[
 ; print (word "Turtle " (who + 1) " is in " bedroom)
    ][rt 180]]

 ;;check if turtle is in bathroom if not it can go in
    if ([room] of patch-ahead 1) = "bathroom" and  (check-if-can-enter-room "bathroom") = true[
 ; print (word "Turtle " (who + 1) check-if-can-enter-room "bathroom")
  ]
   ;;check if turtle is in bathroom if it is in it doesnt go in
      if ([room] of patch-ahead 4) = "bathroom" and ([room] of patch-here) != "bathroom" and check-if-can-enter-room "bathroom" = false [rt 190 ]
end


to vaccinate

  ask n-of ((advance_vaccination * count turtles ) / 100) turtles  [
    if daysvaccineeffectiveness = 0 [set vaccinedoses vaccinedoses + 1]
    if daysvaccineeffectiveness > 60 * 8 * (dosefrequency) and daysvaccineeffectiveness < 60 * 8 * (dosefrequency * 2) [set vaccinedoses 2 ]      ;;time between doses (15 days)
    if daysvaccineeffectiveness > 60 * 8 * (dosefrequency * 2) and daysvaccineeffectiveness < 60 * 8 * (dosefrequency * 3) [set vaccinedoses 3 ]      ;;time between doses (15 days)
  ]

end


to doactivity ;; procedure
  set minutesinroom minutesinroom + 1
  if (minutesinroom > 120)[set minutesinroom -120] ;;time out of room
  ifelse (minutesinroom < 120 and minutesinroom > 0 ) [fd 0 ][ fd 1]
end

to reset

  ask turtles [set minutesinroom  0  set contagionperday  0  set minsofexposure 0 ]
  ask n-of ((use_mask * count turtles ) / 100) turtles [
    set facemasks  (0.1)
  ]

  ask n-of ((use_disinfectant * count turtles ) / 100) turtles [
    set facemasks  (0.1)
  ]

  ask n-of (((100 - use_mask) * count turtles ) / 100) turtles [
    set facemasks  (1)
  ]

  ask n-of (((100 - use_disinfectant) * count turtles ) / 100) turtles [
    set disinfection  (1)
  ]

end

to-report count-turtles-in-bathroom
  report count turtles-on (patches with [pcolor = blue])
end

to-report count-turtles-in-kitchen
  report count turtles-on (patches with [pcolor = yellow])
end

to-report count-turtles-in-living-room
  report count turtles-on (patches with [pcolor = red])
end

to-report check-if-can-enter-room [room-name]
  if room-name = "bathroom" [
    ifelse count-turtles-in-bathroom >= 1
      [ report FALSE ]
      [ report TRUE ]
  ]
  if room-name = "kitchen" [
    ifelse count-turtles-in-kitchen >= 2
      [ report FALSE ]
      [ report TRUE ]
  ]
  if room-name = "living-room" [
    ifelse count-turtles-in-living-room >= 3
      [ report FALSE ]
      [ report TRUE ]
  ]
end

to-report check-if-can-enter-bedroom [bedroom-id]
  ; "bedroom-id" is the bedroom "name" passed into the function, whereas "bedroom" is a variable that belongs to turtles, and it signifies the turtle's bedroom
  if bedroom-id = "bedroom0" [
      ifelse bedroom = "bedroom0"
        [ report TRUE ]
        [ report FALSE ]
  ]
  if bedroom-id = "bedroom1" [
      ifelse bedroom = "bedroom1"
        [ report TRUE ]
        [ report FALSE ]
  ]
  if bedroom-id = "bedroom2" [
      ifelse bedroom = "bedroom2"
        [ report TRUE ]
        [ report FALSE ]
  ]
  if bedroom-id = "bedroom3" [
      ifelse bedroom = "bedroom3"
        [ report TRUE ]
        [ report FALSE ]
  ]
  if bedroom-id = "bedroom4" [
      ifelse bedroom = "bedroom4"
        [ report TRUE ]
        [ report FALSE ]
  ]
end

;; If a turtle is sick, it infects other turtles on the same patch.
;; Immune turtles don't get sick.
to infect ;; turtle procedure

  ask other turtles in-radius 4 with [ not sick? and not immune? ] [

     if (random-float 100 < infectiousness )

      [ get-infected
        get-sick ]

    ;; otherwise does not get infected

  ]

end

to get-infected
;;example
   ;; face mask = 0.1 -> the risk is lower because you wear a face mask
   ;; disinfection = 1.0 -> low risk because it is disinfected
   ;; vaccine = 2 -> 2nd dose
   ;; minexposure = ((0.1)*(0.7) + (1)(0.3))*(1-(0.4))
   ;; minexposure = ((0.1)*(0.7) + (1)(0.3))*(0.6)) ->>>>> 0.2222

 set minsofexposure  minsofexposure  + ((facemasks * (0.6) + disinfection * (0.2) * ((1 - (vaccinedoses / 10) * 2) )   ))   ;; Infection without a mask is more likely than hand washing, the probability decreases with vaccine doses
  if minsofexposure  > 20 [get-sick  set contagionperday contagionperday + 1 ]  ;;Enough minutes of daily exposure to become infected

end


;; Once the turtle has been sick long enough, it
;; either recovers (and becomes immune) or it dies.
to recover-or-die ;; turtle procedure
  ;;ifelse old? [ set my-chance-recover chance-recover-elders ] [ set my-chance-recover chance-recover ]
  let chanceofrecovery random 100
  if sick-time > duration *  480                        ;; If the turtle has survived past the virus' duration, then
    [ ifelse chanceofrecovery > 10 ;; mortality chance
       [ become-immune ]
      [ die set deaths deaths + 1 ]
  ]
end

to-report immune?
  report remaining-immunity > 0
end

to startup
  setup-constants
end
@#$#@#$#@
GRAPHICS-WINDOW
465
10
953
283
-1
-1
2.2642
1
10
1
1
1
0
1
1
1
-16
195
-16
100
0
0
1
minutos
30.0

SLIDER
40
210
234
243
duration
duration
0.0
99.0
30.0
1.0
1
days
HORIZONTAL

SLIDER
40
167
234
200
infectiousness
infectiousness
0.0
100.0
100.0
1.0
1
%
HORIZONTAL

BUTTON
62
48
132
83
NIL
setup
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
138
48
209
84
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
276
336
771
500
Population
days
people
0.0
52.0
0.0
15.0
true
true
"" ""
PENS
"sick" 1.0 0 -2674135 true "" "plot count turtles with [ sick? ]"
"immune" 1.0 0 -7500403 true "" "plot count turtles with [ immune? ]"
"healthy" 1.0 0 -10899396 true "" "plot count turtles with [ not sick? and not immune? ]"

SLIDER
40
100
297
133
initial-number-people
initial-number-people
2
12
5.0
1
1
tenants
HORIZONTAL

MONITOR
280
281
355
326
NIL
%infected
1
1
11

MONITOR
357
281
431
326
NIL
%immune
1
1
11

MONITOR
465
281
539
326
days
ticks / (60 * 8)
1
1
11

MONITOR
564
282
676
327
current population
count turtles
17
1
11

TEXTBOX
30
10
407
35
GCU Team A-11 2022/23 Covid-19 virus simulator
15
105.0
1

PLOT
797
345
1189
495
Infections per day
minutes elapsed
infections per day
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"infections" 1.0 0 -2674135 true "" "plot contagionsforplot"

MONITOR
722
284
795
329
Infected
count turtles with [ sick? ]
17
1
11

MONITOR
837
284
911
329
infections
totalcontagionsperday
17
1
11

SLIDER
36
271
242
304
use_mask
use_mask
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
37
326
209
359
use_disinfectant
use_disinfectant
0
100
50.0
1
1
NIL
HORIZONTAL

SLIDER
35
384
212
417
advance_vaccination
advance_vaccination
0
100
25.0
1
1
%
HORIZONTAL

PLOT
391
533
766
683
Vaccinations
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"1st dose" 1.0 0 -7500403 true "" "plot count turtles with [ vaccinedoses = 1 ]"
"2nd dose" 1.0 0 -2674135 true "" "plot count turtles with [ vaccinedoses = 2]"
"3rd dose" 1.0 0 -955883 true "" "plot count turtles with [ vaccinedoses = 3]"

SWITCH
58
432
185
465
vaccination
vaccination
0
1
-1000

PLOT
813
536
1013
686
Deaths
time
deaths
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"deaths" 1.0 0 -16777216 true "" "plot (initial-number-people - count turtles)"

@#$#@#$#@
## WHAT IS IT?

This model was developed by Team A11 of Glasgow Caledonian University as part of AI 22/23 module. It is an enhanced version of the Virus model in the NetLogo library, which was originally created by Maite Lopez-Sanchez of the Universitat de Barcelona and published by Wilensky in 1998 at the Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL. The model simulates the spread of Covid-19 in a four-bedroom apartment and allows for modification of factors such as infectiousness and vaccination status to observe the impact on different scenarios.

## CREDITS AND REFERENCES

This model is an adaptation by Maite Lopez-Sanchez (Universitat de Barcelona) of the Virus model from the NetLogo library.  Wilensky, U. (1998). http://ccl.northwestern.edu/netlogo/models/Virus.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.


## HOW TO CITE

Please cite the NetLogo software as:
* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.
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

person farmer
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 60 195 90 210 114 154 120 195 180 195 187 157 210 210 240 195 195 90 165 90 150 105 150 150 135 90 105 90
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -13345367 true false 120 90 120 180 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 180 90 172 89 165 135 135 135 127 90
Polygon -6459832 true false 116 4 113 21 71 33 71 40 109 48 117 34 144 27 180 26 188 36 224 23 222 14 178 16 167 0
Line -16777216 false 225 90 270 90
Line -16777216 false 225 15 225 90
Line -16777216 false 270 15 270 90
Line -16777216 false 247 15 247 90
Rectangle -6459832 true false 240 90 255 300

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
