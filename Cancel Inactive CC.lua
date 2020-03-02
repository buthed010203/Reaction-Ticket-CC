{{/*
    This command manages the inactivity of tickets. 

    Dont change anything!

    Trigger: Regex
    Regex: .*

    If you already have a .* trigger on your server, it`s advisable that you put this command on that same CC. You can just copy and paste it below everything of your already existing CC.  
/*}}

{{/* ACTUAL CODE! DONT TOUCH */}}
{{$setup := sdict (dbGet 0 "ticket_cfg").Value}}
{{$category := (toInt $setup.category)}} 
{{$SchedueledCCID := (toInt $setup.SchedueledCCID)}} 
{{if eq .Channel.ParentID $category}}
{{/* VARIABLES */}}
{{$tn := reFind `[0-9]+` .Channel.Name}}
{{$master := sdict (dbGet (toInt $tn) "ticket").Value}}
{{/* END OF VARIABLES */}}

{{/* START */}}
{{cancelScheduledUniqueCC $SchedueledCCID $tn}}
{{$time :=  currentTime}}
{{$Delay := (toInt $master.Delay)}}
{{$realDelay := mult $Delay 3600}}
{{sleep 3}}
{{if eq (toInt $master.AoD) 1}}
    {{$master.Set "duration" ($time.Add (toDuration (joinStr "" (toString $Delay) "h30m")))}}
    {{$master.Set "alert" 2}}
    {{dbSet (toInt $tn) "ticket" $master}}
    {{scheduleUniqueCC $SchedueledCCID nil $realDelay $tn (sdict "alert" 2)}}
{{else}}
    {{$master.Set "duration" ($time.Add (toDuration (joinStr "" (toString $Delay) "h")))}}
    {{$3HoursAlert := sub $realDelay 10800}}
    {{$master.Set "alert" 1}}
    {{dbSet (toInt $tn) "ticket" $master}}
    {{scheduleUniqueCC $SchedueledCCID nil $3HoursAlert $tn (sdict "alert" 1)}}
{{end}}
{{/* FINISH */}}
{{end}}