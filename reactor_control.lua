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
while true do   
	local reactor = peripheral.find("BigReactors-Reactor")
	local monitor = peripheral.find("monitor")

	monitor.clear()  
	local energyStored=reactor.getEnergyStored()

	monitor.setCursorPos(1,1)
	monitor.setTextColor(colors.white)
	monitor.write("Active: ")
	  
	if reactor.getActive() then
		monitor.setTextColor(colors.green)
	else
		monitor.setTextColor(colors.red)
	end
	monitor.write(reactor.getActive())
	  
	  
	monitor.setCursorPos(1,2)
	monitor.setTextColor(colors.white)
	monitor.write("Energy Stored: ")
	monitor.setTextColor(colors.green)
	monitor.write(formatstr(energyStored))
	local energyPercent=math.floor(energyStored/100000)
	monitor.write("Rf ")
	monitor.write(energyPercent)
	monitor.write("%")

	
	local deltaes=energyStored-lastEnergyStored
	local deltatime=os.time()-lasttime
	monitor.setCursorPos(1,3)
	monitor.setTextColor(colors.white)
	monitor.write("Delta ES: ")
	monitor.setTextColor(colors.green)
	monitor.write(formatstr(deltaes/(deltatime*1000)))
	monitor.write("Rf/t ")
	
	
	controlRodLevel=math.max(0, math.min(100, controlRodLevel+ (energyPercent-50)/ki) +(deltaes/kd))
	if energyPercent <2 then
		controlRodLevel=0
	end
	if energyPercent > 98 then
		controlRodLevel=100
	end
	monitor.setCursorPos(1,4)
	monitor.setTextColor(colors.white)
	monitor.write("Producing: ")
	monitor.setTextColor(colors.green)
	monitor.write(formatstr(reactor.getEnergyProducedLastTick()))
	monitor.write("Rf/t ")
	monitor.write(math.floor((100-controlRodLevel)*100)/100)
	monitor.write("%")




	lastEnergyStored=energyStored
	lasttime=os.time()
	reactor.setAllControlRodLevels(math.floor(controlRodLevel))
	sleep(1)
  
end

