os.loadAPI("flex.lua")
os.loadAPI("dig.lua")

local args = {...}
if #args < 1 then
	flex.send("Usage: start sethome home",colors.lightBlue)
	return
end --if



local home = {}

local xmax = nil
local zmax = nil
local ymin = nil
local fuelLevel,requiredFuel,c,x,y,z,r,loc
local xdir,zdir  = 1, 1	

if fs.exists("quarry_home.txt") then
	local homefile = fs.open("quarry_home.txt","r")
	home[1] = tonumber(homefile.readLine())
	home[2] = tonumber(homefile.readLine())
	home[3] = tonumber(homefile.readLine())
	home[4] = 180
	home[5] = "?"
	homefile.close()

end --if

local function loadCoords()
	local file,loc,x
	quarryfile = fs.open("quarry_save.txt","r")
	dig.goto(tonumber(quarryfile.readLine()),tonumber(quarryfile.readLine()),tonumber(quarryfile.readLine()),tonumber(quarryfile.readLine()))
	
	xmax=tonumber(quarryfile.readLine())
	ymax=tonumber(quarryfile.readLine())
	zmax=tonumber(quarryfile.readLine())
	
	xdir=tonumber(quarryfile.readLine())
	zdir=tonumber(quarryfile.readLine())
	quarryfile.close()
end

local function saveCoords()
	quarryfile = fs.open("quarry_save.txt","w")
	quarryfile.writeLine(tostring(dig.getx()))
	quarryfile.writeLine(tostring(dig.gety()))
	quarryfile.writeLine(tostring(dig.getz()))
	quarryfile.writeLine(tostring(dig.getr()))
	
	quarryfile.writeLine(tostring(xmax))
	quarryfile.writeLine(tostring(ymax))
	quarryfile.writeLine(tostring(zmax))

	
	quarryfile.writeLine(tostring(xdir))
	quarryfile.writeLine(tostring(zdir))
	quarryfile.close()
end

if args[1] == "home" then
	flex.send("Home loaded: "
	..tostring(home[1])
	.." , "
	..tostring(home[2])
	.." , "
	..tostring(home[3])
	)
	if fs.exists("dig_save.txt") then
		dig.loadCoords()
	end
	dig.goto(home)
	return
elseif args[1] == "resume" then
	dig.loadCoords()
	flex.send("Home loaded: "
	..tostring(home[1])
	.." , "
	..tostring(home[2])
	.." , "
	..tostring(home[3])
	)
	if fs.exists("quarry_save.txt") then
		loadCoords()
	elseif 1==1 then
		flex.send("Unable to resume quarry",colors.red)
		return
	end
elseif args[1] == "sethome" then
	if #args < 4 then
		flex.send("Usage quarry sethome <x> <y> <z>",colors.lightBlue)
		return
	end --if
	home[1] = tonumber(args[2]) or 0
	home[2] = tonumber(args[3]) or 0
	home[3] = tonumber(args[4]) or 0
	local homefile = fs.open("quarry_home.txt","w")
	for x=1,#home do
		homefile.writeLine(tostring(home[x]))
	end --for
	homefile.close()

	flex.send("Home set: "
	..tostring(home[1])
	.." , "
	..tostring(home[2])
	.." , "
	..tostring(home[3])
	)
	return
elseif args[1] == "start" then
	xmax = tonumber(args[2])
	zmax = tonumber(args[3]) or xmax
	ymin = -(tonumber(args[4]) or 256)
	flex.send("Home loaded: "
	..tostring(home[1])
	.." , "
	..tostring(home[2])
	.." , "
	..tostring(home[3])
	)
else
	flex.send("Usage: start sethome home ",colors.lightBlue)
	return
end 

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


if fs.exists("startup.lua") and
	fs.exists("dig_save.txt") then
	dig.loadCoords()
end --if

dig.makeStartup("quarry resume",{})


local function dropNotFuel()
	flex.condense()
	local a,x
	a = false
	for x=1,16 do
		turtle.select(x)
		if turtle.refuel(0) then
			if a then turtle.drop() end
				a = true
			else --if
			turtle.drop()
		end --if
	end --for
turtle.select(1)
end --function


	local file,loc,x



--dig.gotox(0)
--dig.gotoz(0)
--dig.gotoy(dig.getYmin())
local done = false

while not done and not dig.isStuck() do
	fuelLevel = turtle.getFuelLevel()-1
	requiredFuel = math.abs(dig.getx())
	+ math.abs(dig.gety())
	+ math.abs(dig.getz())*2
	+ 200
   	c = true

	while fuelLevel <= requiredFuel and c do
		for x=1,16 do
			turtle.select(x)
			if turtle.refuel(1) then
				break
			end --if
			if x == 16 then
				c = false
			end --if
		end --for
		fuelLevel = turtle.getFuelLevel()-1
	end --while

	if fuelLevel <= requiredFuel then
		loc = dig.location()
		flex.send("Fuel low; returning to home",colors.yellow)
		dig.goto(home)
		dropNotFuel()
		flex.send("Waiting for fuel...",colors.orange)
		while turtle.getFuelLevel()-1 <= requiredFuel do
			for x=1,16 do
				turtle.select(x)
				if turtle.refuel(1) then break end
			end --for
		end --while
		flex.send("Refueled",colors.lime)
		dig.gotoy(loc[2])
		dig.goto(loc)
	end --if
	 
	turtle.select(1)
	if zdir == 1 then
		dig.gotor(0)
		while dig.getz() < zmax-1 do
			dig.fwd()
			if dig.isStuck() then
				done = true
				break
			end --if
		end --while
	elseif zdir == -1 then
		dig.gotor(180)
		while dig.getz() > 0 do
			dig.fwd()
			if dig.isStuck() then
				done = true
				break
			end --if
		end --while
	end --if/else
 
	if done then break end
 
	zdir = -zdir
 
	if dig.getx() == 0 and xdir == -1 then
		dig.down()
		xdir = 1
	elseif dig.getx() == xmax-1 and xdir == 1 then
		dig.down()
		xdir = -1
	else
		dig.gotox(dig.getx()+xdir)
	end --if/else
	saveCoords()
	
	if turtle.getItemCount(15) > 0 then
		loc = dig.location()
		flex.send("Inventory full; returning to home",colors.yellow)
		dig.goto(home)
		dropNotFuel()
		while turtle.getItemCount(15) > 0 do
			dropNotFuel()
		end --while
		flex.send("Emptied",colors.yellow)
		dig.gotoy(loc[2])
		dig.goto(loc)
	end --if
end --while


dig.goto(home)
for x=1,16 do
	turtle.select(x)
	turtle.drop()
end

turtle.select(1)
dig.gotor(0)

if fs.exists("startup.lua") then
	shell.run("rm startup.lua")
end
os.unloadAPI("dig.lua")
os.unloadAPI("flex.lua")
