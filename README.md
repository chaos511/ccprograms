# Features
Auto Restart (when chunks get unloaded/loaded)

Return to home when needs refueling
  
Return to home and stops when detects unbreakable block (Bedrock)
  
Configurable home location (with sethome)

TODO: Auto attack entities when stuck(with setautoattack)

TODO: fill water and lava with a configurable block (with setautofill)

TODO: Suck fuel from chest adjacent to home (with setautofuel)

TODO: Auto drop blocks of specific type (with setautodrop)

 # Installation
To install or update use command:
`wget run https://raw.githubusercontent.com/chaos511/ccprograms/master/update.lua`

 # Usage
 ## Start the quarry program
  `yatqp start <x> [z] [depth]`
 ## Set home for refuling and unloading
 `yatqp sethome <x> <y> <z>`
  coordinates are relative to the position of the turtle
 ## Resume if terminated
 `yatqp resume`

