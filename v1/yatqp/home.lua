os.loadAPI("flex.lua")
os.loadAPI("dig.lua")

if fs.exists("quarry_home.txt") then
else
	shell.run("sethome.lua 0 0 0")
end 

local home = {}
local homefile = fs.open("quarry_home.txt","r")
home[1] = tonumber(homefile.readLine())
home[2] = tonumber(homefile.readLine())
home[3] = tonumber(homefile.readLine())
home[4] = 180
home[5] = "?"
homefile.close()
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


