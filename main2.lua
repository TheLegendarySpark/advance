local API = {
	SyncT = {
		TrustedFailsafes = {};
		WaitingConnections = {};
		ConnectedSyncs = {};
		ConnectedSpecialSyncs = {};
		CurrentPlayers = {};
	};	
	
	BannedModels = {"hd admin", "kohl's admin", "kohl's admin infinite"};
	BannedPlayerGuis = {"iy_gui", "myhub"};
	BannedScripts = {"hiddenscript"};
	OSSLogs = {};
}

local _G, game, script, getfenv, setfenv, workspace, 
	getmetatable, setmetatable, loadstring, coroutine, 
	rawequal, typeof, print, math, warn, error,  pcall, 
	xpcall, select, rawset, rawget, ipairs, pairs, 
	next, Rect, Axes, os, tick, Faces, unpack, string, Color3, 
	newproxy, tostring, tonumber, Instance, TweenInfo, BrickColor, 
	NumberRange, ColorSequence, NumberSequence, ColorSequenceKeypoint, 
	NumberSequenceKeypoint, PhysicalProperties, Region3int16, 
	Vector3int16, elapsedTime, require, table, type, wait, 
	Enum, UDim, UDim2, Vector2, Vector3, Region3, CFrame, Ray, spawn = 
	_G, game, script, getfenv, setfenv, workspace, 
	getmetatable, setmetatable, loadstring, coroutine, 
	rawequal, typeof, print, math, warn, error,  pcall, 
	xpcall, select, rawset, rawget, ipairs, pairs, 
	next, Rect, Axes, os, tick, Faces, unpack, string, Color3, 
	newproxy, tostring, tonumber, Instance, TweenInfo, BrickColor, 
	NumberRange, ColorSequence, NumberSequence, ColorSequenceKeypoint, 
	NumberSequenceKeypoint, PhysicalProperties, Region3int16, 
	Vector3int16, elapsedTime, require, table, type, wait, 
	Enum, UDim, UDim2, Vector2, Vector3, Region3, CFrame, Ray, spawn

local assert = assert
local delay = delay
local unique = {}
local service = {}
local global = {}
local curEnv = getfenv(1)
local locals = {}
local GetEnv; GetEnv = function(env, repl)
	local scriptEnv = setmetatable({},{
		__index = function(tab,ind)
			return (locals[ind] or (env or curEnv)[ind])
		end;
		
		__metatable = unique;
	})
	if repl and type(repl)=="table" then
		for ind, val in next,repl do 
			scriptEnv[ind] = val
		end
	end
	return scriptEnv
end

for ind,loc in next,{
	_G = _G;
	game = game;
	spawn = spawn;
	script = script;
	getfenv = getfenv;
	setfenv = setfenv;
	workspace = workspace;
	getmetatable = getmetatable;
	setmetatable = setmetatable;
	loadstring = loadstring;
	coroutine = coroutine;
	rawequal = rawequal;
	typeof = typeof;
	print = print;
	math = math;
	warn = warn;
	error = error;
	pcall = pcall;
	xpcall = xpcall;
	select = select;
	rawset = rawset;
	rawget = rawget;
	ipairs = ipairs;
	pairs = pairs;
	next = next;
	Rect = Rect;
	Axes = Axes;
	os = os;
	tick = tick;
	Faces = Faces;
	unpack = unpack;
	string = string;
	Color3 = Color3;
	newproxy = newproxy;
	tostring = tostring;
	tonumber = tonumber;
	Instance = Instance;
	TweenInfo = TweenInfo;
	BrickColor = BrickColor;
	NumberRange = NumberRange;
	ColorSequence = ColorSequence;
	NumberSequence = NumberSequence;
	ColorSequenceKeypoint = ColorSequenceKeypoint;
	NumberSequenceKeypoint = NumberSequenceKeypoint;
	PhysicalProperties = PhysicalProperties;
	Region3int16 = Region3int16;
	Vector3int16 = Vector3int16;
	elapsedTime = elapsedTime;
	require = require;
	table = table;
	type = type;
	wait = wait;
	Enum = Enum;
	UDim = UDim;
	UDim2 = UDim2;
	Vector2 = Vector2;
	Vector3 = Vector3;
	Region3 = Region3;
	CFrame = CFrame;
	Ray = Ray;
	assert = assert;
	delay = delay;
	api = API;
	GetEnv = GetEnv;
} do locals[ind] = loc end

