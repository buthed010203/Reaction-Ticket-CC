# Reaction-Ticket-CC
This is a Custom Command (CC) to use with [YAGPDB](https://yagpdb.xyz/).<p>
**IMPORTANT NOTE:** If you are using this CC, you **MUST DISABLE** all tickets commands.<p>
Also, ***never*** change the name of a ticket chat manually. Let the bot make all the changes. 

## Features
1. Tickets work fully with reactions. You can open, close, reopen, delete, save transcript, make it admin only, etc, all with reactions. 
1. Extra ticket functionalities (with command -checktickets):
	1. This command has an alias (-ct)
		1. FullList (aliases: fl, full, big): Shows you the 25 most recent tickets of the server. Doesn't work well with Discord Mobile. It has a pagination system so you can scroll to older tickets. 
		1. SmallList (aliases sl, small): Same as above but more concise. Only show 3 infos, instead of all infos. Also has a pagination system. It shows the 24 most recent tickets, instead of 25.
		1. Exact ticket (for example: -ct 96): Shows all the info about the specifed ticket. If you are **premium** at [YAGPDB](https://yagpdb.xyz/), this feature will also have a pagination system. 
		1. Newest (aliases: n, new): Same as above, but instead of exact ticket, shows the most recent one.
		1. Oldest (aliases: o, old): Same as above, but instead of the most recent ticket, shows the oldest one.
		1. Examples of use: -ct o | -ct new | -checktickets fl
1. Ability to reopen ticket after its closed. 
1. Ability to save transcripts without deleting the ticket. 
1. Use command $add and $remove to add/remove users to/from the ticket. 
	1. Maximum of 15 users per ticket. 
		1. **Why not use the built-in add command?** Because that doesn't allow you to reopen the ticket. 
1. Automatically deletes tickets after x amount of time with no messages sent. Only applies to open tickets. Closed ones will have to be deleted manually. 
1. Handy **-resend** command. This deletes the original first message of the ticket and resends it. It's good to close the ticket without having to scroll all the way up to find the message.
1. Automatically renames the ticket chat name so that you know if its opened, closed or currently solving.

## How To Install
Copy and paste every command to your server. All the instructions are at the top of each command.<p>
You dont need to change anything in any command, except for the setup command.<p>
After you created all the commands at your control panel, change the settings in the setup command and then run it once.<p>
It will return with all your settings. If everything is correct, the system is good to go.<p>
If you found a mistake in your settings, change it and run the command again.<p>
After that you can delete the setup command.<p>
NO CHANNELS CAN BE IN THE TICKET CATEGORY BESIDES A TICKET CHANNEL!!!

### To Do List
1. Special mod tickets that can only be used by mods and automatically sets ticket to admin only.
1. Different ticket categories which start with an unique starting name.
	1. A category wise summary of how many ticket of each category was opened (statistics per say).
1. User satisfaction system. An ability to make the user say how good was the ticket support from 1 to 10.
1. Mods statistics. Admins will be able to see mods statistics, for example: how many ticket they solved or there avarage grade on the satisfaction system. 

### Contributing
Please feel free to report any bugs. I'll try to fix it ASAP. Also, if you have an idea to add to the system, or how to improve it somehow, please let me know as well!

### Disclaimer
This repository and myself are not officially affiliated with YAGPDB in any shape or form. The YAGPDB creator and staff are not responsible for any difficulties caused by these custom commands. These commands are not guaranteed to be working. I strive to test all the custom commands here, but due to many reasons sometimes I am unable to.

### Contact
You can contact me @ discord. My name there is: Pedro Pessoa#0001
