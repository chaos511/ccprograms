# Features
Auto Restart (when chunks get unloaded/loaded)

Return to home when needs refueling
  
Return to home and stops when detects unbreakable block (Bedrock)
  
Configurable home location (with sethome)

Suck fuel from chest adjacent to home (with setautofuel)

TODO: Auto attack entities when stuck(with setautoattack)

TODO: fill water and lava with a configurable block (with setautofill)


TODO: Auto drop blocks of specific type (with setautodrop)

 # Installation
To install or update use command: <br />
`wget run https://raw.githubusercontent.com/chaos511/ccprograms/master/update.lua`

 # Usage
 ## Start
 
 `yatqp start <x> [z] [depth]`
 
 ## Sethome
 Sets the position the turtle returns to to unload and refuel 
 the coordinates are relative to the position of the turtle
 
 `yatqp sethome <x> <y> <z>`
  
 ## Resume 
 Resume the quary with the last saved settings and positone (used for autostart)

 `yatqp resume`

 ## Setautofuel
 sets the side that the turtle will suck fuel from when at home and low on fuel
 
 `setautofuel <top,bottom,front,back,left,right,false>` 
 