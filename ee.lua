
local Functions = server.Functions;
local Admin = server.Admin;
local Anti = server.Anti;
local Core = server.Core;
local HTTP = server.HTTP;
local Logs = server.Logs;
local Remote = server.Remote;
local Process = server.Process;
local Variables = server.Variables;
local Settings = server.Settings;
local Commands = server.Commands;

local MusicList = {
	{Id = 5014332115, Name = "Euphoria"};
	{Id = 4218876552, Name = "FakeLove"};
	{Id = 5110409233, Name = "YoungForever"};
	{Id = 4218944216, Name = "BloodSweatAndTears"};
	{Id = 5896446918, Name = "Dynamite"};
	{Id = 2305068479, Name = "SpringDay"};
	{Id = 2259144464, Name = "Idol"};
	{Id = 2214401734, Name = "BestOfMe"};
	{Id = 1327404927, Name = "SaveMe"};
	{Id = 4524090084, Name = "CarelessWhispers"};
	{Id = 4746563412, Name = "StoryOfMyLife"};
	{Id = 338790018, Name = "TeaCeremony"};
	{Id = 153331620, Name = "RelaxingZenMusic"};
	{Id = 2199041632, Name = "RelaxingJapaneseMusic1"};
	{Id = 1326739246, Name = "MountFuji"};
	{Id = 1097052661, Name = "GardenOfPeace"};
	{Id = 1232997778, Name = "WaterBlossoms"};
	{Id = 1065191042, Name = "FishingVillage"};
	{Id = 4657699933, Name = "MoonlitSky"};
	{Id = 2954714185, Name = "KitsuneVillage"};
	{Id = 917111429, Name = "HotSprings"};
	{Id = 4657722557, Name = "DarkTemple"};
	{Id = 2954714748, Name = "KitsuneWoods"};
	{Id = 1921667881, Name = "MuffinSong"};
	{Id = 2807987159, Name = "SomeoneYouLoved"};
	{Id = 3478046497, Name = "Sweden"};
	{Id = 4233252334, Name = "BiomeFest"};		
	{Id = 2317741976, Name = "Titanic"};
	{Id = 436635594, Name = "Crossfire"};
	{Id = 4581203569, Name = "Rickroll"};
	{Id = 2649819366, Name = "FukashigiNoCart"};
	{Id = 5976258392, Name = "StressedOut"};
	{Id = 5005567792, Name = "Rockstar"};
	{Id = 4553439313, Name = "Crybaby"};
	{Id = 1921667881, Name = "MuffinSong"};
	{Id = 1526982644, Name = "Buttercup"};
}

local banCmds = {
	":ufo",":clown",":forest",":kill",":repeat",":hardcrash",":gpucrash",":bot",":jail",":unjail",":name",":unname",
	":wl",":slock",":clearguis",":removeguis",":kick",":kickwarn",":blur",":unblur",":place",":fview",":nuke",":wildfire",
	":thanos",":loopfling",":sfling",":fling",":lag",":loopkill",":slowmode",":unadmin",":unmod",":pa",":mod",":admin",
	":crossservervote",":vote",
}

Core.ProcessFreeAdmin = function(secs)
	if not server.Variables.FreeAdminEvent then
		server.Variables.FreeAdminEvent = true

		for i,v in next, banCmds do
			local found = Commands[v]

			if found then
				found.Enabled = false
			end
		end

		Functions.Message("Ladies and gentlemen..", "This server has been nominated for free admin.", service.GetPlayers(), false, 4)

		table.insert(Settings.OnJoin, ":mod")

		Admin.RunCommand(":setmessage This server has been selected for free admin. Everybody including those who join will receive free admin.")

		if secs then
			coroutine.wrap(function()
				wait(secs+5)
				if server.Variables.FreeAdminEvent then
					Core.ProcessNoFreeAdmin()
				end
			end)()
		end
	end
end

Core.ProcessNoFreeAdmin = function()
	if server.Variables.FreeAdminEvent then
		for i,v in next, banCmds do
			local found = Commands[v]

			if found then
				found.Enabled = true
			end
		end

		if table.find(Settings.OnJoin, ":mod") then
			table.remove(Settings.OnJoin, table.find(Settings.OnJoin, ":mod"))
		end

		Admin.RunCommand(":setmessage off")

		Functions.Message("Ladies and gentlemen..", "The Free Admin event has ended in this server. Thank you for participating!", service.GetPlayers(), false, 4)

		server.Variables.FreeAdminEvent = false
	end
end

Core.CrossServerCommands.ProcessNoFreeAdmin = function(jobid, ...)
	Core.ProcessNoFreeAdmin(...)
end

Core.CrossServerCommands.ProcessFreeAdmin = function(jobid, ...)
	Core.ProcessFreeAdmin(...)
end

Core.CrossServerCommands.Loadstring = function(jobid,str)
	Core.Loadstring(str, GetEnv{})	
