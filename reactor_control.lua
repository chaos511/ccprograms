-- https://pastebin.com/8VCPNu3a
-- made by chaos511

local controlRodLevel=100
local lastEnergyStored=0;
local ki=100
local kd=10000
local lasttime=0;
function formatstr(instr)
	if math.abs(tonumber(instr)) > 1000 then
		instr=instr/1000
		return tostring(math.floor(instr*100)/100).." k"
	else
		return tostring(math.floor(instr)).." "

	end
end

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

while true do   
	local reactor = peripheral.find("BigReactors-Reactor")
	local monitor = peripheral.find("monitor")

  
	local energyStored=reactor.getEnergyStored()
	
	controlRodLevel=math.max(0, math.min(100, controlRodLevel+ (energyPercent-50)/ki) +(deltaes/kd))
	if energyPercent <2 then
		controlRodLevel=0
	end
	if energyPercent > 98 then
		controlRodLevel=100
	end

	displayStatus("Active: ",reactor.getActive(),getcolor(reactor.getActive()),monitor,1,1)
	displayStatus("Energy Stored: ",formatstr(energyStored).."Rf "..energyPercent.."%",getcolor(energyPercent>0),monitor,1,2)
	displayStatus("Delta ES: ",formatstr(deltaes/(deltatime*1000)).."Rf/t",getcolor(deltaes>0),monitor,1,3)
	displayStatus("Producing: ",formatstr(reactor.getEnergyProducedLastTick()).."Rf/t "..math.floor((100-controlRodLevel)*100)/100.."%",colors.green,monitor,1,4)
	monitor.clear()
	updatedisplay(monitor)
	
	lastEnergyStored=energyStored
	lasttime=os.time()
	reactor.setAllControlRodLevels(math.floor(controlRodLevel))
	sleep(1)

  
end

