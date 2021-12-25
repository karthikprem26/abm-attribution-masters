;Project : Simulating Data for Multi-Touch Attribution

extensions [csv]

;; Global/Environmental Variable Declaration
globals [
  conversion-threshold ;; threshold to cross for conversion
  raw-logs ;; logs variable to capture data
  customer-details ;; variable to log customer
  channel-visibility ;; chances of viewing advert for each channel
  channel-list ;; list of channel-names (string)
]
;; Creating agent breeds for hoarding-channel and for people
breed [people person]
breed [hoarding-group hoarding-ind]

;; assigning properties to people breed
people-own[
  desc ;; string describing segment
  income ;; purchase will be according to income group
  gender ;; purchase wil vary  according to gender
  purchase-no ;; number of purchases for the person, purchase amount can be calculated by product amount into number of purchases
  conversion-value ;; threshold needed to cross before conversion can occur

  ;; access to each channel (flag)
  instagram?
  facebook?
  twitter?
  youtube?
  email?
  third-party?
  search?
  radio?
  tv?
  printed?



  ;; time of day for channel used
  instagram-use
  facebook-use
  twitter-use
  youtube-use
  email-use
  third-party-use
  search-use
  radio-use
  tv-use
  printed-use

  ;; impacts from each channel
  instagram-impact
  facebook-impact
  twitter-impact
  youtube-impact
  email-impact
  third-party-impact
  search-impact
  radio-impact
  tv-impact
  printed-impact
  hoarding-impact

  ;; count of channels around the person
  channel-count

  ;; current channel being evaluated
  current-channel
]


