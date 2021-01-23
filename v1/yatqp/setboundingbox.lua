os.loadAPI("flex.lua")
os.loadAPI("dig.lua")

local args = {...}
if #args < 3 then
    flex.send("Usage setboundingbox <x> <y> <z> <offsetx> <offsety>",colors.lightBlue)
    return
end --if


local xmax = nil
local zmax = nil
local ymin = nil
local xoffset = nil
local yoffset = nil
xmax = tonumber(args[1])
zmax = tonumber(args[2]) or xmax
ymin = -(tonumber(args[3]) or 256)
xoffset=tonumber(args[4]) or 0
yoffset=tonumber(args[5]) or 0

if xmax == nil or zmax == nil then
	flex.send("Invalid dimensions: "
	..tostring(xmax)
	.." , "
	..tostring(ymax)
	.." , "
	..tostring(zmax)
	,colors.red)
	return
end

quarryfile = fs.open("quarry_save.txt","w")
quarryfile.writeLine(tostring(dig.getx()))
quarryfile.writeLine(tostring(dig.gety()))
quarryfile.writeLine(tostring(dig.getz()))
quarryfile.writeLine(tostring(dig.getr()))

quarryfile.writeLine(tostring(xmax))
quarryfile.writeLine(tostring(ymax))
quarryfile.writeLine(tostring(zmax))


quarryfile.writeLine(tostring(1))
quarryfile.writeLine(tostring(1))
quarryfile.close()