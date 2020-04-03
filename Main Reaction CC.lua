{{/*
    This command manages the tickets reactions. 

    Dont change anything!

    Trigger: Reaction with "Added + Removed Reactions" option
/*}}

{{/* ACTUAL CODE! DONT TOUCH */}}
{{$setup := sdict (dbGet 0 "ticket_cfg").Value}}
{{$admins := $setup.Admins}} 
{{$mods := $setup.Mods}} 
{{$CCID := (toInt $setup.CCID)}} 
{{$Trc := (toInt $setup.Trc)}} 
{{$category := (toInt $setup.category)}} 
{{$msgID := (toInt $setup.msgID)}} 
{{$SchedueledCCID := (toInt $setup.SchedueledCCID)}} 
{{$oe := $setup.OpenEmoji}}
{{$ce := $setup.CloseEmoji}}
{{$se := $setup.SolveEmoji}}
{{$aoe := $setup.AdminOnlyEmoji}}
{{$cce := $setup.ConfirmCloseEmoji}}
{{$dce := $setup.CancelCloseEmoji}}
{{$ste := $setup.SaveTranscriptEmoji}}
{{$roe := $setup.ReOpenEmoji}}
{{$de := $setup.DeleteEmoji}}
{{$RID := .ReactionMessage.ID}}
{{$isMod := false}}{{$isAdmin := false}}
{{$TO := $setup.ticketOpen}}{{$TS := $setup.ticketSolving}}{{$TC := $setup.ticketClose}}

{{/* OPENING TICKET */}}
{{if (and (.ReactionAdded) (eq $RID $msgID) (eq .Reaction.Emoji.Name $oe))}}
    {{exec "ticket open" $TO}}
    {{deleteResponse 10}}
    {{deleteMessageReaction nil $msgID .User.ID $oe}}
{{end}}
{{/* END OF OPENING TICKET */}}

{{if eq .Channel.ParentID $category}}
{{$tn := reFind `[0-9]+` .Channel.Name}}
{{$master := sdict (dbGet (toInt $tn) "ticket").Value}}
{{$creator := (toInt $master.userID)}}{{$ticketCounter := (toInt $master.ticketCounter)}}
{{$ab := reFind $TO .Channel.Name}}{{$rs := reFind $TS .Channel.Name}}{{$fc := reFind $TC .Channel.Name}}

{{/* CHECKS */}}
{{range .Member.Roles}}
    {{if in $mods .}}
        {{$isMod = true}}
    {{end}}
    {{if in $admins .}}
        {{$isAdmin = true}}
    {{end}}
{{end}}
{{/* END OF CHECKS */}}

{{/* CLOSING TICKET */}}
{{if (and (.ReactionAdded) (or (eq .User.ID $creator) ($isMod) ($isAdmin)) (eq $RID (toInt $master.mainMsgID)) (ne (toInt $master.pos) 3))}}
    {{if (eq .Reaction.Emoji.Name $ce)}}
        {{addMessageReactions nil $RID $dce $cce}}
        {{deleteMessageReaction nil $RID .User.ID $ce}}
    {{else if (eq .Reaction.Emoji.Name $dce)}}
        {{deleteMessageReaction nil $RID 204255221017214977 $dce $cce}}
        {{deleteMessageReaction nil $RID .User.ID $dce}}
        {{$master.Set "pos" 1}}
        {{dbSet (toInt $tn) "ticket" $master}}
    {{else if (eq .Reaction.Emoji.Name $cce)}}
        {{if $ab}}
            {{editChannelName nil (reReplace $TO .Channel.Name $TC)}}
        {{else if $rs}}
            {{editChannelName nil (reReplace $TS .Channel.Name $TC)}}
        {{end}}
        {{$ced := joinStr "" "This ticket was closed by: " .User.Mention}}
        {{$ce := cembed "color" 16776960 "description" $ced "timestamp" currentTime}}
        {{sendMessageNoEscape nil $ce}}
        {{$ced2 := joinStr "" $ste " Save transcript\n" $roe " Reopen Ticket\n" $de " Delete Ticket"}}
        {{$ce2 := cembed "color" 16711680 "description" $ced2}}
        {{$lm := sendMessageNoEscapeRetID nil $ce2}}
        {{addMessageReactions nil $lm $ste $roe $de}}
        {{$master.Set "lastMessageID" (toString $lm)}}
        {{deleteMessageReaction nil $RID .User.ID $cce}}
        {{if getMember $creator}} {{exec "ticket removeuser" $creator}} {{end}}
        {{deleteResponse 1}}
        {{if ge $ticketCounter 1}}
            {{execCC $CCID nil 5 (sdict "tn" $tn "um" 1)}}
        {{end}}
        {{$master.Set "pos" 3}}
        {{dbSet (toInt $tn) "ticket" $master}}
    {{end}}
{{end}}
{{/* END OF CLOSING TICKET */}}

