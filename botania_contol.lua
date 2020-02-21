-- https://pastebin.com/MdB3MCiY
-- made by chaos511
local outputmode="clock"
local clockTime=15
local outputs = {
	jadedamaranthus = {
		displayname = "Jaded Amaranthus",
		drops = {
			{displayname = "White",id = "Botania:flower",threshold = 64,dmg = 0},
			{displayname = "Orange",id = "Botania:flower",threshold = 64,dmg = 1},
			{displayname = "Magenta",id = "Botania:flower",threshold = 64,dmg = 2},
			{displayname = "Light Blue",id = "Botania:flower",threshold = 64,dmg = 3},
			{displayname = "Yellow",id = "Botania:flower",threshold = 64,dmg = 4},
			{displayname = "Lime",id = "Botania:flower",threshold = 64,dmg = 5},
			{displayname = "Pink",id = "Botania:flower",threshold = 64,dmg = 6},
			{displayname = "Gray",id = "Botania:flower",threshold = 64,dmg = 7},
			{displayname = "Light Gray",id = "Botania:flower",threshold = 64,dmg = 8},
			{displayname = "Cyan",id = "Botania:flower",threshold = 64,dmg = 9},
			{displayname = "Purple",id = "Botania:flower",threshold = 64,dmg = 10},
			{displayname = "Blue",id = "Botania:flower",threshold = 64,dmg = 11},
			{displayname = "Brown",id = "Botania:flower",threshold = 64,dmg = 12},
			{displayname = "Green",id = "Botania:flower",threshold = 64,dmg = 13},
			{displayname = "Red",id = "Botania:flower",threshold = 64,dmg = 14},
			{displayname = "Black",id = "Botania:flower",threshold = 64,dmg = 15},

		},
		bundledcablecolor=colors.yellow,
	}
}

function getcolor(inboolean)
	if inboolean then
		return colors.green
	else
		return colors.red
	end
end
displayList={{},{}}
displayListIndex=1;
function displayStatus(name,value,color,mon,x,y)
	displayList[displayListIndex]={
		x1=x,
		y1=y,
		color1=colors.white,
		write1=name,
		color2=color,
		write2=value
	}
	displayListIndex=displayListIndex+1
end

function updatedisplay(mon)
	for index, data in ipairs(displayList) do
		mon.setCursorPos(data.x1,data.y1)
		mon.setTextColor(data.color1)
		mon.write(data.write1)
		mon.setTextColor(data.color2)
		mon.write(data.write2)
	end
	displayListIndex=1;
end
outputState=false
clockCount=0

while true do   
	local me = peripheral.wrap("right")
	local monitor = peripheral.find("monitor")
	spawnerstates={}
	local bcoutput=0
	if me ~= nil then
		line=0
		for spawnername, spawner in pairs(outputs) do
			spawnerstates[spawnername]=false
			line=line+1
			monitor.setTextColor(colors.white)
			for itemindex, data in ipairs(spawner.drops) do
				itemstack=me.getItemDetail({id =data.id,dmg=data.dmg})
				if itemstack ~= nil then
					if itemstack.all().qty < data.threshold then
						spawnerstates[spawnername]=true
					end
					
				else
				end				
			end
			
			displayStatus(spawner.displayname..": ",spawnerstates[spawnername],getcolor(spawnerstates[spawnername]),monitor,1,line)
			line=line+1
			for itemindex, data in ipairs(spawner.drops) do
				itemstack=me.getItemDetail({id =data.id,dmg=data.dmg})
				if itemstack ~= nil then
					displayStatus(data.displayname..": ",itemstack.all().qty,getcolor(itemstack.all().qty>=data.threshold),monitor,1,line)
				else
					displayStatus(data.displayname.." :",-1,getcolor(false),monitor,1,line)
				end		
				line=line+1
			end
			if spawnerstates[spawnername] then
				bcoutput=bcoutput+spawner.bundledcablecolor
			end
		end
			displayStatus("Time: ",(os.time() * 1000 + 18000)%24000,colors.red,monitor,1,line+1)	
	else
		monitor.clear()
		displayStatus("me interface: ","nil",colors.red,monitor,1,1)	
	end
	if outputmode == "clock"  then
		if clockCount>=clockTime then
			clockCount=0
			if outputState then
				redstone.setBundledOutput("left",bcoutput)
				outputState=false
			else
				redstone.setBundledOutput("left",0)
				outputState=true
			end
		end
		clockCount=clockCount+1
	end
  
	if outputmode=="continuous" then
		redstone.setBundledOutput("left",bcoutput)
	end
	monitor.clear()
	updatedisplay(monitor)
	sleep(1)
end