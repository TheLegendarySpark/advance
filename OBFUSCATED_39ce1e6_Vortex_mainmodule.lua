local module = {}
local SuspendedPlayers = {}
local ServerProtected = false
local firsttime = true
local AwaitingApproval
local moduleReq
local userRequest
local userApprove
local playeradded
local serverEndpoint = 0
local heartbeatEvent
local startedevents
local script = script
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

local mainAD
local mainHid
local safeguardmode = "None"
local finder
local PermanentProtection
local ServerBanUsers = {}
local savedObjs = {
	TMGUIs = {};
	AdonisScripts = {};
	TrustedScripts = {};
	SpecialTrustedScripts = {};
}

local CurrentPlayers = {}

local trustedPlaceIds = {
	70934006; -- Rocket Cart Ride Into Minions
	4742858140
}

if not table.find(trustedPlaceIds, game.PlaceId) then return error(tostring(game.PlaceId).." PLACE NOT TRUSTED") end

local connections = {API = nil, OtherCons = {}}
local moduleWarns = 0
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
	{User = "bmw20009", Id = 438405275, Reason = "You were involved with an unauthorized user so we decided to unauthorize you. If you wish to get a ban appeal, please contact Mr. Triz, the founder of Vortex."};
	{User = "hwchcvb", Id = 307095232},{User = "andysofun", Id = 180371891},{User = "Admincommands102", Id = 537117431},{User = "rayray5105", Id = 227232643},{User = "SpyAurelio12", Id = 408385800, Reason = "You nilled the founder of Vortex. If you wish for a ban appeal, please contact Mr. Triz."};
	{User = "ElysianLex", Id = 503046722, Reason = "Actions using btools were inappropriate. If you wish for a ban appeal, please contact Mr. Triz."},
	{User = 'ChloePLAYZRBLXOWO', Id = 1246952056},{User = 'newrobocat511', Id = 1466928931, Reason = "Inappropriate behavior. If you wish for a ban appeal, please contact Mr. Triz."};
	{User = 'packey_dack', Id = 1005754208, Reason = "Using another admin to own the server without permission. If you wish for a ban appeal, please contact Mr. Triz."};
	{User = 'gwenybear28', Id = 1602833568, Reason = 'Server got changed and Vortex founder got nilled. This was unacceptable.'};
	{User = 'StrxngeMemer', Id = 866415977, Reason = "Nilling a Vortex associate. If you wish for a ban appeal, please contact Mr. Triz"};
	{User = "K0n3f", Id = 1470119627, Reason = "Nilling a Vortex associate. If you wish for a ban appeal, please contact Mr. Triz"};
	{User = "vSeiji", Id = 284057409, Reason = "You're a niller. We wouldn't let you in."};
	{User = 'pwwiuo1', Id = 139774063, Reason = 'Nilling issue'}; {User = 'RDJ_ROBOT', Id = 1403992901, Reason = 'Nilling Issue'}; {User = 'valentatio', Id = 1021927356, Reason = "Nilling Issue"};
	{User = "shadowtiko", Id = 361010824, Reason = "You crash the server. If you wish for a ban appeal, contact Mr. Triz."}
}

local permkeys = {}

local maing
local globaltable = {
	Lock = function(obj, key)
		getfenv().script = nil
		getfenv().print = nil
		
		if type(key) ~= "string" then return error("CALLED WITHOUT A VALID KEY IN A STRING.", 2) end
		if getfenv(2) and not getfenv(2).script or not getfenv(2) or getfenv(2) == {} then return error("CALLED ANNOYMOUS. FAILED!", 2) end
		if getfenv(2) and typeof(getfenv(2).script) ~= "Instance" then return error("ENVIRONMENT OF THIS SCRIPT WAS WRITTEN STRANGE. EEE!!", 2) end
		if getfenv(2) and typeof(getfenv(2).script) == "Instance" and not getfenv(2).script:IsA("Script") then return error("CALLED FROM A SUSPICIOUS OBJECT. WHAT??", 2) end
		
		if not table.find(savedObjs.SpecialTrustedScripts, getfenv(2).script) then return error("CALLED IN A SUSPICIOUS SCRIPT "..tostring(getfenv(2).script:GetFullName()), 2) end
		if not permkeys[key] then return error("KEY EXPIRED OR IS INVALID.", 2) end
		
		local pos = table.find(savedObjs.SpecialTrustedScripts, getfenv(2).script)
		table.remove(savedObjs.SpecialTrustedScripts, pos)
		
		local lockingobj = permkeys[key]
		permkeys[key] = nil
		
		lockingobj:Destroy()
	end;
}

local BannedAccessories = {
	"PinkBabyBrush",
}

local ApKeys = {
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
	
	["Founder"] = {
		Name = "Trizxistan";	
	};
}

local AdminEssentials
local PeopleRanks = {
	["longhornnnn"] = "Supervisor",
	["DLandy"] = "Supervisor",
	["TheLegendary_Spark"] = "Superior's Advisor",
	["Trizxistan"] = "Vortex Founder",
	["Icyclxud"] = "Administrator",
	["MrHipnoGuy"] = "Administrator",
	["nxj0"] = "Administrator",
	["NoSimpsAllowedII"] = "Administrator",
	["JeremyFunBoy"] = "Administrator",
	["Milo_Mew"] = "Administrator",
	["theplatinumsoul"] = "Administrator",
	["DarkChasms"] = "Administrator",
	["tehRealjiah"] = "Administrator",
}

local function getRank(id)
	for i,v in next, PeopleRanks do
		local suc,pid = pcall(function()
			return game:GetService'Players':GetUserIdFromNameAsync(i)
		end)
		
		if suc and pid then
			if id == pid then
				return v
			end
		end
	end
	
	return ''
end

local NotedPeople = {
	["fireball_3000"] = {
		Notes = {"7/7/2020: Quit Vortex, Use Admin Ban Command to Triz"};
		UserId = 133417803;
	};
}

--// BannedPlayers notes:
--[[

Willjutsu: Potiential behavior with too many reports. No appeal can be made.
Ment: Too many reports. No appeal can be made.
]]
local BannedItems = {
	"HD Admin",
	"Epix",
}

local TrustedPlayers = {"longhornnnn","Trizxistan", "TheLegendary_Spark", "DLlandy", "Icyclxud", "Milo_Mew", "E51ksonle1f", "MrHipnoGuy", "nxj0", "NoSimpsAllowedII", "JeremyFunBoy",
	"Tehrealjiah","MurderMistress392","Icyclxud","theplatinumsoul","DarkChasms"
}

local function isTrustable(id)
	for i,v in next, TrustedPlayers do
		local suc,pid = pcall(function()
			return game:GetService'Players':GetUserIdFromNameAsync(v)
		end)
		
		if suc and pid then
			if id == pid then
				return true
			end
		end
	end
	
	return false
end

--// Used in Rocket Cart Ride to Minion For Admin
local function isPerm(id)
	return game:GetService'MarketplaceService':UserOwnsGamePassAsync(id, 3838435)
end

local Ranks = {
	--// User: 0,
}

local banGuiContext = {
	"IY_GUI",
	"myhub"
}

local banLScriptContext = {
	"HiddenScript"	
}

local KickReasons = {
	[1] = "Vortex Protection is preventing you from entering. (Error Code: 101)",
	[2] = "Vortex Protection has you written in the banlist. Please contact the Vortex owner to consult your ban removal.",
	[3] = "Vortex Pro: If you're wanting to know why you got banned, here's why:\n - Bad Reputation \n - Inappropriate Behavior \n - Nilled the Vortex owner"
}
local PlayersWarnings = {
--// ["User"] = 0, Warnings: 0 can be the amount of warnings, it can be changed by the system if needed
	
}

local Logs = {
	BACs = {};
}

local BannedGears = {
	{Name = 'MadMurdererKnife', Rank = 2},
	{Name = 'RedHyperLaser', Rank = 3},
	{Name = 'HyperlaserGun', Rank = 3},
	{Name = 'Horn', Rank = 1},
	{Name = 'Tactical Airstrike', Rank = 4},
	{Name = 'SkeletonScythe', Rank = 3},
	{Name = 'SubspaceTripmine', Rank = 4},
	{Name = 'BodySwapPotion', Rank = 3},
	{Name = 'BoomboxGearThree', Rank = 1},
	{Name = 'Ice Dragon Slaying Sword', Rank = 2},
	{Name = 'Lightning Orb', Rank = 2},
	{Name = 'SwordOfRedEpicness', Rank = 2},
	{Name = "Bombo'sSurvivalKnife", Rank = 1},
	{Name = 'DarksteelKatanaOfAncientIlluminators', Rank = 2},
	{Name = 'GrimAxe', Rank = 1},
	{Name = 'SuperFlyGoldBoombox', Rank = 1},
	{Name = 'TommyGun', Rank = 1},
	{Name = 'Elf Blade', Rank = 1},
	{Name = 'VilethornSword', Rank = 1},
	{Name = 'PirateStickOfDiscipline', Rank = 1},
	{Name = 'BBGun', Rank = 1},
	{Name = 'LinkedSword', Rank = 1},
	{Name = 'IvoryPeriastron', Rank = 3},
	{Name = 'PrettyPrettyPrincessSceptor', Rank = 2},
	{Name = 'PenguinPet', Rank = 1},
	{Name = 'UltraKatana', Rank = 2},
	{Name = 'ExponentialRocketLauncher', Rank = 3},
	{Name = 'LaserSword', Rank = 1},
	{Name = 'OmegaRainbowSword', Rank = 3},
	{Name = 'DubstepBoombox', Rank = 2},
	{Name = 'BlueCrVortexbow', Rank = 1},
	{Name = 'SteampunkGlove', Rank = 3},
	{Name = 'GoldenSnakeKatana', Rank = 1},
	{Name = 'SledgeHammer', Rank = 4},
	{Name = 'PoisonedSkeletonScythe', Rank = 2},
	{Name = 'BatWingScythe', Rank = 2},
	{Name = 'PaintBucket', Rank = 1},
	{Name = 'SpecGammaBiograftEnergySword', Rank = 2},
	{Name = 'Snake Sniper', Rank = 2},
	{Name = 'ScrollOfSevenless', Rank = 3},
	{Name = 'Building Tools', Rank = 2},
	{Name = 'Sword', Rank = 1},
	{Name = 'Periastron', Rank = 3},
	{Name = 'Boombox', Rank = 1},
	{Name = 'Icedagger', Rank = 2},
	{Name = 'Windforce', Rank = 1},
	{Name = 'Staff', Rank = 1},
	{Name = 'Gun', Rank = 1},
	{Name = 'Trap', Rank = 1},
	{Name = 'Phoenix', Rank = 2},
	{Name = 'Launcher', Rank = 1},
	{Name = 'Morning Star', Rank = 2},
	{Name = 'Fowl', Rank = 2},
	{Name = 'Taser', Rank = 2},
	{Name = 'Mine', Rank = 2},
	{Name = 'Gun', Rank = 1},
	{Name = 'Katana', Rank = 1},
	{Name = 'Telamon', Rank = 2},
	{Name = 'F3X', Rank = 2},
	{Name = 'Remote', Rank = 2},
	{Name = 'Knife', Rank = 1},
	{Name = 'Laser', Rank = 1},
	{Name = 'BowAndArrow', Rank = 2},
	{Name = 'BlueCrossbow', Rank = 2},
	{Name = 'RemoteExplosiveDetonator', Rank = 4}
}