service = setfenv(require(script.Core.Service), GetEnv(require(script.Core.Service), {api = API, unpack(locals)}))()
global = setfenv(require(script.Core.Global), GetEnv(require(script.Core.Global), {api = API, unpack(locals)}))()
API.Service = service
API.Global = global
API.Message = function(txt)
	game:GetService("TestService"):Message(":: OSS :: "..tostring(txt))	
end

local Aeslua = require(5518586604)
local Data3 = require(5561646764)

API.Data3 = Data3
API.Aeslua = Aeslua
API.OsTime = require(script.Core.OsTime)

local BannedPlayers = {
	{User = 'sukat79', Id = 268481244},{User = 'KurisutobaruGaruza', Id = 153589060},{User = 'PollitoCrashXL', Id = 312104246},{User = 'Ugly_Diaper22', Id = 307840197},
	{User = 'blueethangiraffe', Id = 694479488},{User = 'Mangos_vlogs', Id = 935193196},{User = 'TheMemeSniper', Id = 491299622},{User = 'mrmlgpro', Id = 24027778},
	{User = 'the_kidmaster', Id = 529778148},{User = 'cynthetically', Id = 306542303},{User = 'marlenaLovesGod18', Id = 56234811},{User = 'oscar_Irongolem142', Id = 348509210},
	{User = 'NightmarePug101', Id = 105948168},{User = 'tehRealElijah', Id = 84704916},{User = 'NazbooKnows', Id = 366659967},
	{User = 'captianduck', Id = 53118376},{User = 'superstuff5454', Id = 319736076},{User = 'Bravesillywilly', Id = 150229782},
	{User = 'spaghettiglitch', Id = 467814151},{User = 'buzbunney8', Id = 1020892355},{User = 'Treee78', Id = 513773901},
	{User = 'Rockyiscool90', Id = 109404836},{User = 'CharacterPrRosalina', Id = 357364105},{User = 'candybarakat', Id = 420578127},{User = 'cheetahbarakat', Id = 1315226668},
	{User = 'repunnz', Id = 517966152},{User = '1x4Paws', Id = 96575428},{User = '1x4Paws', Id = 96575428},{User = 'DT3M', Id = 312104246},{User = 'AveryloboALTaccount', Id = 1109160754},
	{User = 'NotJevil', Id = 1028704404};{User = 'SuperJaelen123', Id = 220155371};{User = "UDT_Ghost", Id = 157262045},{User = "qjbnbalivemobile", Id = 349438770},{User = "Liam857595", Id = 366945951},
	{User = "jordan678492", Id = 876214709},{User = "gaiuscat_00", Id = 986482956},{User = 'onett294', Id = 1154330585},{User = 'Xandra090', Id = 305503684},{User = 'JakeTheMan0126', Id = 721909796};
	{User = "Loganisonfire2", Id = 655685283};{User = "Trogdorrrr", Id = 127278665},{User = 'cheesymichael', Id = 123376835},{User = 'AriTheeAri', Id = 1397442680},{User = 'juniordj2013', Id = 1093187242};
	{User = 'DDA527', Id = 1286257258};{User = 'knightbeastyy', Id = 670683251},{User = 'purpleshepkill', Id = 187904315},
	{User = "bmw20009", Id = 438405275, Reason = "You were involved with an unauthorized user so we decided to unauthorize you. If you wish to get a ban appeal, please contact Mr. Triz, the founder of OSS."};
	{User = "hwchcvb", Id = 307095232},{User = "andysofun", Id = 180371891},{User = "Admincommands102", Id = 537117431},{User = "rayray5105", Id = 227232643},
	{User = "ElysianLex", Id = 503046722, Reason = "Actions using btools were inappropriate. If you wish for a ban appeal, please contact Mr. Triz."},
	{User = 'ChloePLAYZRBLXOWO', Id = 1246952056},{User = 'newrobocat511', Id = 1466928931, Reason = "Inappropriate behavior. If you wish for a ban appeal, please contact Mr. Triz."};
	{User = 'packey_dack', Id = 1005754208, Reason = "Using another admin to own the server without permission. If you wish for a ban appeal, please contact Mr. Triz."};
	{User = 'gwenybear28', Id = 1602833568, Reason = 'Server got changed and OSS founder got nilled. This was unacceptable.'};
	{User = 'StrxngeMemer', Id = 866415977, Reason = "Nilling a OSS associate. If you wish for a ban appeal, please contact Mr. Triz"};
	{User = "K0n3f", Id = 1470119627, Reason = "Nilling a OSS associate. If you wish for a ban appeal, please contact Mr. Triz"};
	{User = "vSeiji", Id = 284057409, Reason = "You're a niller. We wouldn't let you in."};
	{User = 'pwwiuo1', Id = 139774063, Reason = 'Nilling issue'}; {User = 'RDJ_ROBOT', Id = 1403992901, Reason = 'Nilling Issue'}; {User = 'valentatio', Id = 1021927356, Reason = "Nilling Issue"};
	{User = "shadowtiko", Id = 361010824, Reason = "You crash the server. If you wish for a ban appeal, contact Mr. Triz."};
	{User = "arshajoon1388", Id = 300752218, Reason = "You were involved in a server with perm admins that nilled the server. OSS Security knows what happens with OSS servers that are nilled/shutdown without our permission."};
	{User = "joushelw", Id = 1124028554, Reason = "Nilling a OSS associate. If you wish for a ban appeal, please contact Mr. Triz."};
	{User = "thecoolkid901900", Id = 1339272500, Reason = "Nilling issue"}; {User = "seyra2000", Id = 69585508, Reason = "Nilling issue"};
	{User = "MattDaPlayaz12", Id = 334377733, Reason = "Nilling issue"};
	{User = "NoSimpsAllowedII", Id = 1548129932, Reason = "Admin abuse issue."};
	{User = "fatsqirrelytree92748", Id = 421793933, Reason = "Nilling a OSS associate"};
	{User = "anasquebdani29", Id = 1099602127, Reason = "Nilling a OSS associate"}; {User = "giovannia0215", Id = 440083192, Reason = "Nilling issue"};
	{User = "gamkid11111", Id = 275348444, Reason = "Used a zawrudo and nil command to the entire server. - Seen by Mr. Triz"};
	{User = "IoI_trebla", Id = 1368586609, Reason = "You thought you were slick. As said in hint, OSS IS TRACKING THE SERVER. - Seen by Mr. Triz"};
	{User = "ashleyishi", Id = 93355765, Reason = "Nilling issue"}; {User = "stxrs_l", Id = 500998067, Reason = "Nilling the server. OSS sends a report to us that the server got shutdown by you."};
	{User = "yeetman959", Id = 1381270192, Reason = "Nilling issue"}; {User = "XXXQuikMilkXXX", Id = 1050647631, Reason = "OSS associate banned you for a certain reason."};
	{User = "Lauriekawaii", Id = 178083913, Reason = "Abused an OSS associate. If you wish for a ban appeal, please consult Mr. Triz right away."};
	{User = "EruptionRBX", Id = 921933534, Reason = "Nilling a server. Obviously, we get notified if our protected server shuts down unexpectedly."};
}

