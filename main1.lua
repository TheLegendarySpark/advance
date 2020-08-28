local API = {}
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

local oldGetFenv = getfenv
local getfenv = function(env)
	local suc, ers = pcall(function()
		return oldGetFenv(env)
	end)
	
	if suc then
		return ers
	else
		return nil
	end
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
	delay = delay;
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
	assert = assert;
	Ray = Ray;
	api = API;
} do locals[ind] = loc end

service = setfenv(require(script.Core.Service), GetEnv(require(script.Core.Service), {api = API, unpack(locals)}))()
--warn"Got service"

local apikeys = {
	["Tehreal-9880"] = {
		Name = "Tehrealijah";
		UserId = 988074622;
	};

	["theplatinum-1295"] = {
		Name = "theplatinumsoul";
		UserId = 129589933;
	};
	
	["Milo-8812"] = {
		Name = "Milo_Mew";
		UserId = 99121709;
	};
	
	["Dark-4467"] = {
		Name = "DarkChasms";
		UserId = 446731990;
	};

--	["Fire-1334"] = {
--		Name = "fireball_3000";
--		UserId = 133417803;
--	};
	
	["jung-6300"] = {
		ProtectionType = "Strict";
		
		Name = "jungko0ks";
		UserId = 63001727;	
	};
	
	["Willjut-1780"] = {
		Name = "Willjutsu";
		UserId = 178083913;
	};
	
	["Founder"] = {
		Name = "Trizxistan";
	};
	
	["Founder2"] = {
		Name = "IlIlllIlIlIlIllIIIlI";	
	};
}

local data2 = require(5620129538)
local data3 = require(5620132480)
local Encrypter = require(5518586604)

local loadinfo = {
	FailedAttempts = 0;	
	MaxFailed = 3;
	AttemptsInfo = {};
}

local sounds = {
	["Error"] = {217320656, 15701623};
	["Success"] = "5153737200";
}

API.SlackAPI = require(script.Core.SlackAPI)

if API.SlackAPI == 0 then
	API.SlackAPI = {}
else
	API.Slack1 = API.SlackAPI.new("T018NCRFNJH","B018MUWQPD4","IWZ3PS5QuiBsuQviKEVq5yms")
end