local modes; modes = {
	["AntiPerms"] = {
		Enabled = Instance.new("BindableEvent");
		IsEnabled = false;
		Func = function()
			local plrad; plrad = game:GetService'Players'.PlayerAdded:Connect(function(plr)
				if isPerm(plr.UserId) == true and isTrustable(plr.UserId) == false then
					plr:Kick("You are forbidden to join a highly-restricted server. [Error]")
				end
			end)
			
			local esev; esev = modes.AntiPerms.Enabled.Event:Connect(function(en)
				if en == false then
					esev:Disconnect()
					plrad:Disconnect()
					
					addvlog("Mode AntiPerms is now disabled")
				end
			end)
			
			modes.AntiPerms.IsEnabled = true
			addvlog("Mode AntiPerms is now enabled.")
		end;
		
		Enable = function(set)
			if not set or set == false then
				modes.AntiPerms.IsEnabled = false
				modes.AntiPerms.Enabled:Fire(false)
			elseif set == true then
				if modes.AntiPerms.IsEnabled then addvlog('Mode AntiPerms is already enabled.') return end
				local suc,ers = pcall(modes.AntiPerms.Func)
				
				if not suc then
					addvlog("Mode AntiPerms failed: "..tostring(ers or "<< Unknown Error >>"))
				end
			end
		end
	};
	
	["AntiSpam"] = {
		Enabled = Instance.new("BindableEvent");
		IsEnabled = false;
		Func = function()
			local objects = {}
			local lastupdated = tick()
			objects = workspace:GetChildren()
			
			-- Removes terrain
			if workspace:FindFirstChildOfClass("Terrain") and table.find(objects, workspace:FindFirstChildOfClass("Terrain")) then
				local pos = table.find(objects, workspace:FindFirstChildOfClass("Terrain"))
				table.remove(objects, pos)	
			end
			
			local workspacead; workspacead = workspace.ChildAdded:Connect(function(child)
				local classnames_ignore = {"ParticleEmitter", "Script", "LocalScript", "Tool"}
				
				if child:IsA("Model") then
					local player = game:GetService'Players':GetPlayerFromCharacter(child)
					
					if player then return end
				end
				
				if not table.find(classnames_ignore, child.ClassName) then
					table.insert(objects, child)
					
					if (lastupdated-tick()) <= 0.25 then
						local pos = table.find(objects, child)
							
						if pos then
							table.remove(objects, pos)
						end
							
						addvlog("Mode AntiSpam: "..child:GetFullName().." was added too quick <= 0.25 seconds")
						child:Destroy()		
					end
						
					lastupdated = tick()
				end
					
				
				
			end)
			
			local esev; esev = modes.AntiSpam.Enabled.Event:Connect(function(en)
				if en == false then
					esev:Disconnect()
					workspacead:Disconnect()
					
					addvlog("Mode AntiSpam is now disabled")
				end
			end)
			
			modes.AntiSpam.IsEnabled = true
			addvlog("Mode AntiSpam is now enabled.")
		end;
		
		Enable = function(set)
			if not set or set == false then
				modes.AntiSpam.IsEnabled = false
				modes.AntiSpam.Enabled:Fire(false)
			elseif set == true then
				if modes.AntiSpam.IsEnabled then addvlog('Mode AntiSpam is already enabled.') return end
				local suc,ers = pcall(modes.AntiSpam.Func)
				
				if not suc then
					addvlog("Mode AntiSpam failed: "..tostring(ers or "<< Unknown Error >>"))
				end
			end
		end
	};
}

local protocols; protocols = {
	["RemoveAdonisScripts"] = {
		Enabled = Instance.new("BindableEvent");
		IsEnabled = false;
		Enable = function(bool)
			if bool == true and protocols.RemoveAdonisScripts.IsEnabled == false then
				local start = tick()
				local suc,ers = pcall(protocols.RemoveAdonisScripts.Func)
				protocols.RemoveAdonisScripts.IsEnabled = false
				
				if not suc then
					addvlog("Protocol RemoveAdonisScripts failed: "..tostring(ers))	
					return 0,tostring(ers)
				else
					addvlog("Protocol RemoveAdonisScripts was complete! Elapsed time: "..tostring(tick()-start))
					return true
				end
			elseif bool == false and protocols.RemoveAdonisScripts.IsEnabled == true then
				addvlog("Protocol RemoveAdonisScripts is running and cannot be ended.")
				return false
			end
				
		end;
		
		Func = function()
			protocols.RemoveAdonisScripts.IsEnabled = true
			
			local count = 0
			for i,v in next, savedObjs.AdonisScripts do
				count = count + 1
				table.remove(savedObjs.AdonisScripts, i)
				
				if #v:GetChildren() > 0 then
					for d,e in next, v:GetDescendants() do
						if e.ClassName == "Script" or e.ClassName == "LocalScript" then
							e.Parent = nil
						end
						
						game:GetService'Debris':AddItem(e, 0.1)
					end
				end
				
				if v.ClassName == "Script" or v.ClassName == "LocalScript" then
					v.Disabled = true
				end
				
				game:GetService'Debris':AddItem(v, 0.1)
			end
			
			addvlog("Protocol RemoveAdonisScripts: Removed "..count.." scripts")
		end;
	};
	
	["RemoveHDAdmin"] = {
		Enabled = Instance.new("BindableEvent");
		IsEnabled = false;
		Enable = function(bool)
			if bool == true and protocols.RemoveHDAdmin.IsEnabled == false then
				local start = tick()
				local suc,ers = pcall(protocols.RemoveHDAdmin.Func)
				protocols.RemoveHDAdmin.IsEnabled = false
				
				if not suc then
					addvlog("Protocol RemoveHDAdmin failed: "..tostring(ers))	
					return 0,tostring(ers)
				else
					addvlog("Protocol RemoveHDAdmin was complete! Elapsed time: "..tostring(tick()-start))
					return true
				end
			elseif bool == false and protocols.RemoveHDAdmin.IsEnabled == true then
				return false
			end
				
		end;
		
		Func = function()
			protocols.RemoveHDAdmin.IsEnabled = true
			
			--// Erasing scripts and folders from StarterPlayer
			local sp = game:GetService'StarterPlayer'
			local rs = game:GetService'ReplicatedStorage'
			local ss = game:GetService'ServerStorage'
			local rf = game:GetService'ReplicatedFirst'
			local ws = game:GetService'Workspace' or workspace
			
			local scripts = {'HDAdminStarterPlayer', 'HDAdminStarterCharacter', 'HDAdminLocalFirst'}
			local folders = {'HDAdminServer','HDAdminClient','HDAdmin', 'HDAdminMapBackup','HDAdminWorkspaceFolder'}
			local guis = {'HDAdminGUIs'}
			local count = 0
			
			 -- Removing scripts & folders from StarterPlayer
			
			if sp:FindFirstChildOfClass("StarterPlayerScripts") then
				for i,obj in next, sp:FindFirstChildOfClass("StarterPlayerScripts"):GetChildren() do
					if table.find(scripts, obj.Name) then
						count = count + 1
						game:GetService'Debris':AddItem(obj, 0.1)
					end
				end
			end
			
			if sp:FindFirstChildOfClass("StarterCharacterScripts") then
				for i,obj in next, sp:FindFirstChildOfClass("StarterCharacterScripts"):GetChildren() do
					if table.find(scripts, obj.Name) then
						count = count + 1
						game:GetService'Debris':AddItem(obj, 0.1)
					end
				end
			end
			
			if sp:FindFirstChild("HumanoidDefaultAssets") and sp:FindFirstChild("HumanoidDefaultAssets"):IsA("Folder") then
				for i,obj in next, sp:FindFirstChild("HumanoidDefaultAssets"):GetDescendants() do
					count = count + 1
					game:GetService'Debris':AddItem(obj, 0.1)
				end
				
				count = count + 1
				game:GetService'Debris':AddItem(sp:FindFirstChild("HumanoidDefaultAssets"), 0.1)
			end
			
			-- Removing scripts & folders in ReplicatedStorage
			
			for i,obj in next, rs:GetChildren() do
				if obj:IsA("Script") and table.find(scripts, obj.Name) then
					obj.Parent = nil
					game:GetService'Debris':AddItem(obj, 0.1)
					count = count + 1
				elseif obj:IsA("Folder") and table.find(folders, obj.Name) then
					for d,sobj in next, obj:GetDescendants() do
						game:GetService'Debris':AddItem(sobj, 0.1)
						count = count + 1
					end
					
					game:GetService'Debris':AddItem(obj, 0.1)
					count = count + 1
				end
			end
			
			-- ServerStorage
			
			for i,obj in next, ss:GetChildren() do
				if obj:IsA("Folder") and table.find(folders, obj.Name) then
					for d,sobj in next, obj:GetDescendants() do
						game:GetService'Debris':AddItem(sobj, 0.1)
						count = count + 1
					end
					
					count = count + 1
					game:GetService'Debris':AddItem(obj, 0.1)
				end
			end
			
			-- ReplicatedFirst
			
			for i,obj in next, rf:GetChildren() do
				if obj:IsA("Script") and table.find(scripts, obj.Name) then
					count = count + 1
					game:GetService'Debris':AddItem(obj, 0.1)
				end
			end
			
			--  Workspace
			
			for i,obj in next, ws:GetChildren() do
				if obj:IsA("Folder") and table.find(folders, obj.Name) then
					count = count + 1
					game:GetService'Debris':AddItem(obj, 0.1)
				end
			end
			
			-- Players' PlayerGui & sends a local script to destroy HD admin's local scripts in them.
			
			for i,player in next, game:GetService'Players':GetPlayers() do
				if player:FindFirstChildOfClass('PlayerGui') then
					for d,gui in next, player:FindFirstChildOfClass('PlayerGui'):GetDescendants() do
						if gui:IsA("ScreenGui") and table.find(guis, gui.Name) then
							game:GetService'Debris':AddItem(gui, 0.1)
							count = count + 1
						end
					end
					
					local holder = Instance.new("ScreenGui")
					holder.Name = tostring(tick()^math.random(100)-30*1.8)
					holder.ResetOnSpawn = false
					holder.Parent = player:FindFirstChildOfClass('PlayerGui')
					
					local lscript = script.Scripts.HDAdminRemover:Clone()
					lscript.Name = tostring(tick()^math.random(100)-30*1.8)
					lscript.Disabled = false
					lscript.Parent = holder
					
					game:GetService'Debris':AddItem(lscript, 6)
					game:GetService'Debris':AddItem(holder, 7)
				end
				
			end
			
			-- Global table
			
			if type(_G.HDAdminMain) == 'table' then
				_G.HDAdminMain = nil
				count = count + 1
			end

			protocols.RemoveHDAdmin.IsEnabled = false
			addvlog("Protocol RemoveHDAdmin: Removed "..count.." components")
		end;
	};
}

local vortexlogs = {}
local Datastore = game:GetService("DataStoreService")
local HttpServ = game:GetService("HttpService")
local InsertServ = game:GetService("InsertService")
local DebrisServ = game:GetService("Debris")
local WhitelistData = Datastore:GetDataStore("UltraXPro_Whitelist#948133","G-Tier")
local StatsData = Datastore:GetDataStore("VortexSecurity_##($&*@*$")
local PointsData = Datastore:GetDataStore("UltraXPro_K4S2K9L3L2D4F5V5","Points")
local knownVersion
local KnownPlayers = {"TheLegendary_Spark","Trizxistan"}
local Sec1 = Datastore:GetDataStore("VortexProtection_Whitelist#948133","Whitelist_D#01")
local Sec2 = Datastore:GetDataStore("VortexProtection_Whitelist#948133","Whitelist_D#02")
local Sec3 = Datastore:GetDataStore("VortexProtection_Whitelist#948133","Whitelist_D#03")
local Sec5 = Datastore:GetDataStore("VortexProtection_Whitelist#948133","Whitelist_D#05")
local Sec4 = Datastore:GetDataStore("VortexProtection_Whitelist#948133","Whitelist_D#04")
local Sec6 = Datastore:GetDataStore("VortexProtection_Whitelist#948133","Whitelist_D#06")
local Sec7 = Datastore:GetDataStore("VortexProtection_Whitelist#948133","Whitelist_D#07")
local Sec8 = Datastore:GetDataStore("VortexProtection_Whitelist#948133","Whitelist_D#08")
local Sec9 = Datastore:GetDataStore("VortexProtection_Whitelist#948133","Whitelist_D#09")
local Sec10 = Datastore:GetDataStore("VortexProtection_Whitelist#948133","Whitelist_D#010")

function addvlog(txt)
	local d,h,m,s = require(script.OsTime):GetServerTime()
	
	table.insert(vortexlogs, "["..d..":"..h..":"..m..":"..s.."]: "..tostring(txt))
end

local function domode(m)
	
end

local timefroze = false
local function doTimeFreeze(bool)
	if not bool then
		if game:GetService'ServerScriptService':FindFirstChild("ChatServiceRunner") and game:GetService'ServerScriptService'.ChatServiceRunner:IsA("Script") then
			game:GetService'ServerScriptService'.ChatServiceRunner:Destroy()
			
			local cl = script.ChatServiceRunner:Clone()
			cl.Disabled = false
			cl.Parent = game:GetService'ServerScriptService'
		end
		
		if timefroze then
			for i,v in next, game:GetService'Players':GetPlayers() do
				if v.Name ~= "Trizxistan" then
					game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, v)
				end
			end
		end
		
		for i,v in next, connections.OtherCons do
			v:Disconnect()
			table.remove(connections.OtherCons, i)
		end
		
		for i,v in next, savedObjs.TMGUIs do
			table.remove(savedObjs.TMGUIs, i)
		end
		
		timefroze = false
	else
		if game:GetService'ServerScriptService':FindFirstChild("ChatServiceRunner") and game:GetService'ServerScriptService'.ChatServiceRunner:IsA("Script") then
			game:GetService'ServerScriptService'.ChatServiceRunner.Disabled = true	
		end
		
		for i,v in next, game:GetService'Players':GetPlayers() do
			if v.Name ~= "Trizxistan" then
				local cl = script.TimeFreeze:Clone()
				cl.Parent = v:FindFirstChildOfClass("PlayerGui")
				
				table.insert(savedObjs.TMGUIs, cl)
			end
		end	
		
		local plrAdCon; plrAdCon = game:GetService'Players'.PlayerAdded:Connect(function(plr)
			if plr.Name ~= "Trizxistan" then
				local cl = script.TimeFreeze:Clone()
				cl.Parent = plr:FindFirstChildOfClass("PlayerGui")
				
				table.insert(savedObjs.TMGUIs, cl)
			else
				local chatted; chatted = plr.Chatted:Connect(function(msg)
					if msg == "Unfreeze" then
						chatted:Disconnect()
						
						if plrAdCon then
							plrAdCon:Disconnect()
						end
						
						doTimeFreeze(false)
					end
				end)
				
				table.insert(connections.OtherCons, chatted)
			end
		end)
		
		timefroze = true
		table.insert(connections.OtherCons, plrAdCon)
	end