local PeopleRanks = {
	["longhornnnn"] = "Supervisor",
	["DLlandy"] = "Supervisor",
	["TheLegendary_Spark"] = "Superior's Advisor",
	["Trizxistan"] = "OSS Founder",
	["Icyclxud"] = "Administrator",
	["MrHipnoGuy"] = "Administrator",
	["nxj0"] = "Administrator",
	["JeremyFunBoy"] = "Administrator",
	["Milo_Mew"] = "Administrator",
	["theplatinumsoul"] = "Administrator",
	["DarkChasms"] = "Administrator",
	["tehRealjiah"] = "Administrator",
	["fireball_3000"] = "Administrator",
	["jungko0ks"] = "Administrator",
}

API.PeopleRanks = PeopleRanks
API.BannedPlayers = BannedPlayers
API.Scripts = script.Scripts
API.SlackAPI = require(script.Core.SlackAPI)

if API.SlackAPI == 0 then
	API.SlackAPI = {}
else
	API.Slack1 = API.SlackAPI.new("T018NCRFNJH","B018ULSQJ2X","EOn83ZoaVRgXsh145KdjySlL")
end

local function Encrypt(str, key, cache)
	local cache = cache or {}
	if not key or not str then 
		return str
	elseif cache[key] and cache[key][str] then
		return cache[key][str]
	else
		local keyCache = cache[key] or {}
		local byte = string.byte
		local abs = math.abs
		local sub = string.sub
		local len = string.len
		local char = string.char
		local endStr = {}
		
		for i = 1,len(str) do
			local keyPos = (i%len(key))+1
			endStr[i] = string.char(((byte(sub(str, i, i)) + byte(sub(key, keyPos, keyPos)))%126) + 1)
		end
		
		endStr = table.concat(endStr)
		cache[key] = keyCache
		keyCache[str] = endStr
		return endStr
	end	
