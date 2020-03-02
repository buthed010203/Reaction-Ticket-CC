{{/*
    This command manages the -resend command

    It deletes the original first message of the ticket and resends it so that you dont have to scroll up to make actions!

    Dont change anything!

    Trigger type: Command
    Trigger: resend

    Usage:
    -resend
/*}}

{{/* ACTUAL CODE! DONT TOUCH */}}
{{/* VARIABLES */}}
{{$setup := sdict (dbGet 0 "ticket_cfg").Value}}
{{$category := (toInt $setup.category)}} 
{{$admins := $setup.Admins}} 
{{$mods := $setup.Mods}} 
{{$CloseEmoji := $setup.CloseEmoji}}
{{$SolveEmoji := $setup.SolveEmoji}}
{{$AdminOnlyEmoji := $setup.AdminOnlyEmoji}}
{{$ConfirmCloseEmoji := $setup.ConfirmCloseEmoji}}
{{$CancelCloseEmoji := $setup.CancelCloseEmoji}}
{{$ModeratorRoleID := (toInt $setup.MentionRoleID)}} 
{{$time :=  currentTime}}
{{$tn := reFind `[0-9]+` .Channel.Name}}
{{$master := sdict (dbGet (toInt $tn) "ticket").Value}}
{{$isMod := false}}
{{/* END OF VARIABLES */}}

{{/* CHECKS */}}
{{range .Member.Roles}}
    {{if (or (in $mods .) (in $admins .))}}
        {{$isMod = true}}
    {{end}}
{{end}}
{{/* END OF CHECKS */}}

{{if (and ($tn) ($isMod) ($master) (eq .Channel.ParentID $category) (ne $master.pos 3))}}
    {{deleteMessage nil (toInt $master.mainMsgID) 2}}
    {{$autor := $master.creator}}
    {{$content := joinStr "" "Welcome, **" $autor.Username "**"}}
    {{$descr := joinStr "" "Soon a  <@&" $ModeratorRoleID "> will talk to you! For now, you can start telling us what's the issue, so that we can help you faster! :)\nIn case you dont need help anymore, or you want to close this ticket, click on the " $CloseEmoji " and then on the " $ConfirmCloseEmoji " that will show up!"}}
    {{$embed := cembed "color" 8190976 "description" $descr "timestamp" $time}}
    {{$id := sendMessageNoEscapeRetID nil (complexMessage "content" $content "embed" $embed)}}
    {{addMessageReactions nil $id $CloseEmoji $SolveEmoji $AdminOnlyEmoji}}
    {{$master.Set "mainMsgID" (toString $id)}}
    {{dbSet (toInt $tn) "ticket" $master}}
    {{deleteTrigger 2}}
{{end}}
