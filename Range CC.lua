{{/*
    Dont change anything!

    This is the "Range CC" command.

    Trigger: None
/*}}

{{/* ACTUAL CODE! DONT TOUCH */}}
{{$tn := .ExecData.tn}}
{{$key := joinStr "" $tn "adicionados"}}
{{$master := sdict (dbGet (toInt $tn) "ticket").Value}}
{{$counter := (toInt $master.ticketCounter)}}
{{$entries := dbTopEntries $key 15 0}}
{{if .ExecData.um}}
    {{if ge $counter 1}}
        {{if le (len $entries) 5}}
            {{- range $entries -}}
                {{- execAdmin "ticket removeuser" .User.ID -}}
                {{- deleteResponse 1 -}}
            {{- end -}}
            {{$master.Set "rodando" 0}}
            {{dbSet (toInt $tn) "ticket" $master}}
            {{with .ExecData.msgID}}
                {{editMessage nil . (cembed "description" "All users have been removed from this ticket." "color" 1146986)}}
            {{else}}
                {{sendMessage nil (cembed "description" "All users have been removed from this ticket." "color" 1146986)}}
            {{end}}
        {{else}}
            {{$msgID := sendMessageRetID nil (cembed "description" "More than 5 users were on this ticket. Wait until you can make any action!" "color" 15105570)}}
            {{deleteResponse 5}}
            {{$entries = dbTopEntries $key 5 0}}
            {{- range $entries -}}
                {{- execAdmin "ticket removeuser" .User.ID -}}
                {{- deleteResponse 1 -}}
            {{- end -}}
            {{$master.Set "rodando" 1}}
            {{dbSet (toInt $tn) "ticket" $master}}
            {{execCC (toInt .CCID) nil 5 (sdict "tn" $tn "um" 1 "msgID" $msgID)}}
        {{end}}
    {{end}}
{{else if .ExecData.dois}}
    {{if ge $counter 1}}
        {{if le (len $entries) 5}}
            {{- range $entries -}}
                {{- execAdmin "ticket adduser" .User.ID -}}
                {{- deleteResponse 1 -}}
            {{- end -}}
            {{$master.Set "rodando" 0}}
            {{dbSet (toInt $tn) "ticket" $master}}
            {{with .ExecData.msgID}}
                {{editMessage nil . (cembed "description" "All users have been added again to this ticket." "color" 1146986)}}
            {{else}}
                {{sendMessage nil (cembed "description" "All users have been added again to this ticket." "color" 1146986)}}
            {{end}}
        {{else}}
            {{$msgID := sendMessageRetID nil (cembed "description" "More than 5 users were on this ticket. Still adding users." "color" 15105570)}}
            {{deleteResponse 5}}
            {{$entries = dbTopEntries $key 5 0}}
            {{- range $entries -}}
                {{- execAdmin "ticket adduser" .User.ID -}}
                {{- deleteResponse 1 -}}
            {{- end -}}
            {{$master.Set "rodando" 1}}
            {{dbSet (toInt $tn) "ticket" $master}}
            {{execCC (toInt .CCID) nil 5 (sdict "tn" $tn "dois" 2 "msgID" $msgID)}}
        {{end}}
    {{end}}
{{else if .ExecData.tres}}
    {{if ge $counter 1}}
        {{if le (len $entries) 5}}
            {{- range $entries -}}
                {{- dbDel .User.ID $key -}}
                {{- execAdmin "ticket removeuser" .User.ID -}}
                {{- deleteResponse 1 -}}
            {{- end -}}
            {{dbDel (toInt $tn) "ticket"}}
            {{with .ExecData.msgID}}
                {{editMessage nil . (cembed "description" "All users deleted. Ticket is being deleted." "color" 1146986)}}
            {{else}}
                {{sendMessage nil (cembed "description" "All users deleted. Ticket is being deleted." "color" 1146986)}}
            {{end}}
            {{execAdmin "ticket close" ""}}
        {{else}}
            {{$msgID := sendMessageRetID nil (cembed "description" "More than 5 users were on this ticket. Still deleting them." "color" 15105570)}}
            {{deleteResponse 5}}
            {{$entries = dbTopEntries $key 4 0}}
            {{- range $entries -}}
                {{- dbDel .User.ID $key -}}
                {{- execAdmin "ticket removeuser" .User.ID -}}
                {{- deleteResponse 1 -}}
            {{- end -}}
            {{execCC (toInt .CCID) nil 5 (sdict "tn" $tn "tres" 3 "msgID" $msgID)}}
        {{end}}
    {{else}}
        {{sendMessage nil (cembed "description" "Ticket is being deleted." "color" 1146986)}}
        {{dbDel (toInt $tn) "ticket"}}
        {{execAdmin "ticket close" ""}}
    {{end}}
{{end}}