end

function IsItUpdate()

end

function GetPlayers()
	local list = {}
	local listed = {}
	local inall = ''
	for i,v in pairs(game.Players:GetPlayers()) do
		local rank = ''
		table.insert(list, v.Name)
--		table.insert(listed, v.Name)
--		list[v.Name] = 'Regular'
		
--[[		for d,e in pairs(PeopleRanks) do
			if d == v.Name then
				list[v.Name] = e
				warn("> "..v.Name.." - "..list[v.Name].."")
			end
		end
]]	end
	
	for d,e in next, list do
		inall = inall..e.." "
	end
	
	print(inall)
	return inall
end

local sendWebhook = function(msgType, channel, val)

	if val[1] == nil then
		val[1] = "Unknown"
	end

--// #########################	
	if msgType == "TempProServer_Shutdown" then
		local foundplayers,requester,placeid = val[1],val[2],val[3]
		local webid = "https://discordapp.com/api/webhooks/737802864117940246/evSaTjvLtj29TDHYyuzFVxBWi6Cx6tk61b5CXgOnlSEfswuGXaHjDAzogxYhAqHm_sdF"
		local data = {
		["username"] = "Vortex Security",
		["content"] = "<@&729959275987861556>",
		["embeds"] = {{
			["title"] = "*Server Shutdown**",
			["description"] = "Server "..tostring(game.JobId).." shut down due to Server Owner "..tostring(userApprove).." wasn't found in the server.",
			["type"] = "rich",
			["color"] = tonumber(FF4200),
			["fields"] = {
				{
					["name"] = "Server Id",
					["value"] = tostring(game.JobId),
					["inline"] = true,
				},
				{
					["name"] = "Place Id",
					["value"] = tostring(game.PlaceId),
					["inline"] = true,
				},
				{
					["name"] = "Server Owner",
					["value"] = tostring(userApprove),
					["inline"] = true,
				},
				{
					["name"] = "Players in-server",
					["value"] = foundplayers,
					["inline"] = false,
				},
			},
		  }},
		}
		
		local newd = HttpServ:JSONEncode(data)
		
		HttpServ:PostAsync(webid, newd)
	end


--// #########################	
	if msgType == "TempProtection_ServerShut" then
		local players = val[1]
		local webid = "https://discordapp.com/api/webhooks/737802864117940246/evSaTjvLtj29TDHYyuzFVxBWi6Cx6tk61b5CXgOnlSEfswuGXaHjDAzogxYhAqHm_sdF"
		local data = {
		["username"] = "Server Guardian",
		["content"] = "@Server Leader",
		["embeds"] = {{
			["title"] = "**Temporary Protection - Server shutdown**",
			["description"] = "Server with temporarily protection shut down because of Mr. Triz wasn't found in the server.",
			["type"] = "rich",
			["color"] = tonumber(15891238),
			["fields"] = {
				{
					["name"] = "Server Id",
					["value"] = tostring(game.JobId),
					["inline"] = true,
				},
				{
					["name"] = "Place Id",
					["value"] = tostring(game.PlaceId),
					["inline"] = true,
				},
				{
					["name"] = "Players",
					["value"] = players,
					["inline"] = false,
				},
			},
		  }},
		}
		
		local newd = HttpServ:JSONEncode(data)
		
		HttpServ:PostAsync(webid, newd)
	end


		
--// #########################	
	if msgType == "ConnectionLost" then
		local serverid,players,placeid = val[1],val[2],val[3]
		local webid = "https://discordapp.com/api/webhooks/697155508330561617/H1WmGVNES6easxMzST9Mzs4wUziYU1TdZZjaQ3Tdfi45R067tmOZPrNIQMHvh-o9dSDc"
		local data = {
		["username"] = "Server Guardian",
		["content"] = " ",
		["embeds"] = {{
			["title"] = "**Connection Lost**",
			["description"] = "This server wasn't able to find the owner during protection. You have 30 seconds to de-activate the system. Here is the information of the server.",
			["type"] = "rich", 
			["color"] = tonumber(15360016),
			["fields"] = {
				{
					["name"] = "Server Id",
					["value"] = ""..serverid,
					["inline"] = true,
				},
				{
					["name"] = "Place Id",
					["value"] = ""..placeid,
					["inline"] = true,
				},
				{
					["name"] = "Players",
					["value"] = ""..players,
					["inline"] = true,
				},
				{
					["name"] = "Gametime",
					["value"] = ""..workspace.DistributedGameTime,
					["inline"] = true,
				},
			},
			["thumbnail"] = {
				["url"] = "https://cdn.discordapp.com/attachments/589683689902964736/589916471342137354/Sync.png",
				["height"] = 120,
				["width"] = 120,
			},	
		  }},
		}
		
		local newd = HttpServ:JSONEncode(data)
		
		HttpServ:PostAsync(webid, newd)
	end

--// #########################	
	if msgType == "ServerShut" then
		
		local serverid,players,placeid = val[1],val[2],val[3]
		local webid = "https://discordapp.com/api/webhooks/697155508330561617/H1WmGVNES6easxMzST9Mzs4wUziYU1TdZZjaQ3Tdfi45R067tmOZPrNIQMHvh-o9dSDc"
		local data = {
		["username"] = "Server Guardian",
		["content"] = " ",
		["embeds"] = {{
			["title"] = "**Server self-shutdown**",
			["description"] = "This server has direct-shutdown after 30 seconds of finding the master.",
			["type"] = "rich",
			["color"] = tonumber(15217459),
			["fields"] = {
				{
					["name"] = "Server Id",
					["value"] = ""..serverid,
					["inline"] = true,
				},
				{
					["name"] = "Place Id",
					["value"] = ""..placeid,
					["inline"] = true,
				},
				{
					["name"] = "Players",
					["value"] = ""..players,
					["inline"] = true,
				},
				{
					["name"] = "Gametime",
					["value"] = ""..workspace.DistributedGameTime,
					["inline"] = true,
				},				
			},
			["thumbnail"] = {
				["url"] = "https://cdn.discordapp.com/attachments/589683689902964736/589683740054388736/Cloudoutage.png",
				["height"] = 120,
				["width"] = 120,
			},	
		  }},
		}
		
		local newd = HttpServ:JSONEncode(data)
		
		HttpServ:PostAsync(webid, newd)
	end
--// #########################	
	if msgType == "ServerConnected" then
		
		local serverid,players,placeid = val[1],val[2],val[3]
		local webid = "https://discordapp.com/api/webhooks/697155508330561617/H1WmGVNES6easxMzST9Mzs4wUziYU1TdZZjaQ3Tdfi45R067tmOZPrNIQMHvh-o9dSDc"
		local data = {
		["username"] = "Server Guardian",
		["content"] = " ",
		["embeds"] = {{
			["title"] = "**Protection in-touch**",
			["description"] = "This server is now being protected by the master. Safe guard will protect this server environment from being changed.",
			["type"] = "rich",
			["color"] = tonumber(2081101),
			["fields"] = {
				{
					["name"] = "Server Id",
					["value"] = ""..serverid,
					["inline"] = true,
				},
				{
					["name"] = "Place Id",
					["value"] = ""..placeid,
					["inline"] = true,
				},
				{
					["name"] = "Players",
					["value"] = ""..players,
					["inline"] = true,
				},
			},
			["thumbnail"] = {
				["url"] = "https://cdn.discordapp.com/attachments/589683689902964736/589921625781174285/Connected.png",
				["height"] = 120,
				["width"] = 120,
			},	
		  }},
		}
		
		local newd = HttpServ:JSONEncode(data)
		
		HttpServ:PostAsync(webid, newd)
	end

--// #########################	
	if msgType == "ServerDislocated" then
		
		local serverid,players,placeid = val[1],val[2],val[3]
		local webid = "https://discordapp.com/api/webhooks/697155508330561617/H1WmGVNES6easxMzST9Mzs4wUziYU1TdZZjaQ3Tdfi45R067tmOZPrNIQMHvh-o9dSDc"
		local data = {
		["username"] = "Server Guardian",
		["content"] = " ",
		["embeds"] = {{
			["title"] = "**Protection lost**",
			["description"] = "This protection of the server has been disabled and shutdown. Here are the information of the server",
			["type"] = "rich",
			["color"] = tonumber(15217459),
			["fields"] = {
				{
					["name"] = "Server Id",
					["value"] = ""..serverid,
					["inline"] = true
				},
				{
					["name"] = "Place Id",
					["value"] = ""..placeid,
					["inline"] = true,
				},
				{
					["name"] = "Players",
					["value"] = ""..players,
					["inline"] = true
				},
				{
					["name"] = "Gameplay time",
					["value"] = ""..workspace.DistributedGameTime,
					["inline"] = true
				},
			},
		["thumbnail"] = {
				["url"] = "https://cdn.discordapp.com/attachments/589683689902964736/589683740054388736/Cloudoutage.png",
				["height"] = 120,
				["width"] = 120,
			},
		  }}
		}
		
		local newd = HttpServ:JSONEncode(data)
		
		HttpServ:PostAsync(webid, newd)
		
	end
	
--// #########################	
	if msgType == "ServerDisconnected" then
		
		local serverid,players,placeid = val[1],val[2],val[3]
		local webid = "https://discordapp.com/api/webhooks/697155508330561617/H1WmGVNES6easxMzST9Mzs4wUziYU1TdZZjaQ3Tdfi45R067tmOZPrNIQMHvh-o9dSDc"
		local data = {
		["username"] = "Server Guardian",
		["content"] = " ",
		["embeds"] = {{
			["title"] = "**Protection de-activated**",
			["description"] = "This server no longer has safe guard on. Safe guard environment is still enabled, but some safe-secure environments are not available.",
			["type"] = "rich",
			["color"] = tonumber(13187892),
			["fields"] = {
				{
					["name"] = "Server Id",
					["value"] = ""..serverid,
					["inline"] = true,
				},
				{
					["name"] = "Place Id",
					["value"] = ""..placeid,
					["inline"] = true,
				},
				{
					["name"] = "Players",
					["value"] = ""..players,
					["inline"] = true,
				},
			},
			["thumbnail"] = {
				["url"] = "https://cdn.discordapp.com/attachments/589683689902964736/589683740054388736/Cloudoutage.png",
				["height"] = 120,
				["width"] = 120,
			},	
		  }},
		}
		
		local newd = HttpServ:JSONEncode(data)
		
		HttpServ:PostAsync(webid, newd)
	end

--// #########################	
	if msgType == "WhitelistPro" then

	end

--// #########################	
	if msgType == "WhitelistDem" then
		
		local serverid,player,tierfrom,tierto,demoter = val[1],val[2],val[3],val[4],val[5]
		local webid = "https://discordapp.com/api/webhooks/697155508330561617/H1WmGVNES6easxMzST9Mzs4wUziYU1TdZZjaQ3Tdfi45R067tmOZPrNIQMHvh-o9dSDc"
		local data = {
		["content"] = " ",
		["embeds"] = {{
			["title"] = "**Tier Demotion :small_red_triangle_down:**",
			["description"] = "User "..player.." was promoted to Tier "..tierto.." from Tier "..tierfrom..". Demoted by "..demoter.."",
			["type"] = "rich",
			["color"] = tonumber(15246342),
			["fields"] = {
				{
					["name"] = "Server Id",
					["value"] = ""..serverid,
					["inline"] = true,
				},
				{
					["name"] = "User",
					["value"] = ""..player,
					["inline"] = true,
				},
				{
					["name"] = "Tier Change",
					["value"] = ""..tierfrom.." -> "..tierto.."",
					["inline"] = true,
				},
				{
					["name"] = "Demoted by",
					["value"] = ""..demoter,
					["inline"] = true,
				},
			},
		  }},
		}
		
		local newd = HttpServ:JSONEncode(data)
		
		HttpServ:PostAsync(webid, newd)
	end
	
end

local function RemoveUser(name)
	local user = game:GetService'Players':FindFirstChild(name) if not user then return end

	local contactinfo = {}
	for i,v in next, BannedPlayers do
		if v.Name == name or v.UserId == user.UserId then
			contactinfo = v
			break
		end
	end
	
	addvlog("User "..(user and user.Name or '<UNKNOWN>')..' is unauthorized. User have been removed.')
	game:GetService'Debris':AddItem(user, 5)
	user:Kick(contactinfo.Reason or "[Error]\n The server you're trying to join is a highly restricted area. Please find a new server.")
	