;; setup intial environment
to setup
  clear-all ;; clear everything
  ask patches [set pcolor black] ;; set background color black
  set conversion-threshold (threshold-value / 100) ;; divide by 100 to change conversion-threshold from percentage
  set raw-logs [["ticks" "who" "conversion-value" "purchase-no" "channel-count" "current-channel"]] ;; define raw-logs
  set customer-details [["who" "desc" "income" "gender" "instagram?" "facebook?" "twitter?" "youtube?" "email?" "third-party?" "search?" "radio?" "tv?" "printed?"]];; define customer details logs

  set channel-list (list "instagram" "facebook" "twitter" "youtube" "email" "third-party" "search" "radio" "tv" "printed") ;; define list of channel names
  ;; NOTE: ensure order of list everything channel related is maintained
  set channel-visibility [60 40 40 50 60 25 65 35 70 50] ;; set percentage of visibility (reduce values to include percentage of interaction as well, or define a new list for the same)


  ;; create millennials
  let millennials millennial-percent * total-population / 100 ;; define millennial variable for its population
  create-people millennials[
    setxy random-xcor random-ycor
    set shape "person"
    set color green

    set desc "millennial" ;; giving description

    ;; income 2 - high, 1 - medium, 0 - low
    set income random 3

    ;; gender 0- male, 1- female
    set gender random 2

    ;; set time of day channel is used
    set instagram-use [10 16 22]
    set facebook-use [11 17 23]
    set twitter-use [12 20]
    set youtube-use [15 18]
    set email-use [11 17 21]
    set third-party-use [11 20]
    set search-use [13 17 21]
    set radio-use [10 21]
    set tv-use [19 20]
    set printed-use [9 16]


    set purchase-no 0 ;; initialize number of purchases to zero
    set conversion-value 0.00 ;; initialize conversion threshold to zero

    ;; impacts from each channel
    set instagram-impact 0.15
    set facebook-impact 0.15
    set twitter-impact 0.05
    set youtube-impact 0.15
    set email-impact 0.10
    set third-party-impact 0.05
    set search-impact 0.10
    set radio-impact 0.04
    set tv-impact 0.10
    set printed-impact 0.10
    set hoarding-impact 0.05

    ;; set count of nearby channel to zero
    set channel-count 0
  ]
  ;; set channel flags for millennials
  ask n-of (0.70 * millennials) people with [desc = "millennial"] [set instagram? 1]
  ask n-of (0.75 * millennials) people with [desc = "millennial"] [set facebook? 1]
  ask n-of (0.55 * millennials) people with [desc = "millennial"] [set twitter? 1]
  ask n-of (0.85 * millennials) people with [desc = "millennial"] [set youtube? 1]
  ask n-of (0.90 * millennials) people with [desc = "millennial"] [set email? 1]
  ask n-of (0.50 * millennials) people with [desc = "millennial"] [set third-party? 1]
  ask n-of (0.75 * millennials) people with [desc = "millennial"] [set search? 1]
  ask n-of (0.50 * millennials) people with [desc = "millennial"] [set radio? 1]
  ask n-of (0.60 * millennials) people with [desc = "millennial"] [set tv? 1]
  ask n-of (0.40 * millennials) people with [desc = "millennial"] [set printed? 1]



  ;; create transitioning buyers
  let transitioner transitioner-percent * total-population / 100  ;; define transitioner variable for its population
  create-people transitioner[
    setxy random-xcor random-ycor
    set shape "person"
    set color yellow

    set desc "transitioner" ;; giving description

    ;; income 2 - high, 1 - medium, 0 - low
    set income random 3

    ;; gender 0- male, 1- female
    set gender random 2

    set purchase-no 0 ;; initialize number of purchases to zero
    set conversion-value 0.00 ;; initialize conversion threshold to zero

    ;; set time of day channel is used
    set instagram-use [10 16 22]
    set facebook-use [11 17 23]
    set twitter-use [12 20]
    set youtube-use [15 18]
    set email-use [11 17 21]
    set third-party-use [11 20]
    set search-use [13 17 21]
    set radio-use [10 21]
    set tv-use [19 20]
    set printed-use [9 16]

    ;; impacts from each channel
    set instagram-impact 0.05
    set facebook-impact 0.05
    set twitter-impact 0.05
    set youtube-impact 0.10
    set email-impact 0.15
    set third-party-impact 0.05
    set search-impact 0.15
    set radio-impact 0.10
    set tv-impact 0.20
    set printed-impact 0.10
    set hoarding-impact 0.10

    ;; set count of nearby channel to zero
    set channel-count 0
  ]
  ;; set channel flags for transitioner
  ask n-of (0.40 * transitioner) people with [desc = "transitioner"] [set instagram? 1]
  ask n-of (0.65 * transitioner) people with [desc = "transitioner"] [set facebook? 1]
  ask n-of (0.35 * transitioner) people with [desc = "transitioner"] [set twitter? 1]
  ask n-of (0.70 * transitioner) people with [desc = "transitioner"] [set youtube? 1]
  ask n-of (0.90 * transitioner) people with [desc = "transitioner"] [set email? 1]
  ask n-of (0.30 * transitioner) people with [desc = "transitioner"] [set third-party? 1]
  ask n-of (0.60 * transitioner) people with [desc = "transitioner"] [set search? 1]
  ask n-of (0.65 * transitioner) people with [desc = "transitioner"] [set radio? 1]
  ask n-of (0.70 * transitioner) people with [desc = "transitioner"] [set tv? 1]
  ask n-of (0.70 * transitioner) people with [desc = "transitioner"] [set printed? 1]





  ;; create traditional buyers
  let traditional traditional-percent * total-population / 100 ;; define population variable for traditional buyers
  create-people traditional[
    setxy random-xcor random-ycor
    set shape "person"
    set color red

    set desc "traditional" ;; giving description

    ;; income 2 - high, 1 - medium, 0 - low
    set income random 3

    ;; gender 0- male, 1- female
    set gender random 2


    set purchase-no 0 ;; initialize number of purchases to zero
    set conversion-value 0.00 ;; initialize conversion threshold to zero

   ;; set time of day channel is used
    set instagram-use [10 16 22]
    set facebook-use [11 17 23]
    set twitter-use [12 20]
    set youtube-use [15 18]
    set email-use [11 17 21]
    set third-party-use [11 20]
    set search-use [13 17 21]
    set radio-use [10 21]
    set tv-use [19 20]
    set printed-use [9 16]


    ;; impacts from each channel
    set instagram-impact 0.05
    set facebook-impact 0.10
    set twitter-impact 0.05
    set youtube-impact 0.10
    set email-impact 0.15
    set third-party-impact 0.05
    set search-impact 0.10
    set radio-impact 0.10
    set tv-impact 0.25
    set printed-impact 0.15
    set hoarding-impact 0.10

    ;; set count of nearby channel to zero
    set channel-count 0
  ]

  ;; set channel flags for traditional buyers
  ask n-of (0.15 * traditional) people with [desc = "traditional"] [set instagram? 1]
  ask n-of (0.30 * traditional) people with [desc = "traditional"] [set facebook? 1]
  ask n-of (0.10 * traditional) people with [desc = "traditional"] [set twitter? 1]
  ask n-of (0.45 * traditional) people with [desc = "traditional"] [set youtube? 1]
  ask n-of (0.50 * traditional) people with [desc = "traditional"] [set email? 1]
  ask n-of (0.10 * traditional) people with [desc = "traditional"] [set third-party? 1]
  ask n-of (0.25 * traditional) people with [desc = "traditional"] [set search? 1]
  ask n-of (0.70 * traditional) people with [desc = "traditional"] [set radio? 1]
  ask n-of (0.80 * traditional) people with [desc = "traditional"] [set tv? 1]
  ask n-of (0.80 * traditional) people with [desc = "traditional"] [set printed? 1]



  ;; create hoarding agents
  create-hoarding-group hoardings[
    setxy random-xcor random-ycor
    set shape "flag"
    set color white
  ]

  ask people [logging "customers"] ;; log all customer details
  reset-ticks ;; start ticks from zero
end

