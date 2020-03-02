{{/*
    This command is to go into your "Opening message in new tickets" box. 
    (Control panel -> Tools & Utilities -> Ticket Sytem)

    Dont change anything!
*/}}

{{/* ACTUAL CODE! DONT TOUCH */}}
{{/* START */}}
{{$setup := sdict (dbGet 0 "ticket_cfg").Value}}
{{$CloseEmoji := $setup.CloseEmoji}}
{{$SolveEmoji := $setup.SolveEmoji}}
{{$AdminOnlyEmoji := $setup.AdminOnlyEmoji}}
{{$ConfirmCloseEmoji := $setup.ConfirmCloseEmoji}}
{{$CancelCloseEmoji := $setup.CancelCloseEmoji}}
{{$ModeratorRoleID := (toInt $setup.MentionRoleID)}}
{{$SchedueledCCID := (toInt $setup.SchedueledCCID)}}
{{$Delay := (toInt $setup.Delay)}}
{{$tn := reFind `[0-9]+` .Channel.Name}}
{{$time :=  currentTime}}
{{$content := joinStr "" "Welcome, " .User.Mention}}
{{$descr := joinStr "" "Soon a  <@&" $ModeratorRoleID "> will talk to you! For now, you can start telling us what's the issue, so that we can help you faster! :)\nIn case you dont need help anymore, or you want to close this ticket, click on the " $CloseEmoji " and then on the " $ConfirmCloseEmoji " that will show up!"}}
{{$embed := cembed "color" 8190976 "description" $descr "timestamp" $time}}
{{$id := sendMessageNoEscapeRetID nil (complexMessage "content" $content "embed" $embed)}}
{{addMessageReactions nil $id $CloseEmoji $SolveEmoji $AdminOnlyEmoji}}
{{$realDelay := mult $Delay 3600}}
{{$AoD := 1}}
{{if gt $Delay 3}}
    {{$AoD = 2}}
{{end}}
{{if eq $AoD 1}}
    {{scheduleUniqueCC $SchedueledCCID nil $realDelay $tn (sdict "alert" 2)}}
    {{dbSet (toInt $tn) "ticket" (sdict "AoD" $AoD "Delay" (toString $Delay) "pos" 1 "ticketID" $tn "userID" (toString .User.ID) "mainMsgID" (toString $id) "ticketCounter" (toString 0) "duration" ($time.Add (toDuration (joinStr "" $Delay "h30m"))) "ctime" $time "alert" 2 "creator" (userArg .User.ID))}}
{{else}}
    {{$3HoursAlert := sub $realDelay 10800}}
    {{scheduleUniqueCC $SchedueledCCID nil $3HoursAlert $tn (sdict "alert" 1)}}
    {{dbSet (toInt $tn) "ticket" (sdict "AoD" $AoD "Delay" (toString $Delay) "pos" 1 "ticketID" $tn "userID" (toString .User.ID) "mainMsgID" (toString $id) "ticketCounter" (toString 0) "duration" ($time.Add (toDuration (joinStr "" $Delay "h"))) "ctime" $time "alert" 1 "creator" (userArg .User.ID))}}
{{end}}
{{/* FINISH */}}