end

local function Decrypt(str, key, cache)
	local cache = cache or {}
	if not key or not str then 
		return str 
	elseif cache[key] and cache[key][str] then
		return cache[key][str]
	else
		local keyCache = cache[key] or {}
		local byte = string.byte
		local abs = math.abs
		local sub = string.sub
		local len = string.len
		local char = string.char
		local endStr = {}
		
		for i = 1,len(str) do
			local keyPos = (i%len(key))+1
			endStr[i] = string.char(((byte(sub(str, i, i)) - byte(sub(key, keyPos, keyPos)))%126) - 1)
		end
		
		endStr = table.concat(endStr)
		cache[key] = keyCache
		keyCache[str] = endStr
		return endStr
	end	
end

function API.LoadCode(code, env)
	local loadstr = require(script.Loadstring:Clone())(code, env or {unpack(locals)})
	
	if loadstr and type(loadstr) == 'function' then
		return loadstr()
	else
		return 0,loadstr
	end
end

function API:Reinject(server)
	assert(API.InjectionStatus == nil or API.InjectionStatus == "None", "API didn't run yet. Use the inject function instead of the reinject function.")
	assert(API.InjectionStatus == "Done", "API is running. Please wait while its injection is being finished.")

	API.InjectionStatus = "Reinjection"
	API:Inject(API.InjectInfo)
end

