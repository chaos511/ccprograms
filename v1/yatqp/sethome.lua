os.loadAPI("flex.lua")
os.loadAPI("dig.lua")

if #args < 3 then
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