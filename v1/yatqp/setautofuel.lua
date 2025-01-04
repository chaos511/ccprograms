local args = {...}
if #args < 1 then
    flex.send("Usage: setautofuel <top,bottom,front,back,left,right,false>",colors.lightBlue)
    return
end --if
local homefile = fs.open("quarry_settings.txt","w")
autofuel=args[1] or "false"
homefile.writeLine(autofuel)
homefile.close()

flex.send("Auto Fuel Set: "..autofuel)
return