;; go function to run for each tick, one tick is assumed to be one hour
to go
   if ticks < simulation-hours [ ;; run for only simultion hours input by user based on ticks

    move-channel people 1 ;; move people agents with corresponding step(s)
    ask people [
      let channel-impact (list instagram-impact facebook-impact twitter-impact youtube-impact email-impact third-party-impact search-impact radio-impact tv-impact printed-impact) ;; define list for channel impacts
      let channel-use (list instagram-use facebook-use twitter-use youtube-use email-use third-party-use search-use radio-use tv-use printed-use) ;; define list for channel-use parameters
      (foreach channel-list channel-use channel-visibility channel-impact[[channel use visibility impact] -> check-interaction channel use visibility impact]) ;; run interaction code for call channels
      ;; NOTE: FOREACH consumes list in ORDER hence maintain the same order for ALL list
      check-in-radius "hoarding" hoarding-group hoarding-impact ;; check if person is in vicinity of hoarding/billboard
      make-purchase ;; user defined function to make purchases on crossing threshold value and to update channel impacts
      set conversion-value (conversion-value * 0.95) ;; decay rate of 5% per hour
      logging "raw" ;; logging raw
      set current-channel 0 ;; set current channel back to zero after interaction
    ]
    tick ;; increment tick
  ]
end



;; function to move any agentset given with a corresponding step
to move-channel [channel-breed steps]
  ask channel-breed[
    rt random 360 ;; change direction towards  right by a random angle (0-359)
    fd steps ;; move forward by corresponding steps in that direction
   ]
end

;; logging function to log raw data or customer details
to logging [log-type]
  ifelse (log-type = "raw")[
    set raw-logs lput (list ticks who conversion-value purchase-no channel-count current-channel) raw-logs
    csv:to-file "raw-level-logs.csv" raw-logs
  ] ;; log the raw data
  [
    ifelse (log-type = "customers") [
      set customer-details lput (list who desc income gender instagram? facebook? twitter? youtube? email? third-party? search? radio? tv? printed?) customer-details
      csv:to-file "customer-details.csv" customer-details] ;; log the customer data
    [show "logging option incorrect"]
  ]
end

;; function to check the interaction between person and channel
to check-interaction [channel use visibility impact]
  if (member? (ticks mod 24) use) and (random 100 < visibility)[
    set conversion-value (conversion-value + impact)
    set current-channel channel
    ;;decay-impact impact 10 ;; have to check if works ('set' command using iterable doesn't usually work)
  ]
end


;; function to increase conversion-value based on proximity of channels with people
;; NOTE: can add radius as a parameter for the function too
to check-in-radius [channel channel-breed impact]
   set channel-count (count other channel-breed in-radius 0.25)
   if channel-count > 0 [
    set conversion-value (conversion-value + impact)
    set current-channel channel
  ] ;; increment channel impact on conversion-counter if channel count is more than 0
end



;; function to make purchase for people given they cross the threshold value
to make-purchase
    if conversion-value >= conversion-threshold [ ;; when conversion-value crosses conversion-threshold
    logging "raw" ;;logging raw
    set current-channel "converted"
    set conversion-value 0.9999
    logging "raw"
    set purchase-no purchase-no + 1 ;; increment  number of purchases
      set conversion-value 0 ;; reset conversion value
      update-weights ;; update-weights of channels based on number of purchases
  ]
end

;; function to update impact of purchase based on history of purchases
to update-weights
  let increase 1
  ifelse (purchase-no = 1) ;; when purchase number is from 1-2
  [set increase 1.05] ;; let impact increase by 15%(1.5)
  [ifelse (purchase-no = 3) [set increase 1.10] ;; let impact increase by 25%(1.25)
      [if (purchase-no = 6)
        [set increase 1.15] ;; let impact increase by 50%(1.5)
      ]
  ]

      set instagram-impact (instagram-impact * increase)
      set facebook-impact (facebook-impact * increase)
      set twitter-impact (twitter-impact * increase)
      set youtube-impact (youtube-impact * increase)
      set email-impact (email-impact * increase)
      set third-party-impact (third-party-impact * increase)
      set search-impact (search-impact * increase)
      set radio-impact (radio-impact * increase)
      set tv-impact (tv-impact * increase)
      set printed-impact (printed-impact * increase)
      set hoarding-impact (hoarding-impact * increase)

end


;; decay channel-impact with each interaction ;; To Check if works
to decay-impact [channel-impact percent-reduce]
  set channel-impact (channel-impact * (1 - (percent-reduce / 100)))
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
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
16
-16
16
1
1
1
ticks
30.0

SLIDER
17
72
189
105
total-population
total-population
100
500
350.0
10
1
NIL
HORIZONTAL

SLIDER
210
498
382
531
hoardings
hoardings
0
100
15.0
1
1
NIL
HORIZONTAL

BUTTON
17
25
91
58
setup
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
124
25
187
58
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
249
470
399
488
Hoardings
12
0.0
1

SLIDER
16
119
190
152
millennial-percent
millennial-percent
0
100
45.0
1
1
%
HORIZONTAL

SLIDER
15
164
191
197
transitioner-percent
transitioner-percent
0
100
35.0
1
1
%
HORIZONTAL

SLIDER
15
211
191
244
traditional-percent
traditional-percent
0
100
25.0
1
1
%
HORIZONTAL

SLIDER
14
257
192
290
threshold-value
threshold-value
0
100
90.0
1
1
%
HORIZONTAL

SLIDER
13
300
193
333
simulation-hours
simulation-hours
0
500
200.0
10
1
NIL
HORIZONTAL

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
NetLogo 6.2.0
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
