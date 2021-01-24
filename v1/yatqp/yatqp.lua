os.loadAPI("flex.lua")
os.loadAPI("dig.lua")

local args = {...}
if #args < 1 then
	flex.send("Usage: start sethome home",colors.lightBlue)
	return
end --if



local home = {}
local autofuel= "false"
local xmax = nil
local zmax = nil
local ymin = nil
local xoffset=0
local zoffset=0
local fuelLevel,requiredFuel,c,x,y,z,r,loc
local xdir,zdir  = 1, 1	

if fs.exists("quarry_home.txt") then
elseif 1==1 then
shell.run("sethome 0 0 0")
end
if fs.exists("quarry_settings.txt") then
	local settings = fs.open("quarry_settings.txt","r")
	autofuel = tonumber(homefile.readLine())
	flex.send(autofuel)
	flex.send(autofuel=="up")
	homefile.close()
end

	local homefile = fs.open("quarry_home.txt","r")
	home[1] = tonumber(homefile.readLine())
	home[2] = tonumber(homefile.readLine())
	home[3] = tonumber(homefile.readLine())
	home[4] = 180
	home[5] = "?"
	homefile.close()

local function loadCoords()
	local file,loc,x
	if fs.exists("quarry_offset.txt") then
		offsetfile = fs.open("quarry_offset.txt","r")
		xoffset=tonumber(offsetfile.readLine())
		zoffset=tonumber(offsetfile.readLine())
	end
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

if args[1] == "resume" then				--resume
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
elseif args[1] == "start" then
	if fs.exists("quarry_save.txt") then
	elseif 1==1 then
		os.shell("setboundingbox 10 10")
	end
	loadCoords()
	flex.send("Home loaded: "
	..tostring(home[1])
	.." , "
	..tostring(home[2])
	.." , "
	..tostring(home[3])
	)
else
	flex.send("Usage: start",colors.lightBlue)
	return
end 




if fs.exists("startup.lua") and
	fs.exists("dig_save.txt") then
	dig.loadCoords()
end --if

dig.makeStartup("yatqp resume",{})


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

	if fuelLevel <= requiredFuel then			-- refuel
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

			local rotate = nil
			if autofuel == "front" then rotate=180 end
			if autofuel == "back"  then rotate=0   end
			if autofuel == "left"  then rotate=90  end
			if autofuel == "right" then rotate=270 end
			if autofuel == "up"    then rotate=180 end
			if autofuel == "down"  then rotate=180 end

			if rotate ~= nil then
				dig.gotor(rotate)
				for x=1,16 do
					turtle.select(x)
					if turtle.getItemCount(x)==0 then
					
						local suck
						if autofuel == "up"    then     suck=turtle.suckUp(64)
						elseif autofuel == "down"  then suck=turtle.suckDown(64) 
						else
							suck=turtle.suck(64)
						end
						
						if suck==true then break end
						
					end
				end

			end
			
		end --while
		flex.send("Refueled",colors.lime)
		dig.gotoy(loc[2])
		dig.goto(loc)
	end 												--end refuel
	 
	turtle.select(1)
	if zdir == 1 then
		dig.gotor(0)
		while dig.getz()-zoffset < zmax-1 do
			dig.fwd()
			if dig.isStuck() then
				done = true
				break
			end --if
		end --while
	elseif zdir == -1 then
		dig.gotor(180)
		while dig.getz()-zoffset > 0 do
			dig.fwd()
			if dig.isStuck() then
				done = true
				break
			end --if
		end --while
	end --if/else
 
	if done then break end
 
	zdir = -zdir
 
	if dig.getx()-xoffset == 0 and xdir == -1 then
		dig.down()
		xdir = 1
	elseif dig.getx()-xoffset == xmax-1 and xdir == 1 then
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
