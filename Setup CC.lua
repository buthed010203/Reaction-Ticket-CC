{{/*
    This command is your setup command, you should add this command last.
    Run it only once, and you should be good to go.  

    Only change the USER VARIABLES PART

    Trigger Type: Command
    Trigger: setuptickets

    Just say -setuptickets on any channel after that you can delete this command.
*/}}

{{/* USER VARIABLES */}}

{{$Admins := cslice 673258482211749917}} {{/* IDs of your ADMINs Roles. Leave the "cslice" here even if you have only 1 role */}}
{{$Mods := cslice 674429313097007106}} {{/* IDs of your MODs Roles. Leave the "cslice" here even if you have only 1 role */}}
{{$MentionRoleID := 647298324734541827}} {{/* Role to be mentioned when a new ticket is opened */}}

{{$OpenEmoji := "📩"}}
{{$CloseEmoji := "🔒"}}
{{$SolveEmoji := "📌"}}
{{$AdminOnlyEmoji := "🛡️"}}
{{$ConfirmCloseEmoji := "✅"}} {{/* Closing the ticket with this system is a 2 step proccess. So, after you click the CloseEmoji, you can either confirm the closing or cancel it. */}}
{{$CancelCloseEmoji := "❎"}}
{{$SaveTranscriptEmoji := "📑"}}
{{$ReOpenEmoji := "🔓"}}
{{$DeleteEmoji := "⛔"}}
{{$ticketOpen := "Aberto"}} {{/* Name for the chat of an open ticket */}}
{{$ticketClose := "Fechado"}} {{/* Name for the chat of a closed ticket */}}
{{$ticketSolving := "Resolvendo"}} {{/* Name for the chat of an solving ticket */}}

{{$SchedueledCCID := 133}} {{/* ID of your "Schedueled CC" */}}
{{$CCID := 132}} {{/* ID of your "Range CC" */}}
{{$msgID := 656755443506610176}} {{/* Message ID of the message the user has to react to open ticket */}}
{{$Trc := 682036950999629879}} {{/* Channe ID to save transcripts */}}
{{$category := 682207474178195489}} {{/* Tickets category ID */}}
{{$Delay := 24}} {{/* Delay (in hours) for a ticket to automatically be deleted if no messages are sent */}}

{{/* END OF USER VARIABLES */}}






{{/* ACTUAL CODE! DONT TOUCH */}}
{{dbSet 0 "ticket_cfg" (sdict "Admins" $Admins "Mods" $Mods "MentionRoleID" (toString $MentionRoleID) "OpenEmoji" $OpenEmoji "CloseEmoji" $CloseEmoji "SolveEmoji" $SolveEmoji "AdminOnlyEmoji" $AdminOnlyEmoji "ConfirmCloseEmoji" $ConfirmCloseEmoji "CancelCloseEmoji" $CancelCloseEmoji "SaveTranscriptEmoji" $SaveTranscriptEmoji "ReOpenEmoji" $ReOpenEmoji "DeleteEmoji" $DeleteEmoji "ticketOpen" (lower $ticketOpen) "ticketClose" (lower $ticketClose) "ticketSolving" (lower $ticketSolving) "SchedueledCCID" (toString $SchedueledCCID) "CCID" (toString $CCID) "msgID" (toString $msgID) "Trc" (toString $Trc) "category" (toString $category) "Delay" (toString $Delay))}}
All good! If you did everything right, you should now be good to use your Reaction Ticket System! :)
{{$setup := sdict (dbGet 0 "ticket_cfg").Value}}
**Admins:** {{$setup.Admins}} 
**Mods:** {{$setup.Mods}} 
**RangeCCID:** {{(toInt $setup.CCID)}}
**SchedueledCCID:** {{(toInt $setup.SchedueledCCID)}}  
**TransCriptChannel:** {{(toInt $setup.Trc)}} 
**Category:** {{(toInt $setup.category)}} 
**MessageToOpenTicketID:** {{(toInt $setup.msgID)}} 
**RoleToBeMentionedWhenTicketIsOpened:** {{(toInt $setup.MentionRoleID)}} 
**OpenEmoji:** {{$setup.OpenEmoji}}
**CloseEmoji:** {{$setup.CloseEmoji}}
**SolveEmoji:** {{$setup.SolveEmoji}}
**AdminOnlyEmoji:** {{$setup.AdminOnlyEmoji}}
**ConfirmCloseEmoji:** {{$setup.ConfirmCloseEmoji}}
**CancelCloseEmoji:** {{$setup.CancelCloseEmoji}}
**SaveTranscriptEmoji:** {{$setup.SaveTranscriptEmoji}}
**ReOpenEmoji:** {{$setup.ReOpenEmoji}}
**DeleteEmoji:** {{$setup.DeleteEmoji}}
**TicketOpenChannelName:** {{$setup.ticketOpen}}
**TicketSolvingChannelName:** {{$setup.ticketSolving}}
**TicketCloseChannelName:** {{$setup.ticketClose}}
**Delay (in hours):** {{(toInt $setup.Delay)}}

You can reuse this command **BEFORE STARTING TO USE THE TICKET SYSTEM** if anything of this configs is wrong. 
{{deleteResponse 120}}