{{/* SOLVING TICKET */}}
{{if (and (or ($isMod) ($isAdmin)) (eq $RID (toInt $master.mainMsgID)) (eq .Reaction.Emoji.Name $se))}}
    {{if .ReactionAdded}}
        {{if $ab}}
            {{editChannelName nil (reReplace $TO .Channel.Name $TS)}}
            {{$desc := joinStr "" "Now the mod " .User.Mention " is solving this ticket!"}}
            {{$emb := cembed "description" $desc "color" 1752220}}
            {{sendMessage nil $emb}}
            {{$master.Set "pos" 2}}
            {{$master.Set "resp" (toString .User.ID)}}
            {{$master.Set "respArg" (userArg .User.ID)}}
            {{dbSet (toInt $tn) "ticket" $master}}
        {{end}}
    {{else}}
        {{if $rs}}
            {{editChannelName nil (reReplace $TS .Channel.Name $TO)}}
            {{$desc := joinStr "" "Looks like the mod " .User.Mention " could not solve your problem.\nDon't worry! Another staff member is coming to help you ASAP!"}}
            {{$emb := cembed "description" $desc "color" 1752220}}
            {{sendMessage nil $emb}}
            {{$master.Set "pos" 1}}
            {{$master.Set "resp" 0}}
            {{$master.Set "respArg" 0}}
            {{dbSet (toInt $tn) "ticket" $master}}
        {{end}}
    {{end}}
    {{if (and (.ReactionAdded) (not $ab) (not $rs))}}
        {{deleteMessageReaction nil $RID .User.ID $se}}
    {{end}}
{{end}}
{{/* END OF SOLVING TICKET */}}

{{/* ADMIN ONLY TICKET */}}
{{if (and ($isAdmin) (eq $RID (toInt $master.mainMsgID)) (eq .Reaction.Emoji.Name $aoe))}}
    {{if .ReactionAdded}}
        {{$desc := joinStr "" "This ticket is now in Admin Only mode"}}
        {{$emb := cembed "description" $desc "color" 1752220}}
        {{sendMessage nil $emb}}
        {{exec "ticket ao"}}
        {{deleteResponse 1}}
    {{else}}
        {{$desc := joinStr "" "This ticket is no longer in Admin Only mode"}}
        {{$emb := cembed "description" $desc "color" 1752220}}
        {{sendMessage nil $emb}}
        {{exec "ticket ao"}}
        {{deleteResponse 1}}
    {{end}}
{{end}}
{{/* END OF ADMIN ONLY TICKET */}}

{{/* FINAL ACTIONS */}}
{{$oldid := (toInt $master.mainMsgID)}}
{{if (and (or ($isMod) ($isAdmin)) (eq (toInt $master.lastMessageID) $RID) (.ReactionAdded))}}
    {{if (eq .Reaction.Emoji.Name $de)}}
        {{if ne (toInt $master.rodando) 1}}
            {{sendMessage nil (cembed "description" "This ticket will be deleted soon." "color" 15158332)}}
            {{deleteMessageReaction nil $RID .User.ID $de}}
            {{execCC $CCID nil 5 (sdict "tn" $tn "tres" 3)}}
            {{cancelScheduledUniqueCC $SchedueledCCID $tn}}
        {{else}}
            There are still users being removed. Wait until you can delete the ticket.
            {{deleteResponse 10}}
        {{end}}
    {{else if (eq .Reaction.Emoji.Name $roe)}}
        {{if (and ($fc) (not $master.resp))}}
            {{editChannelName nil (reReplace $TC .Channel.Name $TO)}}
        {{else if (and ($fc) ($master.resp))}}
            {{editChannelName nil (reReplace $TC .Channel.Name $TS)}}
        {{end}}
        {{deleteMessage nil $RID 1}}
        {{sendMessage nil (cembed "description" (joinStr "" "This ticket was reopened by: " .User.Mention) "color" 255)}}
        {{deleteMessageReaction nil $oldid 204255221017214977 $dce $cce}}
        {{exec "ticket adduser" $creator}}
        {{deleteResponse 1}}
        {{execCC $CCID nil 5 (sdict "tn" $tn "dois" 2)}}
        {{if (ge (toInt .Value.resp) 1)}}
            {{$master.Set "pos" 2}}
        {{else}}
            {{$master.Set "pos" 1}}
        {{end}}
        {{dbSet (toInt $tn) "ticket" $master}}
        {{cancelScheduledUniqueCC $SchedueledCCID $tn}}
        {{$time :=  currentTime}}
        {{$Delay := (toInt $master.Delay)}}
        {{$realDelay := mult $Delay 3600}}
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
    {{else if (eq .Reaction.Emoji.Name $ste)}}
        {{sendMessage $Trc (cembed "title" (printf "Ticket %s transcript" $tn) "description" (execAdmin "logs 250"))}}
        {{sendMessage nil (cembed "description" "Transcript saved!" "color" 3066993)}}
        {{deleteMessageReaction nil $RID .User.ID $ste}}
    {{end}}
{{end}}
{{/* END OF FINAL ACTIONS */}}
{{end}}