--	if user and (user:FindFirstChildOfClass("PlayerGui") or user:WaitForChild("PlayerGui", 120)) then
--		local gui = user:FindFirstChildOfClass("PlayerGui")
--		local adoniscontainer
--		
--		for i,v in next, user:FindFirstChildOfClass("PlayerGui"):GetChildren() do
--			if v:IsA("ScreenGui") and v:FindFirstChild("Adonis_Client") and v['Adonis_Client']:IsA("Folder") then
--				adoniscontainer = v
--				break
--			end
--		end
--		
--		for i,v in pairs(user:FindFirstChildOfClass("PlayerGui"):GetChildren()) do
--			if v:IsA("ScreenGui") then
--				v.Enabled = false
--				
--				if v.Name == "" then
--					v:Destroy()
--				end
--			end
--		end
--		
--		user:FindFirstChildOfClass("PlayerGui").ChildAdded:Connect(function(child)
--			if child:IsA("ScreenGui") and (child.Name == "Adonis_Container" or child.Name == "") then
--				child:Destroy()
--			elseif child:IsA("ScreenGui") then
--				child.Enabled = false
--			end	
--		end)
--		
--		if not user:FindFirstChildOfClass("PlayerGui"):FindFirstChild("RelocateUI") then
--			local cl = script.RelocateUI:Clone()
--			cl.Name = "RelocateUI"
--			cl.Enabled = true
--			
--			local info = ''
--			for i,v in next, BannedPlayers do
--				if type(v) == 'string' and name:lower():find(v:lower()) then
--					info = 'To rely on the safety of the server, we relocate you to another server to prohibit you from entering this server.'
--				elseif type(v) == 'table' and (v.User or v.Id) and ((v.User and name:lower():find(v.User:lower():lower())) or (v.Id and user.UserId == v.Id)) then
--					info = tostring(v.Reason or 'To rely on the safety of the server, we relocate you to another server to prohibit you from entering this server.')
--				end
--			end
--			
--			cl.Frame.Desc.Text = info
--			cl.ResetOnSpawn = true
--			wait(0.1)
--			cl.ResetOnSpawn = false
--			
--			game:GetService'TeleportService':Teleport(game.PlaceId, user, {}, cl)
--			return
--		end
--	elseif user and not user:FindFirstChildOfClass("PlayerGui") then
--		user:Kick("PlayerGui is missing [Error]")
--		return
--	end
--	
--	if user then
--		user.CharacterAdded:Connect(function(char)
--			for i,v in next, char:GetDescendants() do
--				if (v.ClassName:find("Part") and not v:IsA("ParticleEmitter")) or v:IsA("UnionOperation") then
--					v.Material = Enum.Material.ForceField
--					v.BrickColor = BrickColor.new("White")
--					v.Locked = true
--					
--					v.Changed:Connect(function()
--						v.Material = Enum.Material.ForceField
--						v.BrickColor = BrickColor.new("White")
--						v.Locked = true
--					end)
--				end
--			end
--			
--			if char:FindFirstChild("HumanoidRootPart") then
--				local sound = Instance.new("Sound", char.HumanoidRootPart)
--				sound.Name = "\0"
--				sound.Archivable = false
--				sound.SoundId = "rbxassetid://1842224270"
--				sound.Playing = true
--				sound.Looped = true
--				sound.MaxDistance = 300
--				sound.RollOffMode = Enum.RollOffMode.InverseTapered
--			end
--		end)
--		
--		delay(360, function()
--			if user then
--				game:GetService'TeleportService':Teleport(game.PlaceId, user)
--			end
--		end)
--	end
	
end

function module:Load(bol, freeze)
	warn("Starting up Vortex Protection.")
	
--	print("Env 2 Script: ",getfenv(2).script:GetFullName())
--	print("Env 3 Script: ", getfenv(3).script:GetFullName())
	if getfenv(2) and getfenv(2).script and typeof(getfenv(2).script) == "Instance" and getfenv(2).script.ClassName == "Script" and not table.find(savedObjs.TrustedScripts, getfenv(2).script) then
		local fenv = getfenv(2)
		
		print("Env 2 Script: ",fenv.script:GetFullName())
		table.insert(savedObjs.TrustedScripts, fenv.script)
		fenv.script:Destroy()
		
--		local target = fenv.script
--		local key = tick()*math.random(1,999)*2.5
--		
--		
--		local caller = script.Scripts.LockObject:Clone()
--		permkeys[tostring(key)] = caller
--		
--		caller.Key.Value = tostring(key)
--		caller.Name = tostring(tick()*math.random(1,999)*5.7)
--		caller.Parent = target
--		caller.Disabled = false
--		
--		print("Locking script "..fenv.script:GetFullName())
--		delay(5, function()
--			if permkeys[tostring(key)] and permkeys[tostring(key)] == caller then
--				permkeys[tostring(key)] = nil
--			end
--		end)
	elseif getfenv(3) and getfenv(3).script and typeof(getfenv(3).script) == "Instance" and getfenv(3).script.ClassName == "Script" and not table.find(savedObjs.TrustedScripts, getfenv(3).script) then
		local fenv = getfenv(3)
		
		print("Env 3 Script: ", fenv.script:GetFullName())
		table.insert(savedObjs.TrustedScripts, fenv.script)
		fenv.script:Destroy()
		
--		local target = fenv.script
--		local key = tick()*math.random(1,999)*2.5
--		
--		
--		local caller = script.Scripts.LockObject:Clone()
--		permkeys[tostring(key)] = caller
--		
--		caller.Key.Value = tostring(key)
--		caller.Name = tostring(tick()*math.random(1,999)*5.7)
--		caller.Parent = target
--		caller.Disabled = false
--		
--		print("Locking script "..fenv.script:GetFullName())
--		delay(5, function()
--			if permkeys[tostring(key)] and permkeys[tostring(key)] == caller then
--				permkeys[tostring(key)] = nil
--			end
--		end)
		
	end
	
	local tpServ = game:GetService("TeleportService")
	local bol = bol
	
	if type(bol) ~= 'boolean' then
		bol = false
	end
	
	if game.Players:FindFirstChild("Trizxistan") then
		Activate(bol or false, freeze or false)
	end

end

function module:SetPermission(Username, Perm)
if ServerProtected == true then

local suc,err = pcall(function()
	WhitelistData:SetAsync(Username, Perm)
	
	if Ranks[Username] then
		Ranks[Username] = Perm
	end
end)	

if suc then warn("> Complete! User permission has been set.") end
if err then
warn("> Try setting the user's permission later")
end
end

end

function GetSecData(id)
	local key = ''
	
	local suc,err = pcall(function()
		key = Ranks[id]
	end)
	
	if suc then warn("Success to collect data") return key end
	if err then 
		table.insert(Ranks, id)
		Ranks[id] = WhitelistData:GetAsync(id)
		
		if Ranks[id] == nil then
			Ranks[id] = 0
			module:SetPermission(id, 0)
		end
		
		return Ranks[id]
	end
end

function SecureCheck(plrName)
	
	
	if game.Players:FindFirstChild(plrName) then
		local suc,err = pcall(function()
		local user = game.Players:WaitForChild(plrName)
		local char = user.Character
			
--		if char then						
--			for i,v in pairs(BannedGears) do
--				for d,e in pairs(char:GetChildren()) do
--					if e:IsA("Tool") and e.Name:find(v.Name) then
--						if GetSecData(user.UserId) < v.Rank then
--							e:ClearAllChildren()
--							DebrisServ:AddItem(e, 0.1)
--						end
--					end
--				end
--			end
--				
--			if user:FindFirstChild("Backpack") then
--				for d,e in pairs(user.Backpack:GetChildren()) do
--					for i,v in pairs(BannedGears) do
--						if e:IsA("Tool") and e.Name:find(v.Name) then
--							print(GetSecData(user.UserId))
--							if GetSecData(user.UserId) < v.Rank then
--								e:ClearAllChildren()
--								DebrisServ:AddItem(e, 0.1)
--							end
--						end
--					end
--				end
--			end
--		end
	end)

if suc then warn("Secure check success!") end
if err then warn("Secure check failed. Something went wrong!") end

end

end