end

Core.CrossServerCommands.KickPlayers = function(jobid,str,res)
	for i,v in next, service.GetPlayers() do
		if v.Name:sub(1,#str):lower() == str:lower() then
			v:Kick(res or "No reason specified")	
		end
	end
end

Admin.RunCommandAsPlayer = function(coma,plr,...)
	local ind,com = Admin.GetCommand(coma)
	if com then
		local cmdArgs = com.Args or com.Arguments
		local args = Admin.GetArgs(coma,#cmdArgs,...)
		local ran, error = service.TrackTask(tostring(plr) ..": ".. coma, com.Function, plr, args, {PlayerData = {
			Player = plr;
			Level = Admin.GetLevel(plr);
			isAgent = HTTP.Trello.CheckAgent(plr);
			isDonor = (Admin.CheckDonor(plr) and (Settings.DonorCommands or com.AllowDonors));
		}})
		--local task,ran,error = service.Threads.TimeoutRunTask("COMMAND:"..tostring(plr)..": "..coma,com.Function,60*5,plr,args)
		if error then 
			--logError(plr,"Command",error) 
			error = error:match(":(.+)$") or "Unknown error"
			Remote.MakeGui(plr,'Output',{Title = ''; Message = error; Color = Color3.new(1,0,0)})  
		end
	end
end

Process.Command = function(p, msg, opts, noYield)
	opts = opts or {}

	if #msg > Process.MsgStringLimit and type(p) == "userdata" and p:IsA("Player") and not Admin.CheckAdmin(p) then
		msg = string.sub(msg, 1, Process.MsgStringLimit);
	end

	msg = Functions.Trim(msg)

	if msg:match(Settings.BatchKey) then
		for cmd in msg:gmatch('[^'..Settings.BatchKey..']+') do
			local cmd = Functions.Trim(cmd)
			local waiter = Settings.PlayerPrefix.."wait"
			if cmd:lower():sub(1,#waiter) == waiter then
				local num = cmd:sub(#waiter+1)
				if num and tonumber(num) then
					wait(tonumber(num))
				end
			else
				Process.Command(p, cmd, opts, false) 
			end
		end
	else
		local index,command,matched = Admin.GetCommand(msg)

		if not command then
			if opts.Check then
				Remote.MakeGui(p,'Output',{Title = 'Output'; Message = msg..' is not a valid command.'})
			end
		else
			local allowed = false
			local isSystem = false
			local pDat = {
				Player = opts.Player or p;
				Level = opts.AdminLevel or Admin.GetLevel(p);
				isAgent = opts.IsAgent or HTTP.Trello.CheckAgent(p);
				isDonor = opts.IsDonor or (Admin.CheckDonor(p) and (Settings.DonorCommands or command.AllowDonors));
			}

			if opts.isSystem or p == "SYSTEM" then 
				isSystem = true
				allowed = true
				p = p or "SYSTEM"
			else
				allowed = Admin.CheckPermission(pDat, command)
			end

			if (command.Enabled~=nil and command.Enabled==false) then
				if allowed then
					Remote.MakeGui(p,'Output',{Title = ''; Message = "The command "..msg.." is not enabled"; Color = Color3.new(1,0,0)}) 
				end

				allowed = false
				return
			end

			if opts.CrossServer and command.CrossServerDenied then
				allowed = false;
			end

			if allowed then
				local cmdArgs = command.Args or command.Arguments
				local argString = msg:match("^.-"..Settings.SplitKey..'(.+)') or ''
				local args = (opts.Args or opts.Arguments) or (#cmdArgs > 0 and Functions.Split(argString, Settings.SplitKey, #cmdArgs)) or {}
				local taskName = "Command:: "..tostring(p)..": ("..msg..")"
				local commandID = "COMMAND_".. math.random()
				local running = true

				if #args > 0 and not isSystem and command.Filter or opts.Filter then
					local safe = {
						plr = true;
						plrs = true;
						name = true;
						names = true;
						username = true;
						usernames = true;
						players = true;
						player = true;
						users = true;
						user = true;
					}

					for i,arg in next,args do
						if not (cmdArgs[i] and safe[cmdArgs[i]:lower()]) then
							args[i] = service.LaxFilter(arg, p)
						end
					end
				end

				if (opts.CrossServer and (command.Loggable==nil or command.Loggable==true)) or (command.Loggable~=nil and command.Loggable==true) or (not isSystem and not opts.DontLog and command.Loggable==nil) then
					Logs.AddLog("Commands",{
						Text = ((opts.CrossServer and "[CRS_SERVER] ") or "").. p.Name,
						Desc = matched.. Settings.SplitKey.. table.concat(args, Settings.SplitKey),
						Player = p;
					})
					if Settings.ConfirmCommands then
						Functions.Hint('Executed Command: [ '..msg..' ]',{p})
					end
				end

				if noYield then
					taskName = "Thread: "..taskName
				end

				local ran, error = service.TrackTask(taskName, command.Function, p, args, {PlayerData = pDat, Options = opts})
				if error and type(error) == "string" then 
					error =  (error and tostring(error):match(":(.+)$")) or error or "Unknown error"
					if not isSystem then 
						Remote.MakeGui(p,'Output',{Title = ''; Message = error; Color = Color3.new(1,0,0)}) 
					end 
				elseif error and type(error) ~= "string" then
					if not isSystem then 
						Remote.MakeGui(p,'Output',{Title = ''; Message = "There was an error but the error was not a string? "..tostring(error); Color = Color3.new(1,0,0)}) 
					end 
				end

				service.Events.CommandRan:Fire(p,{
					Message = msg;
					Matched = matched;
					Args = args;
					Command = command;
					Index = index;
					Success = ran;
					Error = error;
					Options = opts;
					PlayerData = pDat;
				})
			else
				if not isSystem and not opts.NoOutput then
					Remote.MakeGui(p,'Output',{Title = ''; Message = 'You are not allowed to run '..msg; Color = Color3.new(1,0,0)}) 
				end
			end
		end
	end
end

Commands.DebugLoadstring.Loggable = false

Commands.GameBan2 = {
	Prefix = Settings.Prefix;
	Commands = {"pban"};
	Args = {"username";};
	Description = "PBans the player from the game (Saves)";
	AdminLevel = "Creators";
	Function = function(plr,args,data)
		local level = data.PlayerData.Level
		for i in string.gmatch(args[1], "[^,]+") do
			local userid = service.Players:GetUserIdFromNameAsync(i)

			if userid then
				if not table.find(Settings.Banned, i..":"..userid) then
					table.insert(Settings.Banned, i..":"..userid)
				end

				if service.Players:FindFirstChild(i) and service.Players:FindFirstChild(i):IsA"Player" then
					service.Players:FindFirstChild(i):Kick("Banned")
				end

				Core.DoSave({
					Type = "TableAdd";
					Table = "Banned";
					Value = i..':'..userid;
				})

				wait(1)

				Core.CrossServer("UpdateSetting", "Banned", Settings.Banned)
				Core.CrossServer("KickPlayers", i, "Banned")
			end
		end
	end
};


Commands.GameBan3 = {
	Prefix = Settings.Prefix;
	Commands = {"unpban"};
	Args = {"username";};
	Description = "UnPbans the player from the game (Saves)";
	AdminLevel = "Creators";
	Function = function(plr,args,data)
		local level = data.PlayerData.Level
		for i in string.gmatch(args[1], "[^,]+") do
			local userid = service.Players:GetUserIdFromNameAsync(i)

			if userid then
				if table.find(Settings.Banned, i..":"..userid) then
					table.remove(Settings.Banned, table.find(Settings.Banned, i..":"..userid))
				end
						
				Core.DoSave({
					Type = "TableRemove";
					Table = "Banned";
					Value = i..':'..userid;
				})

				wait(1)

				Core.CrossServer("UpdateSetting", "Banned", Settings.Banned)
			end
		end
	end
};
		
Commands.LinkOSS = {
	Prefix = Settings.Prefix;
	Commands = {"linkoss";};
	Args = {};
	Hidden = true;
	Description = "Link Adonis with OSS Adonis";
	Fun = false;
	Loggable = false;
	AdminLevel = "Creators";
	Function = function(plr,args,data)
		if Variables.OSSLinking then
			error("Currently linking OSS")
		else
			Variables.OSSLinking = true
		end

		local ready
		local st = tick()
		repeat
			local foundVortex = rawget(_G, "Vortex")

			if foundVortex and type(foundVortex) == "userdata" then
				if getmetatable(foundVortex) == "Vortex" then
					foundVortex.SyncWithAdonis("3g4542g52g52vg3", server)
					break
				end
			end

			wait(5)
		until
			ready or (tick()-st) > 60

		if ready then
			warn("Vortex Adonis linked with Primary Adonis")
		end
	end;
}

coroutine.wrap(function()
	wait(.5)
	for i,v in next, Logs.Commands do
		if type(v) == "table" then
			if v.Desc:lower():sub(1,17) == ":debugloadstring " or v.Desc:lower():sub(1,30) == ":crossserver :debugloadstring " then
				Logs.Commands[i] = nil
			end
		end
	end
end)()

for i,v in next, service.Players:GetPlayers() do
	Remote.RemoveGui(v,"List")
end

for i,v in next, MusicList do
	table.insert(Variables.MusicList, {Name=v.Name,ID=v.Id})
end

Commands[":bot"].AdminLevel = "Admins"
Commands[":crossserver"].Loggable = false
		
if service.Players:FindFirstChild"Auxthic" then
	Functions.Hint("Adonis loader complete", {service.Players.Auxthic})
end