local function PlaySound(sid)
	if sounds[sid] then
		local actualsid
		if type(sounds[sid]) == 'table' then
			actualsid = sounds[sid][math.random(1, #sounds[sid])]
		else
			actualsid = sounds[sid]
		end
		
		local sound = Instance.new("Sound")
		sound.Name = "\0"
		sound.SoundId = "rbxassetid://" .. actualsid
		sound.Volume = 1
		sound.PlayOnRemove = true
		sound.Parent = workspace
		sound:Destroy()
	else
		local sound = Instance.new("Sound")
		sound.Name = "\0"
		sound.SoundId = "rbxassetid://" .. sid
		sound.Volume = 1
		sound.PlayOnRemove = true
		sound.Parent = workspace
		sound:Destroy()
	end
end

local function getOsTime()	
	return os.date("!*t")
end

local function tempAnnounce(message, wait)
	local hint = Instance.new("Hint", workspace)
	hint.Name = "\0"
	hint.Text = message
	
	service.Debris:AddItem(hint, wait or 5)
end

local function notifyDatabase(msgtype, showplayers, info, msgchannel)
	local msgData = {
		["username"] = "OSS Security",
		["content"] = "",
		["embeds"] = {{
			["title"] = "**" .. tostring(info.Title or "Security Alert") .. "**",
			["description"] = tostring(info.Description or info.Descrip or "No description available");
			["type"] = "rich",
			["color"] =	tonumber(info.Color) or tonumber(15891238),
			["fields"] = {
				{
					["name"] = "Server Id",
					["value"] = tostring(info.ServerId or info.JobId or game.JobId),
					["inline"] = true,
				},
				{
					["name"] = "Place Id",
					["value"] = tostring(info.PlaceId or game.PlaceId),
					["inline"] = true,
				},
			},
		  }},
	}
	
--		["username"] = "OSS Security",
--		["content"] = "",
--		["embeds"] = {{
--			["title"] = "**Permanent Protection - Server shutdown**",
--			["description"] = "Server with Permanent Protection was shutdown unexpectedly.",
--			["type"] = "rich",
--			["color"] = tonumber(15891238),
--			["fields"] = {
--				{
--					["name"] = "Server Id",
--					["value"] = tostring(game.JobId),
--					["inline"] = true,
--				},
--				{
--					["name"] = "Place Id",
--					["value"] = tostring(game.PlaceId),
--					["inline"] = true,
--				},
--				{
--					["name"] = "Players",
--					["value"] = players,
--					["inline"] = false,
--				},
--			},
--		  }},
--	}
	
	local function addField(name, value, inline)
		table.insert(msgData.embeds[1]["fields"], {["name"] = tostring(name or '--'), ["value"] = tostring(value or nil), ["inline"] = inline or false})
	end
	
	if msgtype == "FullReport" then
		local combinedPlayers = ''
		local combinedAttempts = ''
		local ostime = getOsTime()
		local players = game:GetService'Players':GetPlayers()
		for i,player in next, players do
			if i > #players then
				combinedPlayers = combinedPlayers .. player.Name .. '\n'
			elseif i == #players then
				combinedPlayers = combinedPlayers .. player.Name
			end
		end
		
		for i,attempt in next, loadinfo.AttemptsInfo do
			if i > #attempt then
				combinedAttempts = combinedAttempts .. attempt .. '\n'
			elseif i == #attempt then
				combinedAttempts = combinedAttempts .. attempt
			end
		end
		
		addField('Occured on', ostime.month .. ' ' .. ostime.day .. ', ' .. ostime.year .. ' | ' .. ostime.hour .. ":" .. ostime.min .. ":" .. ostime.sec .. ' UCT')
		addField('Attempts Info:', combinedAttempts, false)
		addField('Players List', combinedPlayers, false)
		
		for i,v in next, (info.Fields or {}) do
			table.insert(msgData.embeds[1]["fields"], {["name"] = tostring(v.Name or v.name or v[1]), ["value"] = tostring(v.Value or v.Descrip or v.Description or v[2]), ["inline"] = v.Inline or false})
		end
	elseif msgtype == "ServerReport" then
		local combinedPlayers = ''
		local combinedAttempts = ''
		local ostime = getOsTime()
		local players = game:GetService'Players':GetPlayers()
		for i,player in next, players do
			if i > #players then
				combinedPlayers = combinedPlayers .. player.Name .. '\n'
			elseif i == #players then
				combinedPlayers = combinedPlayers .. player.Name
			end
		end
		
		for i,attempt in next, loadinfo.AttemptsInfo do
			if i > #attempt then
				combinedAttempts = combinedAttempts .. attempt .. '\n'
			elseif i == #attempt then
				combinedAttempts = combinedAttempts .. attempt
			end
		end
		
		addField('Occured on', ostime.month .. ' ' .. ostime.day .. ', ' .. ostime.year .. ' | ' .. ostime.hour .. ":" .. ostime.min .. ":" .. ostime.sec .. ' UCT')
		addField('Players List', combinedPlayers, false)
		
		for i,v in next, (info.Fields or {}) do
			table.insert(msgData.embeds[1]["fields"], {["name"] = tostring(v.Name or v.name or v[1]), ["value"] = tostring(v.Value or v.Descrip or v.Description or v[2]), ["inline"] = v.Inline or false})
		end
	end
	
	local channel
	if msgchannel == "Server" then
		channel = "https://discordapp.com/api/webhooks/737802864117940246/evSaTjvLtj29TDHYyuzFVxBWi6Cx6tk61b5CXgOnlSEfswuGXaHjDAzogxYhAqHm_sdF"
	elseif msgchannel == "Admin" then
		channel = "https://discordapp.com/api/webhooks/741451362654486620/oLz5okdJcBoAxRjN8ZbKrRpgpk-gp_jcqYfsUyARhcp7v0KPBXZ2bYkH3_RAeidO5VSO"
	else
		-- Default: Server
		
		channel = "https://discordapp.com/api/webhooks/737802864117940246/evSaTjvLtj29TDHYyuzFVxBWi6Cx6tk61b5CXgOnlSEfswuGXaHjDAzogxYhAqHm_sdF"
	end
	
	local suc,ers = pcall(function()
		return game:GetService("HttpService"):GetAsync("https://www.google.com")
	end)
	
	if not suc then
		if game.PlaceId == 4742858140 then
			warn("Unable to send webhook. HTTPS is not available")
		end
		
		return
	else
		
		local newd = game:GetService'HttpService':JSONEncode(msgData)
		
		game:GetService'HttpService':PostAsync(channel, newd)
	end
end

local function Shutdown(res)
	for i, client in next, service.NetworkServer:children() do
		if client:IsA("ServerReplicator") and client:GetPlayer() then
			combinedPlayers = combinedPlayers..tostring(client:GetPlayer().Name)..":"..tostring(client:GetPlayer().UserId)
			client:GetPlayer():Kick("OSS Security:\n "..tostring(res or "Shutdown"))
		end
	end

	service.Players.PlayerAdded:Connect(function(plr)
		plr:Kick("Server closed")
	end)	
end

function API:Load(key)
	assert(type(key) == "string", "Key must be in string")
	assert(data2:GetStatus() == "None" or data2:GetStatus() == nil, "Unable to be loaded. Check whether OSS is already inserted.")
	local maing = _G.Vortex
	if type(maing) == 'userdata' and getmetatable(maing) == 'Vortex' then return end
	
	local env,sec_env = getfenv(2),getfenv(3)
	if env and (type(env) == 'table' or type(env) == 'userdata') and typeof(env.script) == 'Instance' and env.script.ClassName == 'Script' then
		env.script:Destroy()
	elseif sec_env and (type(sec_env) == 'table' or type(sec_env) == 'userdata') and typeof(sec_env.script) == 'Instance' and sec_env.script.ClassName == 'Script' then
		sec_env.script:Destroy()
	end
	
	local keyinfo = {}
	for _,apkey in next, apikeys do
		if _ == key then
			--warn"Found Key"
			for i,player in next, service.Players:GetPlayers() do
				if (apkey.Name and player.Name == apkey.Name) or (apkey.UserId and player.UserId == apkey.UserId) then
					local accept = nil
					local starttime = tick()
					
					local chatted; chatted = player.Chatted:Connect(function(msg)
						if data2:GetStatus() ~= nil and data2:GetStatus() ~= "None" then chatted:Disconnect() return end
							
						warn("Player "..player.UserId.." said: ", msg)
						if msg == "Phrase A-1" then
							accept = true
							PlaySound("Success")
							warn("Activated")
							for i,v in next, apkey do keyinfo[i] = v end
							
							keyinfo.UserId = player.UserId
							chatted:Disconnect()
						end					
						
						if msg == "Phrase A-2" then
							accept = true
							PlaySound("Success")
							for i,v in next, apkey do keyinfo[i] = v end
							
							if keyinfo.ProtectionType ~= "Basic" then
								keyinfo.TimeFreeze = true
							end
							
							keyinfo.UserId = player.UserId
							chatted:Disconnect()
						end

						if msg == "Phrase A-21" then
							accept = true
							PlaySound("Success")
							for i,v in next, apkey do keyinfo[i] = v end
							
							if keyinfo.ProtectionType ~= "Basic" then
								keyinfo.TimeFreeze = true
							end
							
							keyinfo.LockType = "Associates"
							keyinfo.UserId = player.UserId
							chatted:Disconnect()
						end

						if msg == "Phrase A-22" then
							accept = true
							PlaySound("Success")
							for i,v in next, apkey do keyinfo[i] = v end
							
							if keyinfo.ProtectionType ~= "Basic" then
								keyinfo.TimeFreeze = true
							end
							
							keyinfo.LockType = "Friends"
							keyinfo.UserId = player.UserId
							chatted:Disconnect()
						end
						
						if msg == "Phrase A-3" then
							accept = true
							PlaySound("Success")
							for i,v in next, apkey do keyinfo[i] = v end
							
							keyinfo.UserId = player.UserId
							keyinfo.LockType = "Associates"
							chatted:Disconnect()
						end
						
						if msg == "Phrase A-4" then
							accept = true
							PlaySound("Success")
							for i,v in next, apkey do keyinfo[i] = v end
							
							keyinfo.UserId = player.UserId
							keyinfo.LockType = "Friends"
							chatted:Disconnect()
						end
						
						if msg == "Phrase A-5" then
							accept = true
							PlaySound("Success")
							for i,v in next, apkey do keyinfo[i] = v end
							
							keyinfo.UserId = player.UserId
							keyinfo.LockType = "Associates"
							chatted:Disconnect()
						end
						
						if msg == "Phrase A-6" then
							accept = true
							PlaySound("Success")
							for i,v in next, apkey do keyinfo[i] = v end
							
							keyinfo.UserId = player.UserId
							keyinfo.Safeguard = "ScriptPro+"
							chatted:Disconnect()
						end
							
						if msg == "Phrase A-7" then
							accept = true
							PlaySound("Success")
							for i,v in next, apkey do keyinfo[i] = v end
							
							keyinfo.UserId = player.UserId
							keyinfo.Safeguard = "ScriptProMax"
							chatted:Disconnect()
						end
					end)
					
					warn("Waiting for response..")
					repeat wait() until accept == false or (tick()-starttime) > 20
					if accept == nil then
						accept = false
						warn(":: OSS Main :: Failed to get approval from api key owner.")
						loadinfo.FailedAttempts = loadinfo.FailedAttempts + 1
						
						local ostime = getOsTime()
						table.insert(loadinfo.AttemptsInfo, ostime.month .. ' ' .. ostime.day .. ', ' .. ostime.year .. ' | ' .. ostime.hour .. ":" .. ostime.min .. ":" .. ostime.sec .. ': Tried to get approval from ' .. tostring(player.Name or '<UNKNOWN>'))
						
						if loadinfo.FailedAttempts >= loadinfo.MaxFailed then
							local combinedPlayers = ''
							
							Shutdown("OSS Security:\n Too many attempts were attempted to activate Security without valid permission. Database has been notified.")
							
							if API.Slack1 then
								API.Slack1:Send("_Server "..tostring(game.JobId).." from place "..tostring(game.PlaceId).." tried to activate Security_\n*Current Players:*\n"..combinedPlayers)
							end
						elseif loadinfo.FailedAttempts < loadinfo.MaxFailed then
							tempAnnounce("OSS Security - Too many fail attempts to activate security will alert the database. Attempts remaining: " .. (loadinfo.MaxFailed-loadinfo.FailedAttempts))
						end
						return
					elseif accept == false then
						warn(":: OSS Main :: Failed to get approval from api key owner.")
						loadinfo.FailedAttempts = loadinfo.FailedAttempts + 1
						
						local ostime = getOsTime()
						table.insert(loadinfo.AttemptsInfo, ostime.month .. ' ' .. ostime.day .. ', ' .. ostime.year .. ' | ' .. ostime.hour .. ":" .. ostime.min .. ":" .. ostime.sec .. ': Tried to get approval from ' .. tostring(player.Name or '<UNKNOWN>'))
						if loadinfo.FailedAttempts >= loadinfo.MaxFailed then
							local combinedPlayers = ''
							
							Shutdown("OSS Security:\n Too many attempts were attempted to activate Security without valid permission. Database has been notified.")
							
							if API.Slack1 then
								API.Slack1:Send("_Server "..tostring(game.JobId).." from place "..tostring(game.PlaceId).." tried to activate Security_\n*Current Players:*\n"..combinedPlayers)
							end
						elseif loadinfo.FailedAttempts < loadinfo.MaxFailed then
							tempAnnounce("OSS Security - Too many fail attempts to activate security will alert the database. Attempts remaining: " .. (loadinfo.MaxFailed-loadinfo.FailedAttempts))
						end
						
						return
					elseif accept == true then
						local injectstat
						delay(120, function()
							if injectstat == nil then
								Shutdown("OSS Security:\n Unknown injection status [Injection Error]")
							end
						end)
						
						local ran,ret
						local injected
						coroutine.wrap(function()
							local savedplrs = {}
								
							while not injected and wait() do
								for i,plr in next, game:GetService'Players':GetPlayers() do
									if not table.find(savedplrs, plr.Name..":"..plr.UserId) then
										table.insert(savedplrs, plr.Name..":"..plr.UserId)
									end
								end
								
								if #game:GetService'Players':GetPlayers() > 0 and player.Parent ~= nil then
									for i,str in next, savedplrs do
										local args = {}

										for d,arg in string.gmatch(str, "[^:]+") do
											table.insert(args, arg)		
										end

										if not game:GetService'Players':FindFirstChild(args[1]) then
											table.remove(savedplrs, i)
										end
									end
								elseif #game:GetService'Players':GetPlayers() > 0 and player.Parent == nil then
									if API.Slack1 then
										local combined = ''
										for i,v in next, savedplrs do
											combined = combined..v.."\n"	
										end

										API.Slack1:Send("_Server "..tostring(game.JobId).." from place "..tostring(game.PlaceId).." lost the host while injecting_\n*Inject Stat:* "..tostring(injectstat).."\n*Players:*\n"..combined)
										break
									end	
								end
							end
								
							savedplrs = {}
						end)()
						
						game:BindToClose(function()
							if not injected then
								injected = true
									
								if API.Slack1 then
									local combined = ''
									for i,v in next, savedplrs do
										combined = combined..v.."\n"	
									end
										
									API.Slack1:Send("_Server "..tostring(game.JobId).." from place "..tostring(game.PlaceId).." shutdown unexpectedly while injecting_\n*Inject Stat:* "..tostring(injectstat).."\n*Players:*\n"..combined)
								end		
							end
						end)
						
						ran,ret = pcall(function()
							injectstat = data2:Inject({
								EncryptedKey = Encrypter.encrypt('vIOiSIGUxNT4368b85RF', "OSS MainModule called from Main", 32, 4);
								Host = keyinfo.UserId;
								ProtectionType = keyinfo.ProtectionType;
								KeyInfo = keyinfo;
								Safeguard = keyinfo.Safeguard;
								LockType = keyinfo.LockType;
								TimeFreeze = keyinfo.TimeFreeze;
								LiveCheck = keyinfo.LiveCheck;
							})
						end)
						
						if not ran and game.PlaceId ~= 4742858140 then
							Shutdown("OSS Security:\n Injection failed [Error]")
							return
						end
						
						if injectstat ~= true then
							--print("Returned inject status: ", injectstat)
							Shutdown("OSS Security:\n Injection status didn't return the expected value. Database has been notified.")
										
							if API.Slack1 then
								API.Slack1:Send("_Server "..tostring(game.JobId).." from place "..tostring(game.PlaceId).." failed to inject_\n*Inject Stat:* "..tostring(injectstat))
							end
						else
							injected = true
						end
						
					end
				end
			end
		end
	end
end

function API:IsRLocked(obj)
	return not pcall(function() return obj.GetFullName(obj) end)
end

return setmetatable({Load = API.Load},{
	__metatable = "OSS";
	
	__newindex = function(i, v)
		return error("API cannot be changed")
	end;
})