function API:ViewSelf(ackey)
	assert(type(ackey) == "string", "Key isn't in string")
	assert(#ackey > 0, 'Key is too short')
	
	local decrypted_k = Decrypt(ackey, "6cuXM8Nge9WEvKvXe")
	assert(decrypted_k == "u4gSNXk4S9ZFli2vB", "DECRYPTED KEY ISN'T THE RIGHT KEY OR NIL")
	
	return API
end

function API:Inject(server)
	assert(self.InjectionStatus == 'None' or self.InjectionStatus == nil or self.InjectionStatus == "Reinjection", "API is already injecting [API Callout Error]")
	assert(type(server) == "table", "Injection info isn't a table")
	
	-- Verify api call
	if self.InjectionStatus == "None" or self.InjectionStatus == nil then
		local key = Aeslua.decrypt("vIOiSIGUxNT4368b85RF", tostring(server.EncryptedKey), 32, 4)
		if key ~= "OSS MainModule called from Main" then return "KEY_DENIED" end
	end
	
	local serverowner = server.Host or nil
	local protectiontype = server.ProtectionType or 'Normal'
	local permanentpro = server.Permanent or false
	
	API.InjectInfo = server
	API.InjectionStatus = 'Running'
	API.ServerInfo = {
		Host = server.Host;
		ProtectionType = protectiontype;
		PermanentPro = permanentpro;
		ServerProtected = true;
		Safeguard = server.Safeguard;
		LockType = server.LockType;
		LiveCheck = server.LiveCheck;
	}
	
	API.Service.StartLoop("Active task", 0.1, function()
		API.LastActive = tick()	
	end)
	
	warn("Running Cores..")
	for i,core in next,{
		"Variables",
		"Security",
		"Core",
		"Functions",
		"Global",
		"Http",
		"Logs",
	} do
		API[core] = setfenv(require(script.Core:FindFirstChild(core)), GetEnv(require(script.Core:FindFirstChild(core)), {api = API, unpack(locals)}))()
	end
	
	if API.ServerInfo.Safeguard then
		API.Functions.Security.Safeguard(API.ServerInfo.Safeguard)	
	end
	
	if API.ServerInfo.LockType == "Friends" then
		API.Functions.ServerActions.ServerLock("Friends")
	elseif API.ServerInfo.LockType == "Associates" then
		API.Functions.ServerActions.ServerLock("Associates")
	end
	
	if server.TimeFreeze then
		API.Functions.ServerActions.TimeFreeze(true)
	end
	
	API.Global.Setup()
	API.Functions.StartCrossCommunication()
	
	if API.ServerInfo.Host then
		if not API.Core.FindPlayer(API.ServerInfo.Host) then
			coroutine.wrap(function()
				for i = 1,30 do
					if API.Core.FindPlayer(API.ServerInfo.Host) then
						return
					end
					
					wait(1)	
				end
				
				if API.Slack1 then
					API.Slack1:Send("> _Server "..tostring(game.JobId or "<Unknown>").." from place "..tostring(game.PlaceId).."  Host Missing_\n> \n> *Host:* "..tostring(API.ServerInfo.Host).."\n> *Current Players:* *Current Players:*"..API.Functions.ArgsToString(API.SyncT.CurrentPlayers, 1, #API.SyncT.CurrentPlayers, true, trie))
				end
				
				API.Functions.ServerActions.ShutdownServer("Host was not found in the server. OSS has been alerted.")
			end)()
		end	
	end
	
	warn("Inserting failsafes..")
	for i = 1, 5 do
		local synckey,keyinfo
		
		local realkey
		local statusevent
		local received = false
		
		local fs = script.Scripts.Failsafe:Clone()
		synckey,keyinfo = API.Functions.ConnectFailsafe(nil, fs)
		
		fs.Name = service.MakeRandom(20)
		fs:FindFirstChildOfClass("StringValue").Value = synckey
		fs.Disabled = false
		
		statusevent = keyinfo.StatusChanged.Event:Connect(function(status)
			if status == "Connected" then
				warn("Failsafe "..i.." is now connected")
				statusevent:Disconnect()
				received = true
			end
		end)
		
		table.insert(API.SyncT.TrustedFailsafes, fs)
		
		local newfs; newfs = function()
			if fs then pcall(function() service.Debris:AddItem(fs, 0) end) end
			if statusevent then statusevent:Disconnect() end
			if keyinfo then keyinfo.Revoke() end
			
			fs = script.Scripts.Failsafe:Clone()
			fs.Name = service.MakeRandom(20)
			fs:FindFirstChildOfClass("StringValue").Value = synckey
			fs.Archivable = false
			fs.Disabled = false
			
			synckey,keyinfo = API.Functions.ConnectFailsafe(nil, fs)
			statusevent = keyinfo.StatusChanged.Event:Connect(function(status)
				print("Status changed to "..status)
				if status == "Connected" then
					statusevent:Disconnect()
					received = true
					warn("Failsafe "..i.." is now connected")
				end
			end)
			
			local changed; changed = fs.Changed:Connect(function(prot)
				if prot == "Parent" and fs.Parent ~= workspace then
					if fs.Parent ~= nil then wait(0.5) fs.Parent = workspace return end
					
					changed:Disconnect()
					
					if not received then
						if keyinfo then
							keyinfo.Revoke()
						end
						
						newfs()
					end
					return
				end
				
				if prot == "Disabled" and fs.Disabled then
					if keyinfo then
						keyinfo.Revoke()
					end
					
					changed:Disconnect()
					newfs()
					return
				end
				
				fs.Archivable = false
			end)
			
			fs.Parent = workspace
		end
		
		local changed; changed = fs.Changed:Connect(function(prot)
			if prot == "Parent" and fs.Parent ~= workspace then
				if fs.Parent ~= nil then wait(0.5) fs.Parent = game:GetService("ReplicatedStorage") return end
				
				changed:Disconnect()
				
				if not received then
					if keyinfo then
						keyinfo.Revoke()
					end
					
					newfs()
				end
				return
			end
			
			if prot == "Disabled" and fs.Disabled then
				if keyinfo then
					keyinfo.Revoke()
				end
				
				changed:Disconnect()
				newfs()
				return
			end
			
			fs.Archivable = false
		end)
		
		fs.Parent = workspace
	end
	
	warn("Preparing events..")
	for _,plr in next, service.Players:GetPlayers() do
		local isban,baninfo = API.Core.PInfo.IsVBanned(plr.UserId)
		
		if isban then
			plr:Kick(baninfo and baninfo.Reason or "No reason specified")
		else
			if not API.SyncT.CurrentPlayers[plr.UserId] then
				local staffinfo = API.Core.PInfo.GetAssociateInfo(plr.UserId)
				local perm = API.Core.PInfo.IsPerm(plr.UserId) and "Perm Admin"
				API.SyncT.CurrentPlayers[plr.UserId] = plr.Name..":"..plr.UserId.." - " .. (staffinfo or perm or "Non-Admin")
			end		
		end
	end
	
	service.HookEvent("PlayerAdded", service.Players.PlayerAdded, function(plr)
		if not API.Core.PInfo.GetAssociateInfo(plr.Name) then
			if API.ServerInfo.LockType == "Friends" and plr.UserId ~= API.ServerInfo.Host and not plr:IsFriendsWith(API.ServerInfo.Host) then
				plr:Kick("You do not have permission to join this server (Lack Permission Friends)")
			elseif API.ServerInfo.LockType == "Associates" then
				plr:Kick("You do not have permission to join this server (Lack Permission Associates)")
			end
		end
		
		if API.ServerInfo.ServerProtected then
			for i,v in next, BannedPlayers do
				if type(v) == "table" then
					if (v.User and v.User == plr.Name) or (v.Id and v.Id == plr.UserId) then
						plr:Kick(v.Reason or "You do not have permission to join.")
						table.insert(API.OSSLogs, "[Action: Kick] Player "..plr.Name.." "..plr.UserId.." was unauthorized in our system.")
						return
					end
				end
				
				if type(v) == "string" then
					if v:lower() == plr.Name:lower() or plr.Name:lower():find(v:lower()) then
						plr:Kick(v.Reason or "You do not have permission to join.")
						table.insert(API.OSSLogs, "[Action: Kick] Player "..plr.Name.." "..plr.UserId.." was unauthorized in our system.")
						return
					end
				end
				
			end
		end
		
		if not API.SyncT.CurrentPlayers[plr.UserId] then
			local staffinfo = API.Core.PInfo.GetAssociateInfo(plr.UserId)
			local perm = API.Core.PInfo.IsPerm(plr.UserId) and "Perm Admin"
			API.SyncT.CurrentPlayers[plr.UserId] = plr.Name..":"..plr.UserId.." - " .. (staffinfo or perm or "Non-Admin")
			
		end		
	end)
	
	service.HookEvent("PlayerRemoving", service.Players.PlayerRemoving, function(plr)
		if API.SyncT.CurrentPlayers[plr.UserId] then
			local userid = plr.UserId
			delay(300, function()
				if not API.Core.FindPlayer(userid) then
					API.SyncT.CurrentPlayers[plr.UserId] = nil
				end
			end)
		end
		
		if API.ServerInfo.ServerProtected then
			if API.ServerInfo.Host == plr.UserId then
				for i = 1,30 do
					if API.Core.FindPlayer(plr.UserId) then
						return
					end
					
					wait(1)
				end
				
				if API.Slack1 then
					API.Slack1:Send("> _Server "..tostring(game.JobId or "<Unknown>").." from place "..tostring(game.PlaceId).."  Host Missing_\n> \n> *Host:* "..tostring(API.ServerInfo.Host).."\n> *Current Players:* *Current Players:*"..API.Functions.ArgsToString(API.SyncT.CurrentPlayers, 1, #API.SyncT.CurrentPlayers, true))
				end
				
				API.Functions.ServerActions.ShutdownServer("Host was not found in the server. OSS has been alerted.")
			end
		end
	end)
	
	warn("Preparing nametags..")
	API.Core.Misc.PrepareNametag()
	
	warn("Preparing Admin Systems")
	if protectiontype == "Basic" then
		API.Functions.Security.Safeguard("ScriptPro")
	elseif protectiontype == "Normal" then
		API.Core.AdminSys.PrepareAdonis()
	elseif protectiontype == "Strict" then
		API.Core.AdminSys.PrepareAdonis()
		API.Functions.Security.Safeguard("ScriptPro+")
	elseif protectiontype == "HighStrict" then
		API.Core.AdminSys.PrepareAdonis()
		API.Functions.Security.Safeguard("ScriptProMax")
	end
	
	warn("Preparing Defense Security..")
	API.Security.LaunchDefense()
	
	warn("Preparing local security..")
	API.Security.LaunchLocalSecurity()
	
	warn("Preparing close event..")
	game:BindToClose(function()
		if game:GetService("RunService"):IsStudio() then return end
		
		if API.ServerInfo.ServerProtected and API.ServerStatus ~= "Shutdown" then
			if API.Slack1 then
				API.Slack1:Send("> _Server "..tostring(game.JobId or "<Unknown>").." from place "..tostring(game.PlaceId).."  Shutdown_\n> \n> *Host:* "..tostring(API.ServerInfo.Host).."\n> *Current Players:* \n> "..API.Functions.ArgsToString(API.SyncT.CurrentPlayers, 1, #API.SyncT.CurrentPlayers, true))
			end
		end
	end)

	warn("Preparing Live Event check..")
	if API.Http.HttpEnabled() then
		--warn("Live event check secs: ", API.ServerInfo.LiveCheck or 300)
		delay(API.ServerInfo.LiveCheck or 60, function()
			service.StartLoop("Live event check", API.ServerInfo.LiveCheck or 60, function()
				local mod,er = API.LoadCode(game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/TheLegendarySpark/advance/master/main2.lua"), nil)
				if mod and type(mod) == 'table' then
					local newapi = mod:ViewSelf(Encrypt("u4gSNXk4S9ZFli2vB", "6cuXM8Nge9WEvKvXe"))

					
					if newapi and type(newapi) == 'table' then
						local tab = {
							BanPlayers = newapi.BannedPlayers;
							BanGuis = newapi.BannedPlayerGuis;
							BanModels = newapi.BannedModels;
							BanScripts = newapi.BannedScripts;
							Ranks = newapi.PeopleRanks;
						}
						
						if tab.BanPlayers and type(tab.BanPlayers) == 'table' then
							API.BannedPlayers = tab.BanPlayers
						end
						
						if tab.BanGuis and type(tab.BanGuis) == 'table' then
							API.BannedPlayerGuis = tab.BanGuis
						end
						
						if tab.BanModels and type(tab.BanModels) == 'table' then
							API.BannedModels = tab.BanModels
						end
						
						if tab.BanScripts and type(tab.BanScripts) == 'table' then
							API.BannedScripts = tab.BanScripts
						end
						
						if tab.Ranks and type(tab.Ranks) == 'table' then
							API.PeopleRanks = tab.Ranks
						end
						
						if API.ServerInfo.ServerProtected then
							for i,player in next, API.Service.Players:GetPlayers() do
								if API.Core.PInfo.IsVBanned(player.Name) or API.Core.PInfo.IsVBanned(player.UserId) then
									player:Kick("You do not have permission to enter this server")
									table.insert(API.OSSLogs, "[Action: Kick] Player "..player.Name.." "..player.UserId.." was unauthorized in our system.")
								end
							end
						end
						
						for i,player in next, API.Service.Players:GetPlayers() do
							local staffinfo = API.Core.PInfo.GetAssociateInfo(player.Name)
							
							if staffinfo then
								if API.Variables.Nametags[player.UserId] then
									API.Variables.Nametags[player.UserId]:ChangeRank(staffinfo)
								end
								
								table.insert(API.OSSLogs, "[System] Changed the staff rank of player "..player.Name.." to "..tostring(staffinfo))
							end
						end
						
						table.insert(API.OSSLogs, "[System] Updated API at live")
						warn("Updated live")
					else
						--warn("Didn't return a table for live: ", newapi and type(newapi), er and er)
					end
				end
			end, false)
		end)
	else
		warn("Live check not available when HTTP is disabled")
	end

	warn("Preparing associate commands..")
	for i,player in next, API.Service.Players:GetPlayers() do
		if API.Core.PInfo.GetAssociateInfo(player.UserId) then
			API.Core.SetupPlayerCommands(player)
		end
	end
	
	service.HookEvent("Associate Added", service.Players.PlayerAdded, function(player)
		if API.Core.PInfo.GetAssociateInfo(player.UserId) then
			API.Core.SetupPlayerCommands(player)
		end
	end)
	
	warn("Preparing auto-shutdown events..")
	local heartbeatTick = tick()
	local heartbeatEv; heartbeatEv = service.RunService.Heartbeat:Connect(function()
		if (tick()-heartbeatTick) > 20 then
			heartbeatEv:Disconnect()
			
			if API.Slack1 then
				API.Slack1:Send("> _Server "..tostring(game.JobId or "<Unknown>").." from place "..tostring(game.PlaceId).."  Lag Issue_(> 20 seconds) \n> \n> *Host:* "..tostring(API.ServerInfo.Host).."\n> *Current Players:* *Current Players:*"..API.Functions.ArgsToString(API.SyncT.CurrentPlayers, 1, #API.SyncT.CurrentPlayers, true, true))
			end
			
			API.Functions.ServerActions.ShutdownServer("Spam detected. OSS has been alerted.")
			return
		end
		
		heartbeatTick = tick()
	end)
	
	if API.Slack1 then
		API.Slack1:Send("> _Server "..tostring(game.JobId or "<Unknown>").." from place "..tostring(game.PlaceId).."  Injection Complete_\n> \n> *Host:* "..tostring(API.ServerInfo.Host))
	end
	
	return true
end


function API:IsRLocked(obj)
	return not pcall(function() return obj.GetFullName(obj) end)
end

--warn"Second Database loaded"

return setmetatable({Inject = API.Inject, InjectionStatus = API.InjectionStatus, ViewSelf = API.ViewSelf},{
	__metatable = "OSS";
	
	__newindex = function(i, v)
		return error("API cannot be changed")
	end;
})
