shell.run("delete flex.lua")
shell.run("delete dig.lua")
shell.run("delete home.lua")
shell.run("delete sethome.lua")
shell.run("delete help.lua")

-- shell.run("mkdir lib")
shell.run("wget https://raw.githubusercontent.com/chaos511/ccprograms/master/v1/home.lua home.lua")
shell.run("wget https://raw.githubusercontent.com/chaos511/ccprograms/master/v1/sethome.lua sethome.lua")
shell.run("wget https://raw.githubusercontent.com/chaos511/ccprograms/master/v1/flex.lua flex.lua")
shell.run("wget https://raw.githubusercontent.com/chaos511/ccprograms/master/v1/dig.lua dig.lua")
shell.run("wget https://raw.githubusercontent.com/chaos511/ccprograms/master/v1/help.lua help.lua")