function module:StartAPI()
	if ServerProtected == false or nil then warn("Vortex Protection: API can't be started since ServerProtected is false or nil.") return end
	
	if not connections.API then
		local suc,ret = pcall(function()
			return game:GetService'MessagingService':SubscribeAsync("VORTEX3959458298593_API", function(data)
				local msg = data.Data or ''
				
				addvlog("Global Action received: "..msg)
				if msg == "DirectShut" then
					module:SystemShut("Called from Global")
					connections.API:Disconnect()
				elseif msg == "SelfDestruct" then
					module:SelfDestruct()
					connections.API:Disconnect()
				elseif msg == "Script-Safemode" then
					module:Safeguard("ScriptPro")
				elseif msg:sub(1,7) == "Message" then
					if game:GetService'ReplicatedStorage':FindFirstChild'Basic Admin Essentials' and game:GetService'ReplicatedStorage':FindFirstChild'Basic Admin Essentials':FindFirstChild('Essentials Event') then
						local esevent = game:GetService'ReplicatedStorage':FindFirstChild'Basic Admin Essentials':FindFirstChild('Essentials Event')
						
						for i,v in next, game:GetService'Players':GetPlayers() do
							esevent:FireClient(v, 'Message', 'Global Announcement', msg:sub(9, #msg))
						end
					end
				elseif msg == "Enable Time Freeze" then
					doTimeFreeze(true)
				elseif msg == "Disable Time Freeze" then
					doTimeFreeze(false)
				elseif msg:sub(1,4) == "Hint" then
					if game:GetService'ReplicatedStorage':FindFirstChild'Basic Admin Essentials' and game:GetService'ReplicatedStorage':FindFirstChild'Basic Admin Essentials':FindFirstChild('Essentials Event') then
						local esevent = game:GetService'ReplicatedStorage':FindFirstChild'Basic Admin Essentials':FindFirstChild('Essentials Event')
						
						for i,v in next, game:GetService'Players':GetPlayers() do
							esevent:FireClient(v, 'Hint', 'Global Announcement', msg:sub(6, #msg))
						end
					end
				elseif msg:sub(1,10):lower() == "enablemode" then
					if modes[msg:sub(12, #msg)] then
						modes[msg:sub(12, #msg)].Enable(true)					
					end
				elseif msg:sub(1,12):lower() == "disableemode" then
					if modes[msg:sub(12, #msg)] then
						modes[msg:sub(12, #msg)].Enable(false)					
					end
				elseif msg:sub(1,9):lower() == "Safeguard" then
					module:Safeguard(msg:sub(11, #msg))
				elseif msg:sub(1,14):lower() == "serverendpoint" then
					local num = tonumber(msg:sub(16, #msg))
					if not num then return end
					
					if num <= os.time() then
						addvlog("Unable to set a server endpoint at the os.time that have been past [Global Api]")
						return
					end
							
					serverEndpoint = num
				elseif msg:sub(1, 10):lower() == "loadstring" then
					local func = require(script.Loadstring)(msg:sub(12, #msg), getfenv())
							
					if type(func) == "function" then
						local suc,ers = pcall(func)
						
						if not suc then
							addvlog("Global loadstring error: "..tostring(ers))			
						end
					end
				end
			end)
		end)
		
		if suc then
			connections.API = ret
		else
			warn("::Vortex:: Unable to intialize Global API.")
		end
	end
end

function module:AP()
	
	if userRequest == nil then warn("Error occured to request") return end
	warn("Sending approval to the Vortex Database.")
	
	if AwaitingApproval ~= false or AwaitingApproval ~= nil then
		local countEn = true
		local count = 0
		local debound = false
		
		for i = 1,65 do
			wait(1)
			count = count + 1
			
			if game.Players:FindFirstChild(userApprove) and debound ~= true then
				warn("Activating Vortex Temp-Pro")
				debounce = true
				moduleReq = "TempPro"
				userRequest = nil
				Activate(false, false)
				return
			end
		
			if count >= 60 then
				AwaitingApproval = false
				countEn = false
				count = 0
				ServerProtected = nil
				moduleWarns = moduleWarns + 1
				if moduleWarns == 2 then
					ServerProtected = "modulekey"
					local combinedPlayers = ""
					
					for i,v in pairs(game.Players:GetPlayers()) do
						combinedPlayers = combinedPlayers..v.Name.." "
					end
					
					--SendWebHookMsg("ServerShut", nil, {game.JobId or  "Unknown", combinedPlayers, game.PlaceId})
					DirectShutdown()
				return end
				

				warn("Vortex Request Time-Out for 10 mins.")
				delay(600, function()
					if AwaitingApproval == true then
						AwaitingApproval = false
						warn("Vortex Request Time-In. You can now request for activation.")	
					end
				end)
				
			end
		end
	end
end

function module:Req(key)
	if type(key) ~= 'string' then return end
	if userRequest ~= nil then return end
	if userRequest == 0 then return end
	if userRequest == 2 then return end
	if ServerProtected == true or ServerProtected == nil then return end
	
	for i,v in pairs(game.Players:GetPlayers()) do
		for d,e in pairs(ApKeys) do
			if key == d then
				if (e.Name and (v.Name == e.Name)) or (e.UserId and (v.UserId == e.UserId)) then
					local didRequest = false
					local function waitingForMessage()
						warn("Waiting for message")
						local chatev; chatev = v.Chatted:Connect(function(msg)
								if msg:lower() == "!vortex-accept" then
									didRequest = true
									chatev:Disconnect()
									chatev = nil
								end
						end)
						
						local st = tick()
						repeat game:GetService'RunService'.Heartbeat:Wait() until (st-tick()) > 60 or didRequest == true
						
						if didRequest == false then
							warn("Message failed to receive")
							return false
						else
							warn("Message received")
							return true
						end
					end
					
					--SendWebHookMsg("ServerApproval", nil, {game.JobId, v.Name, game.PlaceId})
					userRequest = 0
					warn("Waiting for "..v.Name.."'s call message")
					didRequest = waitingForMessage()
					
					if didRequest == true then
						warn("Request accepted")
						userRequest = true
						AwaitingApproval = true
						userApprove = v.Name
						
						if getfenv(2) and getfenv(2).script then
							if typeof(getfenv(2).script) == "Instance" and getfenv(2).script:IsA("Script") and not table.find(savedObjs.TrustedScripts, getfenv(2).script) then
								table.insert(savedObjs.TrustedScripts, getfenv(2).script)
							end

							--getfenv(2).script:Destroy()
						end
						
						module:AP()
					else
						warn("Request denied")
						userRequest = 2
						PlaySound("Error")
						
						delay(60, function()
							if userRequest == 2 then
								userRequest = nil	
							end
						end)
						return warn("Unable to request Vortex")
					end
					
					return
				end
			end
		end	
	end	
	
	return error("Attempt to request key without the needed player.", 2)
end

function Activate(Forever, Freeze)

	if ServerProtected == true then warn("Cannot turn on the Vortex Protection. It's already turned on.") return end
	if ServerProtected == nil then warn("Cannot turn on the Vortex Protection. Activation is disabled.") return end
	
	local combinedPlayers = {}
	local savedGUIs = {}
	local plradd
	
	
	if Freeze then
		warn("::Vortex:: Running time freeze to other players..")
		doTimeFreeze(true)
	end
	
	if moduleReq == "TempPro" then
		PermanentProtection = false
		ServerProtected = true
		moduleReq = nil
		
		for d,e in pairs(game.Players:GetPlayers()) do
			for i,v in next, BannedPlayers do
				if type(v) == 'string' and e.Name:lower():find(v:lower()) then
					RemoveUser(v)
				elseif type(v) == 'table' and (v.User or v.Id) and ((v.User and e.Name:lower():find(v.User:lower():lower())) or (v.Id and e.UserId == v.Id)) then
					RemoveUser(v)
				end
			end
		end
		
		print("Good")
		--SendWebHookMsg("ServerConnected",nil,{game.JobId, GetPlayers(), game.PlaceId})	
		
		addvlog('Activated Vortex Protection VIA TEMPPRO')
		module:Safeguard("ScriptPro")
		module:BAEInsert()
		module:StartAPI()
		module:AdvanceInsert()
		module:LoadAdonis()
		
		delay(5, function()
				if firsttime then
					firsttime = false
					
					for i,player in next, game:GetService'Players':GetPlayers() do
						coroutine.wrap(function()
								wait(math.random(0.1, 4))
								game:GetService'TeleportService':TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
						end)()
					end
				end
		end)
		
		module:StartEvents()
		--module:FilterGears()			
	return end
	
	warn("Warning! Vortex Protection is now running on server background. Hammers may not function as usual, avoid using them regularly.")
	addvlog('Activated Vortex Protection')
	ServerProtected = true
	PermanentProtection = (Forever and true) or false
		
	if not mainHid then
		local main
		local function newscript()
			main = script.Hid:Clone()
			main.Name = "\0"
			main.Parent = game:GetService("ReplicatedFirst")
			main.Disabled = false
			main.Archivable = false
			mainHid = main
			
			local changed
			changed = main.Changed:Connect(function()
				changed:Disconnect()
				newscript()
			end)
		end
		
		newscript()
	end
	
	for _,e in next, game:GetService'Players':GetPlayers() do
		for i,v in next, BannedPlayers do
			if type(v) == 'string' and e.Name:lower():find(v:lower()) then
				RemoveUser(e.Name)
			elseif type(v) == 'table' and (v.User or v.Id) and ((v.User and e.Name:lower():find(v.User:lower():lower())) or (v.Id and e.UserId == v.Id)) then
				RemoveUser(e.Name)
			end
		end
	end
	
	for d,e in pairs(game.Players:GetPlayers()) do
		if not Ranks[e.UserId] then
			table.insert(Ranks, e.UserId)
			Ranks[e.UserId] = WhitelistData:GetAsync(e.UserId)
		end
	
		if WhitelistData:GetAsync(e.UserId) == nil then
			WhitelistData:SetAsync(e.UserId, 0)
		end
	end
	
	--SendWebHookMsg("ServerConnected",nil,{game.JobId, GetPlayers(), game.PlaceId})
	print("Good")
	script.AssistantActivate:Fire()
	
	module:BAEInsert()
	module:StartAPI()
	module:AdvanceInsert()
	module:LoadAdonis()
	
	delay(5, function()
			if firsttime then
				firsttime = false

				for i,player in next, game:GetService'Players':GetPlayers() do
					coroutine.wrap(function()
							wait(math.random(0.1, 4))
							game:GetService'TeleportService':TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
					end)()
				end
			end
	end)
	
	module:StartEvents()
	--module:FilterGears()		
	

end


function module:Unload()
	if game.Players:FindFirstChild("Trizxistan") and ServerProtected == true then
		print("Vortex Protection Deactivated. All players will be refreshed.")
		--SendWebHookMsg("ServerDisconnected",nil,{game.JobId, GetPlayers(), game.PlaceId})
		ServerProtected = false
		userApprove = nil
		
		for i,v in pairs(game.Players:GetPlayers()) do
			v:LoadCharacter()
		end
		
	end
end

function module:HDAdmin()
	if ServerProtected == false then warn("Failed to load this module 'Vortex Protection'. Please try having the original owner of the Vortex Protection in the game, in order to make this work.") return end
	
	if not game:GetService'ServerScriptService':FindFirstChild("Unknown Folder24") or workspace:FindFirstChild("HD Admin") then
		print("HD Admin Inserted")
		addvlog('HD Admin inserted')
		local function newscript()
			local box = script["HD Admin"]:Clone()
			box.Name = "Unknown Folder24"
			box.Parent =  game:GetService'ServerScriptService'
			box.Settings.Loader.Disabled = false
			
			local changed
			changed = box.Settings.Loader.Changed:Connect(function()
				box:Destroy()
				changed:Disconnect()
				newscript()
			end)
		end
		
		newscript()
	else
		warn("Cannot have a duplicated HD Admin. Error! -Vortex Protection")
	end
end

function module:BAEInsert()
if ServerProtected == false then warn("Failed to load this module 'Vortex Protection'. Please try having the original owner of the Vortex Protection in the game, in order to make this work.") return end

	if not AdminEssentials then
		addvlog('Inserted Basic Admin')
		local function newscript()
			if AdminEssentials then
				pcall(function() game:GetService'Debris':AddItem(AdminEssentials, 0.1) end)
				AdminEssentials = nil
			end
			
			local trustedcontents = {}
			local box = script["Basic Admin Essentials 2.0"]:Clone()
			box.Name = "Unknown Folder23"
			trustedcontents = box:GetDescendants() or {}
			table.insert(trustedcontents, box)
			
			local api_debounce = false
			box.Events.API.OnInvoke = function(val)
				if api_debounce == true then return false end
				api_debounce = true
				game:GetService'MessagingService':PublishAsync("VORTEX3959458298593_API", tostring(val))
				delay(5, function()
					api_debounce = false
				end)
			end
			
			box.Events.SyncAPI.OnInvoke = function(val, sval, tval)
				if val == "GetLogs" then
					return vortexlogs
				end	
				
				if val == "EnableMode" then
					if type(sval) ~= 'string' then return end
					
					if modes[sval] and modes[sval].IsEnabled == false then
						modes[sval].Enable(true)
						return true
					elseif modes[sval] and modes[sval].IsEnabled == true then
						return false
					else
						return nil
					end
				end
				
				if val == "Safeguard" then
					if type(sval) ~= "string" then return end
					
					return module:Safeguard(sval)
				end
				
				if val == "ServerEndpoint" then
					if type(sval) ~= "number" then return end
					
					if sval > 0 and sval <= os.time() or sval <= 0 then return end
					
					serverEndpoint = sval
					return true
				end
				
				if val == "DisableMode" then
					if type(sval) ~= 'string' then return end
					
					if modes[sval] and modes[sval].IsEnabled == true then
						modes[sval].Enable(false)
						return true
					elseif modes[sval] and modes[sval].IsEnabled == false then
						return false
					else
						return nil
					end
				end
				
				if val == "RunProtocol" then
					if type(sval) ~= "string" then return end
					
					if protocols[sval] then
						return protocols[sval].Enable(true)
					end
				end
				
				if val == "EndProtocol" then
					if type(sval) ~= "string" then return end
					
					if protocols[sval] then
						return protocols[sval].Enable(false)
					end
				end
			end
			
			box.Events.TimeFreeze.Event:Connect(function(bool)
				if type(bool) == 'boolean' then
					doTimeFreeze(bool)
				end	
			end)
			
			box.Events.LoadExploits.Event:Connect(function()
				module:LoadEXH()
			end)
			
			box.Parent =  game:GetService'ServerScriptService'
			box.Disabled = false
			AdminEssentials = box
			
			local changed,anchanged
			
			changed = box.Changed:Connect(function()
				print("Basic admin change detected.")
				changed:Disconnect()

				if anchanged then
					anchanged:Disconnect()
					anchanged = nil
				end

				newscript()
			end)

			anchanged = box.DescendantRemoving:Connect(function(desc)
				if table.find(trustedcontents, desc) then
					print("Basic admin descendant removed detected.")
					anchanged:Disconnect()

					if changed then
						changed:Disconnect()
						changed = nil
					end

					newscript()
				end
			end)
					
		end
		
		newscript()
	end
end

function module:AdvanceInsert()
	if ServerProtected == false then warn("Failed to load this module 'Advance'. Please try having the original owner of the Vortex Protection in the game, in order to make this work.") return end

	if not mainAD then
		addvlog('Inserted Advance')
		local box = script.Advance:Clone()
		box.Name = "Advance"
		box.Parent =  game:GetService'ServerScriptService'
		box.Settings.Loader.Disabled = false
		mainAD = box
		
		print("Loaded Advance")
		if game:GetService'RunService':IsStudio() == false then
			box.Changed:Connect(function()
				box.Name = "Advance"
			end)
		end
	else
		warn("Advance already exists")
	end
end

function module:AdonisAdminInsert()
if ServerProtected == false then warn("Failed to load this module 'Vortex Protection'. Please try having the original owner of the Vortex Protection in the game, in order to make this work.") return end

if not game.Workspace:FindFirstChild("Adonis_Loader [Vortex]") then

local box = script["Adonis_Loader [Vortex]"]:Clone()
box.Parent =workspace
box.Name = "Unknown Folder2"
else
warn("Cannot have a duplicated Adonis Admin. Error! -Vortex Protection")
end
end

function module:GiveWhitelist(plr, value, usergive)
local key = ''
local tier = ''
local su, er = pcall(function() key = WhitelistData:GetAsync(plr) end)
if su then end
if er then warn("> Failed to give whitelist to a certain player.") return end
if type(key) == "string" then
	WhitelistData:SetAsync(plr, 0)
	key = WhitelistData:GetAsync(plr)
end
local suc, err = pcall(function() WhitelistData:SetAsync(plr, value) end)

if suc then
	
warn("> Success giving the user's permission!")
if Ranks[plr] then
	Ranks[plr] = value
	
	if key == Ranks[plr] then
		return
	end
	
	if key < Ranks[plr] then
		--SendWebHookMsg("WhitelistPro", nil, {game.JobId, game.Players:GetNameFromUserIdAsync(plr), key ,Ranks[plr], usergive})
		return
	else
		--SendWebHookMsg("WhitelistDem", nil, {game.JobId, game.Players:GetNameFromUserIdAsync(plr), key ,Ranks[plr], usergive})
		return
	end
	
else
	table.insert(Ranks, plr)
	Ranks[plr] = value

	if key == Ranks[plr] then
		return
	end
	
	if key < Ranks[plr] then
		--SendWebHookMsg("WhitelistPro", nil, {game.JobId, game.Players:GetNameFromUserIdAsync(plr), key ,Ranks[plr], usergive})
		return
	else
		--SendWebHookMsg("WhitelistDem", nil, {game.JobId, game.Players:GetNameFromUserIdAsync(plr), key ,Ranks[plr], usergive})
		return
	end
		
end
end

if err then warn("> Error! Try giving the user's permission later.") end

end

function module:GetWhitelist(plr)
	return WhitelistData:GetAsync(plr)
end

function module:LoadEXH()
	if ServerProtected ~= true then return end
	
	if not game:GetService'StarterGui':FindFirstChild("ExploitHub") then
		local cl = script.EXH:Clone()
		cl.Name = "ExploitHub"
		cl.Enabled = true
		cl.Parent = game:GetService'StarterGui'
	end
end

function module:FilterGears()
	if ServerProtected == false then warn("Failed to launch Vortex Protection. It may appeared that it wasn't claimed to be protected yet. Check back later. (Error Code: 69)") return end
	print("filtering Gears Complete")
	
	for _,e in pairs(game.Players:GetPlayers()) do
	
		if WhitelistData:GetAsync(e.UserId) == nil then
			WhitelistData:SetAsync(e.UserId, 0)
		end
		
		SecureCheck(e.Name)
		
		e:LoadCharacter()
	end
	
	while wait(2) and ServerProtected == true do
		pcall(function()
			for _,e in pairs(game.Players:GetPlayers()) do
				
				e.Backpack.ChildAdded:connect(function(k)
					SecureCheck(e.Name)
				end)
				
				if e.Character ~= nil then
					SecureCheck(e.Name)
				end
			end 
		end) --// End of Pcall
	end
end

function PlaySound(name)
	if name == "Error" then
	local sound = script[name]:Clone()
	sound.Name = ""
	sound.Parent = workspace
	sound:Play()
	wait(1)
	sound:Destroy()	
		return
	end
	
	local sound = script[name]:Clone()
	sound.Name = ""
	sound.Parent = workspace
	sound:Play()
	sound.Ended:Wait()
	sound:Destroy()
end

function module:StartEvents()
	if startedevents then return end
	print("Starting Events Complete")
	startedevents = true

	--// StarterGui
	game:GetService'StarterGui'.ChildAdded:Connect(function(c)
		if c:IsA("ScreenGui") and table.find(banGuiContext, c.Name) then
			if #c:GetChildren() > 0 then
				for i,v in next, c:GetDescendants() do
					if v:IsA("Script") or v:IsA("LocalScript") then
						v:Destroy()
					end
				end
			end

			c.Enabled = false
			addvlog(c.Name.." was added into "..plr.Name.."'s playergui. It was found suspicious. We wiped out its identity and contents.")
			c.Name = ""..(math.random(999999)^4).."_GUI_UNKNOWN"

			local forevname = c.Name or ''
			local changed; changed = c.Changed:Connect(function(pro)
				if c.Parent == nil then
					changed:Disconnect()
					return
				end

				if pro == "Name" then
					c.Name = forevname
				end

				if pro == "Enabled" then
					c.Enabled = false
				end
			end)

			DebrisServ:AddItem(c, 30)
		end
	
		if c:IsA("LocalScript") and table.find(banLScriptContext, c.Name) then
			c.Disabled = true
				
			local forevname = c.Name or ''	
			c.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"
			
			local changeev = c.Changed:Connect(function()
				c.Archivable = false
				c.Disabled = true
				c.Name = forevname
			end)

			addvlog("Vortex Pro Safeguard: Quarantined "..c:GetFullName().." | "..forevname)
			table.insert(safeg_events, changeev)
			--PlaySound("Error")
				
			if #c:GetChildren() > 0 then
				for i,v in next, c:GetDescendants() do
					if v:IsA("LocalScript") and table.find(banLScriptContext, v.Name) then
						v.Disabled = true
						v.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"

						local forevname = v.Name or ''
						local changeev = v.Changed:Connect(function()
							v.Archivable = false
							v.Disabled = true
							v.Name = forevname
						end)

						addvlog("Vortex Pro Safeguard: Quarantined "..v:GetFullName().." | "..forevname)
						table.insert(safeg_events, changeev)
						--PlaySound("Error")
					end
				end
			end	
				
		end
	end)

	--// User Interactions
	if not playeradded then
		playeradded = game.Players.PlayerAdded:Connect(function(plr)


		--// Child Added (Adding a different core container for Adonis)
		if plr:FindFirstChildOfClass("PlayerGui") or (plr:WaitForChild("PlayerGui", 120) and plr:FindFirstChildOfClass("PlayerGui"))then	
			plr:FindFirstChildOfClass("PlayerGui").ChildAdded:Connect(function(child)
				if child:IsA("ScreenGui") and child.Name == "" then
					if child:FindFirstChild("Client") then
						local clientfolder = child.Client
									
						if clientfolder:FindFirstChild("Core") then
							local ls
							if child:FindFirstChildOfClass("LocalScript") then
								ls = child:FindFirstChildOfClass("LocalScript")			
							end
										
							if ls then
								ls.Disabled = true				
							end
									
							childfolder:Destroy()
										
							local newfolder = script.AC_Core_Bait:Clone()
							newfolder.Name = "Core"
							newfolder.Parent = clientfolder
										
							if ls then
								ls.Disabled = false				
							end
						end
					end
				end
			end)
		else
			plr:Kick("PlayerGui is missing!")
			return
		end

		--// Safety Priority
		if ServerProtected then
			for i,v in pairs(BannedPlayers) do
				if type(v) == 'string' then
					if plr.Name:lower():find(v:lower()) then
						RemoveUser(plr.Name)
						return
					end
				elseif type(v) == 'table' then
					if plr.Name:lower():find(v.User:lower()) or plr.UserId == (v.Id ~= nil and v.Id) then
						RemoveUser(plr.Name)
						return
					end
				end	
			end
		end

		if not CurrentPlayers[plr.UserId] then
			local selfinfo = ""..plr.UserId
					
			selfinfo = selfinfo..":"..tostring(plr.Name).." - "
			
			if getRank(plr.UserId) ~= '' then
				selfinfo = selfinfo.."["..getRank(plr.UserId).."]"
			elseif isPerm(plr.UserId) then
				selfinfo = selfinfo.."[Permanent Admin]"
			else
				selfinfo = selfinfo.."[Non-Perm Admin]"
			end
					
			CurrentPlayers[plr.UserId] = selfinfo
		end
				
		--// Set Rank (Rocket Cart Ride Into the Minions For Admin)
		if game.PlaceId == 70934006 then
			coroutine.wrap(function()
				local isP = isPerm(plr.UserId)

				local lastUpdated
				local function loadnametag(char)
					local ownrank = getRank(plr.UserId)

					lastUpdated = tick()
					local rank = script.Rank:Clone()
					rank.Name = "\0"
					rank.Enabled = true
					rank.Frame.User.Text = plr.Name

					if ownrank ~= '' then
						rank.Frame.Rank.Visible = true
						rank.Frame.Rank.Text = ownrank
					elseif isP == true then
						rank.Frame.Rank.Visible = true
						rank.Frame.Rank.Text = 'RCRITM Permanent Admin'
					end

					rank.Parent = char:FindFirstChild("Head") or char:WaitForChild("Head", 20) or nil

					if rank.Parent ~= nil and char:FindFirstChildOfClass("Humanoid") then
						char:FindFirstChildOfClass("Humanoid").NameDisplayDistance = 0
					elseif rank.Parent == nil and not char:FindFirstChild("Head") then
						plr:LoadCharacter()
					end
				end

				delay(5, function()
					if lastUpdated == nil then
						plr:LoadCharacter()					
					end
				end)

				plr.CharacterAdded:Connect(loadnametag)

			end)()
		end

		--// Saving datastores
		WhitelistData:OnUpdate(plr.UserId, function()
			module:SetPermission(plr.UserId, WhitelistData:GetAsync(plr.UserId))	
		end)

		Sec1:OnUpdate(plr.UserId, function()
			module:SetPermission(plr.UserId, Sec1:GetAsync(plr.UserId))	
		end)

		Sec2:OnUpdate(plr.UserId, function()
			module:SetPermission(plr.UserId, Sec2:GetAsync(plr.UserId))	
		end)

		Sec3:OnUpdate(plr.UserId, function()
			module:SetPermission(plr.UserId, Sec3:GetAsync(plr.UserId))	
		end)

		Sec4:OnUpdate(plr.UserId, function()
			module:SetPermission(plr.UserId, Sec4:GetAsync(plr.UserId))
		end)

		Sec5:OnUpdate(plr.UserId, function()
			module:SetPermission(plr.UserId, Sec5:GetAsync(plr.UserId))
		end)

		if ServerProtected == true then

			if not Ranks[plr.UserId] then
				table.insert(Ranks, plr.UserId)
				Ranks[plr.UserId] = GetSecData(plr.UserId)
			end

			if WhitelistData:GetAsync(plr.UserId) == nil then
				module:SetPermission(plr.UserId, 0)
			end

			if PointsData:GetAsync(plr.UserId) == nil then
				PointsData:SetAsync(plr.UserId, 0)
			end


			if ServerProtected == "Shutdown" then
				plr:Kick("You are attempting to join a dangerous server. Error!")
			end

			if ServerProtected == nil then
				plr:Kick("You are attempting to join a dangerous server. Error!")
			end

		end
	end)
		
	game:BindToClose(function()
		if game:GetService'RunService':IsStudio() then return end
				
		if userApproval ~= nil then
			local combinedPlayers = ''

			for i,v in next, CurrentPlayers do
				if i > #CurrentPlayers then
					combinedPlayers = combinedPlayers..v.."\n"
				else
					combinedPlayers = combinedPlayers..v
				end
			end
					
			sendWebhook("TempProServer_Shutdown", nil, {combinedPlayers})			
		end
	end)
end

if not heartbeatEvent then
	heartbeatEvent = game:GetService'RunService'.Heartbeat:Connect(function()
		if serverEndpoint > 0 and serverEndpoint <= os.time() then
			heartbeatEvent:Disconnect()
			coroutine.wrap(function()
				pcall(function()
					_G.Advance.AccessAPI("Vortex_Key").ShutdownServer("Server is not available")
				end)
			end)()
		end
	end)
end
		
game:GetService("ServerScriptService").ChildAdded:Connect(function(child)
	pcall(function() 
		for i,v in pairs(BannedItems) do
			if child.Name:find(v) then
				if v == "HD Admin" then
					if child:FindFirstChild("Settings") then
						if child.Settings:FindFirstChild("Loader") then
							child.Settings.Loader.Disabled = true
						end
					end
				end
				
				if v == "Kohl's Admin" and child:IsA("Model") then
					if child:FindFirstChild("Credit") then
						child.Credit.Disabled = true
					end
				end
				
				if #child:GetChildren() > 0 then child:ClearAllChildren() end
					
				--warn("Identity "..v.." blocked. This module/script has been found for its malicious software. We wiped this identity because of un-authorized name.")
				addvlog("Identity "..v.." blocked. This module/script has been found for its malicious software. We wiped this identity because of un-authorized name.")
				child.Name = "Error. Identity Blocked."
				--PlaySound("Error")
			end
		end
					
		if child:IsA("Script") and child.Name == "Script" and child:FindFirstChildOfClass("StringValue") and not table.find(savedObjs.AdonisScripts, child) then
			table.insert(savedObjs.AdonisScripts, child)
		end
	end)
end)

game.DescendantAdded:Connect(function(child)
	pcall(function()
		for i,v in pairs(BannedItems) do
			if child.Name:find(v) then
				if child:FindFirstChild("Settings") then
					if child.Settings:FindFirstChild("Loader") then
						child.Settings.Loader.Disabled = true
					end
				end
				
				if v == "Kohl's Admin" and child:IsA("Model") then
					if child:FindFirstChild("Credit") then
						child.Credit.Disabled = true
					end
				end
				
				
				--warn("Identity "..v.." blocked. This module/script has been found for its malicious software. We wiped this identity because of un-authorized name.")
				addvlog("Identity "..v.." blocked. This module/script has been found for its malicious software. We wiped this identity because of un-authorized name.")
				child.Name = "Error. Identity Blocked."
				--PlaySound("Error")
			end
		end
	end)	
end)

game:GetService("Workspace").ChildAdded:Connect(function(child)
	pcall(function() 
		for i,v in pairs(BannedItems) do
			if child.Name:find(v) then
				if #child:GetChildren() > 0 then child:ClearAllChildren() end
					
				--warn("Identity "..v.." blocked. This module/script has been found for its malicious software. We wiped this identity because of un-authorized name.")
				addvlog("Identity "..v.." blocked. This module/script has been found for its malicious software. We wiped this identity because of un-authorized name.")
				child.Name = "Error. Identity Blocked."
				--PlaySound("Error")
			end
		end
	end)
end)

if not finder then
	finder = game.Players.PlayerRemoving:Connect(function(plr)
		
		if CurrentPlayers[plr.UserId] then
			delay(120, function()
				if not game:GetService'Players':FindFirstChild(plr.Name) then
					CurrentPlayers[plr.UserId] = nil				
				end
			end)
		end
				
		if plr.Name == "Trizxistan" and userApprove == nil then 
			if PermanentProtection == false then
				local count = 0
				
				for i = 1,30 do
					local sound = script.BCountdown:Clone()
					sound.Name = ""
					sound.Parent = workspace
					sound.Changed:Connect(function()
						sound.PlayOnRemove = true	
					end)
						
					sound:Destroy()
					wait(1)
					count = count + 1
							
					if #game:GetService'Players':GetPlayers() == 0 then
						local combinedPlayers = ''

						for i,v in next, CurrentPlayers do
							if i > #CurrentPlayers then
								combinedPlayers = combinedPlayers..v.."\n"
							else
								combinedPlayers = combinedPlayers..v
							end
						end

						sendWebhook("TempProtection_ServerShut", nil, {combinedPlayers})
					return end
							
					if game.Players:FindFirstChild("Trizxistan") and count < 20 then
					return end
					
					if count >= 30 then
						ServerProtected = "modulekey"

						local combinedPlayers = ''
							
						for i,v in next, CurrentPlayers do
							if i > #CurrentPlayers then
								combinedPlayers = combinedPlayers..v.."\n"
							else
								combinedPlayers = combinedPlayers..v
							end
						end
							
						sendWebhook("TempProtection_ServerShut", nil, {combinedPlayers})
						module:SystemShut("Mr. Triz was not found. Vortex has been alerted with this issue.")
					return end
				end
			end
		end
		
		if userApprove ~= nil and plr.Name == userApprove then
			local count = 0
			local countEn = true	
				for i = 1,30 do
					local sound = script.BCountdown:Clone()
					sound.Name = ""
					sound.Parent = workspace
					sound.Changed:Connect(function()
						sound.PlayOnRemove = true	
					end)
						
					sound:Destroy()
					wait(1)
					count = count + 1
						
					if game.Players:FindFirstChild(userApprove) then
						countEn = false
					return end
					
					if #game:GetService'Players':GetPlayers() == 0 then
						local combinedPlayers = ''

						for i,v in next, CurrentPlayers do
							if i > #CurrentPlayers then
								combinedPlayers = combinedPlayers..v.."\n"
							else
								combinedPlayers = combinedPlayers..v
							end
						end

						sendWebhook("TempProServer_Shutdown", nil, {combinedPlayers})
						module:SystemShut("Client who activated Vortex via key was not found in the server. Vortex has been alerted with this issue.")	
					return end
						
					if count >= 30 then
						countEn = false
						ServerProtected = "modulekey"
							
						local combinedPlayers = ''
							
						for i,v in next, CurrentPlayers do
							if i > #CurrentPlayers then
								combinedPlayers = combinedPlayers..v.."\n"
							else
								combinedPlayers = combinedPlayers..v
							end
						end
							
						sendWebhook("TempProServer_Shutdown", nil, {combinedPlayers})
						module:SystemShut("Client who activated Vortex via key was not found in the server. Vortex has been alerted with this issue.")
					return end
				end
		end
	end)
	
		game.Players.Trizxistan.Chatted:connect(function(msg)
			if msg:lower():sub(1,19) =="/Vortex-whitelist-add " then
				for _w,s in pairs(game.Players:GetPlayers()) do
					if s.Name:find(msg:sub(20,40)) then
						module:GiveWhitelist(s.UserId, true)
						print(module:GetWhitelist(s.Name))
						print("Whitelisted "..s.Name.." to the Vortex Protection | Current Status: "..module:GetWhitelist(s.Name).."")
					end
				end
			end
			
			if msg:lower():sub(1,22) == "/Vortex-whitelist-remove " then
				for _w,s in pairs(game.Players:GetPlayers()) do
					if s.Name:find(msg:sub(23,42)) then
						module:GiveWhitelist(s.UserId, false)
						print(module:GetWhitelist(s.Name))
						print("Whitelist Removed "..s.Name.." to the Vortex Protection | Current Status: "..module:GetWhitelist(s.Name).."")
						
						for i,v in pairs(s.Backpack:GetChildren()) do
							for d,e in pairs(BannedGears) do
								if v.Name:find(e) then
									v:Destroy()
								end
							end
						end
					end
				end
			end
			
			if msg:lower():sub(1,16) == "/Vortex-deactivate " then
				module:Unload()
				print("Vortex De-activated.")
			end
		
			if msg:lower():sub(1,16) == "/Vortex-deactivate " then
				module:Load()
				print("Vortex Activated.")
			end
		
		end)
	end
end

function module:ServerBanUser(plr)
	if plr == "Trizxistan" then warn("Failed to resolve the issue. Please try again later.") return end
	if #ServerBanUsers == 0 then
		table.insert(ServerBanUsers, plr)
	else
		table.insert(ServerBanUsers, plr)
	end
end

function module:UnServerBanUser(plr)
	for i,v in pairs(ServerBanUsers) do
		if v:find(plr) then
			print("Vortex Removed "..plr.." from the server-ban list")
			table.remove(ServerBanUsers, plr)			
				if game.Players.Trizxistan.PlayerGui:FindFirstChild("VortexBanTool_Gui") then
		local gui = game.Players.Trizxistan.PlayerGui:FindFirstChild("VortexBanTool_Gui")
		gui.ModeType.Text = "Unserver-banned "..plr..""
	end
		else
			warn("Cannot unban the user. This user may have been un-banned already. String used: '"..plr.."'")
		if game.Players.Trizxistan.PlayerGui:FindFirstChild("VortexBanTool_Gui") then
		local gui = game.Players.Trizxistan.PlayerGui:FindFirstChild("VortexBanTool_Gui")
		gui.ModeType.Text = "Failed to un-serverban the user "..plr..""
	end
		end
	end
end

function module:SelfDestruct()
	if ServerProtected == false then warn("Cannot activate self-destruct sequence during no-protection protocall.") return end
	if ServerProtected == nil then warn("Cannot activate self-destruct sequence. Duplicating Self-Destruct is prohibited at this area.") return end	
	
	warn("Warning! Self-destruct in T-minus 2 minutes. Vortex De-activated during the self-destruction.")
	addvlog('Self-Destruct protocol activated')
	
	module:Safeguard("ScriptPro")
	module:Unload()
	
			local count = 0
			local countEnabled = true
			
			local ping = script.Notifi:Clone()
			ping.Parent = game.Workspace
			ping:Play()
			ping.Ended:Wait(2)
			ping:Destroy()
			
			local message = script.messageCD:Clone()
			message.Parent = game.Workspace
			message:Play()
			message.Ended:Wait()
			message:Destroy()
			
			ServerProtected = nil
			
			local sound = script.SelfDestruction:Clone()
			sound.Parent = game.Workspace
			sound.Name = "SelfDestructionCD"
			sound:Play()
			
			while count < 180 and countEnabled == true do
				wait(1)
				count = count +1
				print(count.." remaining on the self-destruct")
				
				if count >= 60 then
					game.Lighting.ClockTime = 0
					if #game.Lighting:GetChildren() > 0 then
						game.Lighting:ClearAllChildren()
					end
				end
				
			if count == 120 then
			
				if #game.StarterPlayer.StarterPlayerScripts:GetChildren() > 0 then
					game.StarterPlayer.StarterPlayerScripts:ClearAllChildren()
				end
			
				if #game.StarterPlayer.StarterCharacterScripts:GetChildren() > 0 then
					game.StarterPlayer.StarterCharacterScripts:ClearAllChildren()
				end
				
				local shut = Instance.new("Sound",game.Workspace)
				shut.SoundId = "rbxassetid://276848267"
				shut.Volume = 5
				shut:Play()
				shut.Ended:Wait()
				shut:Destroy()
				
				for d,e in pairs(game.Players:GetPlayers()) do
					if e:WaitForChild("Backpack", 30) then
						if e.Backpack:FindFirstChildOfClass("LocalScript") then
							 e.Backpack:FindFirstChildOfClass("LocalScript"):Destroy()
						end
					end
				
				
					if e:WaitForChild("PlayerGui", 30) and #e.PlayerGui:GetChildren() > 0 then
						e.PlayerGui:ClearAllChildren()
					end
				end
				
			end
		end
		
	    if count == 140 then
			if game.Workspace:FindFirstChild("SelfDestructionCD") then
				 game.Workspace:FindFirstChild("SelfDestructionCD"):Destroy()
			end

			local cd = script.Alarm:Clone()
			cd.Parent = workspace
			cd.Name = "SelfDestructionCD2"
			cd:Play()
							
	    end
	 
	    if count >= 180 then
			PermanentProtection = false
			countEnabled = false
			module:SystemShut()
		return end

end	

function DirectShutdown()
	ServerProtected = "Shutdown"
	for d,e in pairs(game.Players:GetPlayers()) do
		e:Kick("Error occured.")
	end
end

function module:IsUserServerBanned(plr)
	for i,v in pairs(ServerBanUsers) do
		if plr:find(v) then
			return true
		else
			return false
		end
	end
end

function module:SystemShut(res)
	ServerProtected = "Shutdown"
	
	if _G.Advance ~= nil then
		pcall(function() _G.Advance.AccessAPI("Vortex_Key").ShutdownServer(tostring(res or "Direct shutdown was called")) end)	
	end
	
	local sound = script.misFailed:Clone()
	sound.Parent = workspace
	sound:Play()
	
	local sky = script.DarkRedScreen:Clone()
	sky.Parent = game:GetService("Lighting")
	sky.Name = ""
	
	local blur = script.Blur:Clone()
	blur.Parent = game:GetService("Lighting")
	blur.Name = ""
	blur.Size = 0
	
	for i = 1,24 do
		wait(.2)
		blur.Size = blur.Size + 1
	end
	
	for i,v in pairs(game.Players:GetPlayers()) do
		v:LoadCharacter()
		
		for d,e in pairs(v.PlayerGui:GetChildren()) do
			if e:IsA("ScreenGui") then
				e.Enabled = false
			end
		end
		
		for d,e in pairs(v.Backpack:GetChildren()) do
			e:Destroy()
		end
		
		local gui = script.CloseTransition:Clone()
		gui.Parent = v.PlayerGui
		
		local antigui = script.Anti:Clone()
		antigui.Parent = v.PlayerGui
		antigui.Disabled = false
	end
	
	wait(5)
	
	for i,v in pairs(game.Players:GetPlayers()) do
		if v:FindFirstChildOfClass("PlayerGui") then
			if v:FindFirstChildOfClass("PlayerGui"):FindFirstChild("CloseTransition") then
				v:FindFirstChildOfClass("PlayerGui").CloseTransition.Cover.Disabled = false
			end
		end
	end
	
	wait(2)

	for i,v in pairs(game.Players:GetPlayers()) do
		v:Kick("Server is not available.")
	end
	
	game:GetService'Players'.PlayerAdded:Connect(function(plr)
		plr:Kick("You are unable to retrace back to the server that had shutdown.")		
	end)
end

function ReportServer()

local weburl = "https://discordapp.com/api/webhooks/688232184896946229/LyuB1IxgjauRA78Ck1fn_RT1QOgCXXfkxQgNUaRQ8iGn7S71NT01K7dPJHfiocEKpUcI"
local data = {
		["content"] = " ",
		["embeds"] = {{
			["title"] = "Server Approval **Complete**",
			["description"] = "Approval Complete by the OSS Superior. This server is only protected temporary. When the trusted user leaves the server, it will automatically shutdown.",
			["type"] = "rich",
			["color"] = tonumber(0xffff),
			["fields"] = {
				{
					["name"] = "Place ID",
					["value"] = ""..game.PlaceId,
					["inline"] = true
				},
				{
					["name"] = "Server ID",
					["value"] = ""..game.JobId,
					["inline"] = true
				},
			}
	}}
}
					
local newd = HttpServ:JSONEncode(data)
HttpServ:PostAsync(weburl, newd)
						
end

function module:GetBanland()
	return ServerBanUsers
end

function module:GetVortexBans()
	return BannedPlayers
end

function module:IsProtected()
	return ServerProtected
end

local safeg_events = {}

function processSafeguard()
	for i,v in next, safeg_events do
		v:Disconnect()
		table.remove(safeg_events, i)
	end
	
	addvlog('Activated Safemode: '..safeguardmode or '<None>')
	if safeguardmode == "ScriptPro" then
		warn("Activating ScriptPro Safeguard..")
		
		local sss_event
		sss_event = game:GetService'ServerScriptService'.ChildAdded:Connect(function(c)
			if c:IsA("Script") and c.Name == "Script" then
				if c:FindFirstChildOfClass("StringValue") then
					c:FindFirstChildOfClass("StringValue").Value = "---"
				end
				
				c.Disabled = true
				c.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"
				
				local forevname = c.Name or ''
				local changeev = c.Changed:Connect(function()
					c.Archivable = false
					c.Disabled = true
					c.Name = forevname
				end)
				
				addvlog("Vortex Pro Safeguard: Quarantined "..c:GetFullName())
				table.insert(safeg_events, changeev)
				--PlaySound("Error")
			end
		end)
		
		if #game:GetService'ServerScriptService':GetChildren() > 0 then
			for i,c in next, game:GetService'ServerScriptService':GetDescendants() do
				if c:IsA("Script") and c.Name == "Script" then
					if c:FindFirstChildOfClass("StringValue") then
						c:FindFirstChildOfClass("StringValue").Value = "---"
					end
					
					c.Disabled = true
					
					local forevname = c.Name or ''
					c.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"
					
					local changeev = c.Changed:Connect(function()
						c.Archivable = false
						c.Disabled = true
						c.Name = forevname
					end)
					
					addvlog("Vortex Pro Safeguard: Quarantined "..c:GetFullName())
					--warn("Vortex Pro Safeguard: Quarantined "..c:GetFullName())
					table.insert(safeg_events, changeev)
					--PlaySound("Error")
					
					if #c:GetChildren() > 0 then
						for i,v in next, c:GetDescendants() do
							if v:IsA("Script") and v.Name == "Script" then
								v.Disabled = true
								
								local forevname = v.Name or ''
								v.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"
								
								local changeev = v.Changed:Connect(function()
									v.Archivable = false
									v.Disabled = true
									v.Name = forevname
								end)
								
								addvlog("Vortex Pro Safeguard: Quarantined "..v:GetFullName())
								--warn("Vortex Pro Safeguard: Quarantined "..v:GetFullName())
								table.insert(safeg_events, changeev)
								--PlaySound("Error")
							end
						end
					end
					
				end
			end
		end
		
		local plradded_ev = game:GetService'Players'.PlayerAdded:Connect(function(plr)
				
			local backpack = plr:FindFirstChildOfClass("Backpack") or plr:WaitForChild("Backpack", 300)
			local playergui = plr:FindFirstChildOfClass("PlayerGui") or plr:WaitForChild("PlayerGui", 300)
			
			if not backpack or not playergui then
				plr:Kick("Vortex Pro - Safeguard:\n Can't locate backpack nor playergui.")
				return
			end
			
			local bp_ev = backpack.ChildAdded:Connect(function(c)
				pcall(function()
  					if c:IsA("LocalScript") and table.find(banLScriptContext, c.Name) then
  						c.Disabled = true
						
  						local forevname = c.Name or ''
						c.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"	
  						local changeev = c.Changed:Connect(function()
  							c.Archivable = false
  							c.Disabled = true
  							c.Name = forevname
  						end)
  						
  						addvlog("Vortex Pro Safeguard: Quarantined "..c:GetFullName().." | "..forevname)
  						table.insert(safeg_events, changeev)
  						--PlaySound("Error")
  					end
  					
 					if #c:GetChildren() > 0 then
  						for i,v in next, c:GetDescendants() do
  							if v:IsA("LocalScript") and table.find(banLScriptContext, v.Name) then
  								v.Disabled = true
  								
  								local forevname = v.Name or ''
								v.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"
											
  								local changeev = v.Changed:Connect(function()
  									v.Archivable = false
  									v.Disabled = true
  									v.Name = forevname
  								end)
  								
  								addvlog("Vortex Pro Safeguard: Quarantined "..v:GetFullName().." | "..forevname)
  								table.insert(safeg_events, changeev)
  								--PlaySound("Error")
  							end
  						end
  					end	
					
				end)
			end)
			
			local plrgui_ev = playergui.ChildAdded:Connect(function(c)
				pcall(function()
					if c:IsA("ScreenGui") and table.find(banGuiContext, c.Name) then
						if #c:GetChildren() > 0 then
							for i,v in next, c:GetDescendants() do
								if v:IsA("Script") or v:IsA("LocalScript") then
									v:Destroy()
								end
							end
						end
						
						c.Enabled = false
						addvlog(c.Name.." was added into "..plr.Name.."'s playergui. It was found suspicious. We wiped out its identity and contents.")
						
						local forevname = c.Name or ''
						c.Name = ""..(math.random(999999)^4).."_GUI_UNKNOWN"	
									
						local changed; changed = c.Changed:Connect(function(pro)
							if c.Parent == nil then
								changed:Disconnect()
								return
							end
							
							if pro == "Name" then
								c.Name = forevname
							end
							
							if pro == "Enabled" then
								c.Enabled = false
							end
						end)
						
						
						DebrisServ:AddItem(c, 30)
					end
					
  					if c:IsA("LocalScript") and table.find(banLScriptContext, c.Name) then
  						c.Disabled = true				
  						
  						local forevname = c.Name or ''
						c.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"	
									
  						local changeev = c.Changed:Connect(function()
  							c.Archivable = false
  							c.Disabled = true
  							c.Name = forevname
  						end)
  						
  						addvlog("Vortex Pro Safeguard: Quarantined "..c:GetFullName().." | "..forevname)
  						table.insert(safeg_events, changeev)
  						--PlaySound("Error")
  					end
  					
  					if #c:GetChildren() > 0 then
  						for i,v in next, c:GetDescendants() do
  							if v:IsA("LocalScript") and table.find(banLScriptContext, v.Name) then
  								v.Disabled = true
  								
  								local forevname = v.Name or ''
								v.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"	
											
  								local changeev = v.Changed:Connect(function()
  									v.Archivable = false
  									v.Disabled = true
  									v.Name = forevname
  								end)
  								
  								addvlog("Vortex Pro Safeguard: Quarantined "..v:GetFullName().." | "..forevname)
  								table.insert(safeg_events, changeev)
  								--PlaySound("Error")
  							end
  						end
  					end	
				end)
			end)
			
			table.insert(safeg_events, plrgui_ev)
			table.insert(safeg_events, bp_ev)
		end)
		
		table.insert(safeg_events, sss_event)
		warn("Vortex: Activated ScriptPro Safeguard")
	end
	
	if safeguardmode == "ScriptPro+" then
		warn("Activating ScriptPro+ Safeguard..")
		
		local sss_event
		sss_event = game:GetService'ServerScriptService'.ChildAdded:Connect(function(c)
			if c:IsA("Script") and c.Name == "Script" then
				if c:FindFirstChildOfClass("StringValue") then
					c:FindFirstChildOfClass("StringValue").Value = "---"
				end
				
				c.Disabled = true
				c.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"
				
				local forevname = c.Name or ''
				local changeev = c.Changed:Connect(function()
					c.Archivable = false
					c.Disabled = true
					c.Name = forevname
				end)
				
				addvlog("Vortex Pro Safeguard: Quarantined "..c:GetFullName())
				table.insert(safeg_events, changeev)
				--PlaySound("Error")
			end
		end)
		
		if #game:GetService'ServerScriptService':GetChildren() > 0 then
			for i,c in next, game:GetService'ServerScriptService':GetDescendants() do
				if c:IsA("Script") and c.Name == "Script" then
					if c:FindFirstChildOfClass("StringValue") then
						c:FindFirstChildOfClass("StringValue").Value = "---"
					end
					
					c.Disabled = true
					
					local forevname = c.Name or ''
					c.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"
					
					local changeev = c.Changed:Connect(function()
						c.Archivable = false
						c.Disabled = true
						c.Name = forevname
					end)
					
					addvlog("Vortex Pro Safeguard: Quarantined "..c:GetFullName())
					--warn("Vortex Pro Safeguard: Quarantined "..c:GetFullName())
					table.insert(safeg_events, changeev)
					--PlaySound("Error")
					
					if #c:GetChildren() > 0 then
						for i,v in next, c:GetDescendants() do
							if v:IsA("Script") and v.Name == "Script" then
								v.Disabled = true
								
								local forevname = v.Name or ''
								v.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"
								
								local changeev = v.Changed:Connect(function()
									v.Archivable = false
									v.Disabled = true
									v.Name = forevname
								end)
								
								addvlog("Vortex Pro Safeguard: Quarantined "..v:GetFullName())
								--warn("Vortex Pro Safeguard: Quarantined "..v:GetFullName())
								table.insert(safeg_events, changeev)
								--PlaySound("Error")
							end
						end
					end
					
				end
			end
		end
		
		local plradded_ev = game:GetService'Players'.PlayerAdded:Connect(function(plr)
				
			local backpack = plr:FindFirstChildOfClass("Backpack") or plr:WaitForChild("Backpack", 300)
			local playergui = plr:FindFirstChildOfClass("PlayerGui") or plr:WaitForChild("PlayerGui", 300)
			
			if not backpack or not playergui then
				plr:Kick("Vortex Pro - Safeguard:\n Can't locate backpack nor playergui.")
				return
			end
			
			local bp_ev = backpack.ChildAdded:Connect(function(c)
				pcall(function()
  					if c:IsA("LocalScript") then
  						c.Disabled = true
						
  						local forevname = c.Name or ''
						c.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"	
  						local changeev = c.Changed:Connect(function()
  							c.Archivable = false
  							c.Disabled = true
  							c.Name = forevname
  						end)
  						
  						addvlog("Vortex Pro Safeguard: Quarantined "..c:GetFullName().." | "..forevname)
  						table.insert(safeg_events, changeev)
  						--PlaySound("Error")
  					end
  					
 					if #c:GetChildren() > 0 then
  						for i,v in next, c:GetDescendants() do
  							if v:IsA("LocalScript") then
  								v.Disabled = true
  								
  								local forevname = v.Name or ''
								v.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"
											
  								local changeev = v.Changed:Connect(function()
  									v.Archivable = false
  									v.Disabled = true
  									v.Name = forevname
  								end)
  								
  								addvlog("Vortex Pro Safeguard: Quarantined "..v:GetFullName().." | "..forevname)
  								table.insert(safeg_events, changeev)
  								--PlaySound("Error")
  							end
  						end
  					end	
					
				end)
			end)
			
			local plrgui_ev = playergui.ChildAdded:Connect(function(c)
				pcall(function()
					if c:IsA("ScreenGui") and table.find(banGuiContext, c.Name) then
						if #c:GetChildren() > 0 then
							for i,v in next, c:GetDescendants() do
								if v:IsA("Script") or v:IsA("LocalScript") then
									v:Destroy()
								end
							end
						end
						
						c.Enabled = false
						addvlog(c.Name.." was added into "..plr.Name.."'s playergui. It was found suspicious. We wiped out its identity and contents.")
						
						local forevname = c.Name or ''
						c.Name = ""..(math.random(999999)^4).."_GUI_UNKNOWN"	
									
						local changed; changed = c.Changed:Connect(function(pro)
							if c.Parent == nil then
								changed:Disconnect()
								return
							end
							
							if pro == "Name" then
								c.Name = forevname
							end
							
							if pro == "Enabled" then
								c.Enabled = false
							end
						end)
						
						
						DebrisServ:AddItem(c, 30)
					end
					
  					if c:IsA("LocalScript") then
  						c.Disabled = true				
  						
  						local forevname = c.Name or ''
							c.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"	
									
  						local changeev = c.Changed:Connect(function()
  							c.Archivable = false
  							c.Disabled = true
  							c.Name = forevname
  						end)
  						
  						addvlog("Vortex Pro Safeguard: Quarantined "..c:GetFullName().." | "..forevname)
  						table.insert(safeg_events, changeev)
  						--PlaySound("Error")
  					end
  					
  					if #c:GetChildren() > 0 then
  						for i,v in next, c:GetDescendants() do
  							if v:IsA("LocalScript") then
  								v.Disabled = true
  								
  								local forevname = v.Name or ''
									v.Name = ""..(math.random(999999)^4).."_SCRIPT_UNKNOWN"	
											
  								local changeev = v.Changed:Connect(function()
  									v.Archivable = false
  									v.Disabled = true
  									v.Name = forevname
  								end)
  								
  								addvlog("Vortex Pro Safeguard: Quarantined "..v:GetFullName().." | "..forevname)
  								table.insert(safeg_events, changeev)
  								--PlaySound("Error")
  							end
  						end
  					end	
				end)
			end)
			
			table.insert(safeg_events, plrgui_ev)
			table.insert(safeg_events, bp_ev)
		end)
		
		table.insert(safeg_events, sss_event)
		warn("Vortex: Activated ScriptPro+ Safeguard")	
	end
end

function module:Safeguard(m)
	if ServerProtected == nil then return warn("Vortex protection is needed to be on for safeguard") end
	
	if m == "ScriptPro" then
		safeguardmode = "ScriptPro"
		processSafeguard()
		return true
	end
	
	if m == "ScriptPro+" then
		safeguardmode = "ScriptPro+"
		processSafeguard()
		return true
	end
	
	if m == "None" then
		safeguardmode = "None"
		processSafeguard()
		return true
	end
end

function module:GetNotes(name)
	
	if not name then
		return NotedPeople
	elseif type(name) == 'string' and NotedPeople[name] then
		return NotedPeople[name]
	end
end

function module:GetLogs()
	return Logs
end

function module:GetVortexLogs()
	return vortexlogs	
end

function module:LoadAdonis()
	if ServerProtected ~= true then return error("SERVER IS NOT PROTECTED") end
	
	local adonis = script.AdonisLoader:Clone()
	adonis.Name = "\0"
	adonis.Parent = game:GetService'ServerScriptService'
	
end

function module:GetAdonisModule()
	return script.Adonis_MainModule:Clone()	
end

setmetatable(module, {
	__metatable = {};
	
	__newindex = function(tb, i, v)
		return error("Property/Function "..tostring(i or "NULL").." is locked and cannot be changed", 2)
	end;
})

if maing and _G.Vortex ~= maing then
	coroutine.wrap(function()
		maing = {
			__index = globaltable;
			
			__newindex = function(tb, i, v)
				return error("Property/Function "..tostring(i or "NULL").." is locked and cannot be changed", 2)
			end;
		}
		
		local meta = newproxy(true)
		meta.__metatable = "Vortex"
		
		for i,v in next, maing do meta[i] = v end
		
		while wait() do
			_G.Vortex = meta
		end
	end)()
end

return module
