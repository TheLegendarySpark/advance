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
} do locals[ind] = loc end

service = setfenv(require(script.Core.Service), GetEnv(require(script.Core.Service), {api = API, unpack(locals)}))()
local Aeslua = require(5518586604)
local ignorefolders = {"Core"}
API.Functions = setfenv(require(script.Core.Functions), GetEnv(require(script.Core.Functions), {api = API, unpack(locals)}))()

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

function API:GetObject(folder, name)
	assert(type(folder) == 'string', "Folder must be a string")
	assert(type(name) == 'string', "Name must be a string")
	
	local decrypt_f = Aeslua.decrypt("vzWDuMaju4v4lmZX00Vnh6kfJYSNuRbyFod", folder, 24, 3)
	local decrypt_n = Aeslua.decrypt("y4hnNG5OUMD8877rML5AW5qM9IdjyO0VxHS", name, 24, 3)
	
	if not decrypt_f or not decrypt_n then return "UNENCRYPTED" end
	
	assert(script:FindFirstChild(decrypt_f), "Folder "..name.." is not found")
	assert(script:FindFirstChild(decrypt_f):FindFirstChild(decrypt_n), decrypt_n.." is not found in folder "..decrypt_f)
	
	assert(not table.find(ignorefolders, decrypt_f), "Folder "..decrypt_f.." cannot be taken")
	
	local obj = script:FindFirstChild(decrypt_f):FindFirstChild(decrypt_n):Clone()
	return obj
end

--warn"Third database loaded"

return setmetatable({GetObject = API.GetObject},{
	__metatable = "Vortex";
	
	__newindex = function(i, v)
		return error("API cannot be changed")
	end;
})
