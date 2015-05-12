function AG_OnLoad(self)
    self:RegisterEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
    self:RegisterEvent("CHAT_MSG_ACHIEVEMENT")
    self:RegisterEvent("CHAT_MSG_PARTY")
    self:RegisterEvent("CHAT_MSG_SYSTEM")
    --slash commands
	SlashCmdList["AG"] = AG_Command;
    SLASH_AG1 = "/ag";
    SLASH_AG2 = "/autogratzer";
    if(AG_GratsMessage == nil)then
		AG_GratsMessage="Gratzzz";
		AG_Print("Grats message set to: Gratzzz");
		AG_LastMessage = 1;
	end
	if(AG_GuildJoinMessageToggle == nil)then
		AG_GuildJoinMessageToggle = False;
	end
	if(AG_Guild == nil)then
		AG_Guild = true;
	end
	if(AG_Say == nil)then
		AG_Say = true;
	end
	if(AG_Party == nil)then
		AG_Party = false;
	end
	if(AG_Delay == nil)then
		AG_Delay=0;
		--AG_Print("Grats message delay set to: 1000ms");
	end
	AG_Print("AG Enabled");
end

 function AG_GetCmd(msg)
 	if msg then
 		local a=(msg); --contiguous string of non-space characters
 		if a then
 			return msg
 		else	
 			return "";
 		end
 	end
 end

function AG_ShowHelp()
	print("AutoGratzer usage:");
	print("'/ag {msg}' or '/autogratzer {msg}'");
	print("'/ag delay {delay}' or '/autogratzer {delay}', with delay in milliseconds to set delay");
	print("'/ag guild' or '/autogratzer guild' to enable/disable guild gratzing");
	print("'/ag say' or '/autogratzer say' to enable/disable say gratzing");
	print("'/ag party' or '/autogratzer party' to enable/disable say gratzing");
end

function AG_ToggleGuild()
	if(AG_Guild) then 
		AG_Guild = false; 
		AG_Print("Guild gratzing now Off");
	else
		AG_Guild = true;    
		AG_Print("Guild gratzing now On");
	end;
end

function AG_ToggleSay()
	if(AG_Say) then 
		AG_Say = false; 
		AG_Print("Say gratzing now Off");
	else
		AG_Say = true;
		AG_Print("Say gratzing now On");
	end;
end

function AG_ToggleParty()
	if(AG_Party) then 
		AG_Party = false; 
		AG_Print("Party gratzing now Off");
	else
		AG_Party = true; 
		AG_Print("Party gratzing now On");
	end;
end

function AG_SetDelay(delay)
	if(delay ~= nill)then
		AG_Delay = tonumber(delay); 
		AG_Print("Grats message delay set to: " ..delay.."ms");	
	else
		AG_Print("Provide a number in milliseconds, eg '/ag delay 5000' for 5 seconds");
	end
end

function AG_Command(msg)
    local Cmd, SubCmd = AG_GetCmd(msg);
    if (Cmd == "")then
        AG_ShowHelp();
    elseif (Cmd == "help")then
        AG_ShowHelp();
    elseif (Cmd == "options")then
        AG_ShowHelp();
    elseif (Cmd == "guild")then
        AG_ToggleGuild();
    elseif (Cmd == "say")then
        AG_ToggleSay();
    elseif (Cmd == "party")then
        AG_ToggleParty();
	elseif (string.find(Cmd,"delay") == 1)then
        AG_SetDelay(string.match(Cmd,"%d+"));
    else
        AG_GratsMessage = Cmd;
		AG_Print("Grats message set to: " .. Cmd);
    end
end


function AG_OnEvent(self,event,arg1,arg2)
	if(AG_GratsMessage == nil)then
		AG_GratsMessage="Gratzzz";
    end
    if(arg2 ~= ({UnitName("player")})[1])then
    	--if(event ~= "CHAT_MSG_SYSTEM") then print(event .. ";" .. arg1 .. ";" .. arg2); end
	    if(event == "CHAT_MSG_GUILD_ACHIEVEMENT")then AG_DoGrats("GUILD");
	    elseif(event == "CHAT_MSG_ACHIEVEMENT")then AG_DoGrats("SAY");
	    elseif(event == "CHAT_MSG_ACHIEVEMENT")then AG_DoGrats("PARTY");
	    elseif(event == "CHAT_MSG_SYSTEM") then
	    	if(id ~= nil) then
				if(string.find(id,"has joined the guild.")) then AG_GuildWelcome();
				end
			end
	    end
	end
end

function AG_DoGrats(source)
	if((source == "SAY" and AG_Say == true) or (source == "GUILD" and AG_Guild == true) or (source == "PARTY" and AG_Party == true)) then
		CurTime=GetTime();
		if (AG_LastMessage == nil) then
			AG_LastMessage = 1;
		end
		--Time to wait after message is fixed at 6 seconds atm
		if((CurTime - AG_LastMessage) > 6)then
			if(AG_Delay > 0)then
				C_Timer.After((AG_Delay/1000), function() SendChatMessage(AG_GratsMessage, "SAY"); end)
			else
				SendChatMessage(AG_GratsMessage, source);
				AG_LastMessage = GetTime();
			end
		end
	end
end

function AG_GuildWelcome()
	--Testing, enable if you know what your doing...
	if(AG_GuildJoinMessageToggle == True)then
		if(string.find(arg1,"has joined the guild.")) then
			SendChatMessage("Welcome to the guild :D", "GUILD");		
		end
    end
end

function AG_Print(msg)
	print("\124cffffFF00[AG]\124r",msg);
end