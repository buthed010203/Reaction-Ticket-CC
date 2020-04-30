{{/*
    This command manages the $add and $remove commands.  

    Dont change anything!

    Trigger: Regex
    Regex: ^\$add|^\$remove

    Usage:
    $add @user
    $remove @user
/*}}

{{/* ACTUAL CODE! DONT TOUCH */}}
{{$setup := sdict (dbGet 0 "ticket_cfg").Value}}
{{$category := (toInt $setup.category)}} 
{{$admins := $setup.Admins}} 
{{$mods := $setup.Mods}} 
{{if eq .Channel.ParentID $category}}
{{/* VARIABLES */}}
{{$tn := reFind `[0-9]+` .Channel.Name}}
{{$key := joinStr "" $tn "adicionados"}}
{{$user := .User}}
{{$isMod := false}}
{{$isModA := false}}
{{$cmd := reFind `(?i)\$add|\$remove` .Cmd}}
{{$master := sdict (dbGet (toInt $tn) "ticket").Value}}
{{$creator := (toInt $master.userID)}}
{{$atual := (toInt $master.ticketCounter)}}
{{$tUser := .User}}
{{/* END OF VARIABLES */}}

{{/* START */}}
{{range .Member.Roles}}
    {{if (or (in $mods .) (in $admins .))}}
        {{$isModA = true}}
    {{end}}
{{end}}
{{if not (eq (toInt $master.pos) 3)}}
{{if (or (eq .User.ID $creator) ($isModA))}}
    {{if (and (.CmdArgs) (eq (len .CmdArgs) 1))}}
        {{with (userArg (index .CmdArgs 0))}}
            {{$user = .}}
            {{range (getMember $user.ID).Roles}}
                {{if in $mods .}}
                    {{$isMod = true}}
                {{end}}
            {{end}}
            {{$isAlready := (dbGet $user.ID $key)}}
            {{if eq $cmd "$add"}}
                {{if lt $atual 15}}
                    {{if (not $isMod)}}
                        {{if (and (not $isAlready) (not (eq $user.ID $creator)))}}
                            {{exec "ticket adduser" $user.ID}}
                            {{deleteResponse 1}}
                            {{sendMessageNoEscape nil (cembed "description" (joinStr "" "User " $user.Mention " was added to this ticket.") "color" 12370112)}}
                            {{dbSet $user.ID $key 1}}
                            {{$master.Set "ticketCounter" (toString (add $atual 1))}}
                            {{dbSet (toInt $tn) "ticket" $master}}
                        {{else}}
                            Hey, {{$tUser.Mention}}!! The user **{{$user.Username}}** is already on this ticket!
                        {{end}}
                    {{else}}
                        Hey, {{$tUser.Mention}}! Mods cant be added to a ticket!
                    {{end}}
                {{else}}
                The maximum amount of participants in a ticket is 15 users, {{$tUser.Mention}}
                {{end}}
            {{else if eq $cmd "$remove"}}
                {{if (not $isMod)}}
                    {{if ($isAlready)}}
                        {{if (not (eq $user.ID $creator))}}
                            {{exec "ticket removeuser" $user.ID}}
                            {{deleteResponse 1}}
                            {{sendMessageNoEscape nil (cembed "description" (joinStr "" "The user " $user.Mention " was removed from the ticket.") "color" 12370112)}}
                            {{dbDel $user.ID $key}}
                            {{$master.Set "ticketCounter" (toString (sub $atual 1))}}
                            {{dbSet (toInt $tn) "ticket" $master}}
                        {{else}}
                            You cant remove the creator of the ticket, {{$tUser.Mention}}
                        {{end}}
                    {{else}}
                        The user **{{$user.Username}}** is not a participant of the ticket, {{$tUser.Mention}}
                    {{end}}
                {{else}}
                    You cant remove mods from the ticket, {{$tUser.Mention}}
                {{end}}
            {{end}}
        {{else}}
            Invalid user, {{$tUser.Mention}}
        {{end}}
    {{else}}
        Correct usage of the command: $add or $remove @user
    {{end}}
{{end}}
{{end}}
{{/* FINISH */}}
{{end}}
