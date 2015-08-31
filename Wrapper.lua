
--[[
	made by rayk999
	
	I redesigned my wrapper from scratch after I realized my
	older wrapper was trash
--]]

--Add custom properties/functions in this format
--Note: these are inherited, so the Kill function as show below
--will affect ALL roblox Instances. (since they all inherit from Instance)


local Custom = {
	["Instance"] = {
		["Kill"] = function(self)
			self:Destroy()
		end;
		["ClownLevel"] = 5
	}
}


--localizing
--why do i do this?
--Local variables are much faster than global variables
local type = type
local next = next
local error = error
local getmetatable = getmetatable
local getfenv = getfenv
local newproxy = newproxy
local pcall = pcall
local unpack = unpack

--Deciding to not make the functions local variables :(

function Wrap(obj) --roblox Instance or table
	local p = newproxy(true)
	local mt = getmetatable(p)
	
	if pcall(function() return obj:IsA("Instance") end) then
		mt.__index = function(t,k)
			if pcall(function() return obj[k] end) then
				if type(k) == "function" then
					return function(_,...)
						return WrapReturns(obj[k](obj,...))
					end
				elseif pcall(function() obj[k] = obj[k] end) then
					if pcall(function() obj[k]:IsA("Instance") end) then
						return Wrap(obj[k])
					else
						return obj[k]
					end
				end
			else
				
			end
		end
	end
end

function WrapReturns(...)
	local tab = {...}
	for i,v in next,tab do --should i use pairs? idk
		if pcall(function() return v:IsA("Instance") end) then
			tab[i] = Wrap(v)
		elseif type(v) == "table" then
			tab[i] = {WrapReturns(unpack(v))}
		end
	end
	return unpack(tab)
end
