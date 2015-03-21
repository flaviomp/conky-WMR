--[[Countdown.lua by shamen456 (forum.ubuntu-fr.org)
calcul du temps restant (en jours, hr, min, sec) jusqu'a une certaine date a determiner par 'endday' ci-dessous
calculate remaining time untill a determined date (endday)

appeller les fonctions dans conky avec ${lua functionname} pour afficher les valeurs
call lua functions in conky with ${lua functionname}

functionname :
	today --- time code for actual time
	endday --- time code for end date of the countdown
	remain --- time code for the difference between today and endday
	startD --- start date in the form (dd mmm yyyy)
	endD --- end date in the form (dd mmm yyyy)
	totalD --- total amount of days between start and end
	remainD --- total remaining full days
	remainD1 --- total remaining days, included remaining hours of current day (=remainD+1)
	remainH --- remaining hours for current day
	remainM --- remaining minutes for current hour
	remainS --- remaining seconds for current minute
	elapsD --- elapsed days since start date
	percelapsD --- percentage elapsed
	percremainD --- percentage remaining
]]

require 'cairo'

function conky_countdown()
if conky_window == nil then return end
local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
cr = cairo_create(cs)
local updates=tonumber(conky_parse('${updates}'))


	local today=os.time()
	local startday=os.time()
	
	JSON = (loadfile "JSON.lua")()
	io.input(os.getenv("HOME").."/.cache/f1_next_race.json")
	race_info = JSON:decode(io.read("*all"))
	splittedDate=race_info["MRData"]["RaceTable"]["Races"][1]["date"]:split("-")
	splittedHour=race_info["MRData"]["RaceTable"]["Races"][1]["time"]:split(":")

	local endday=os.time{year=splittedDate[1], month=splittedDate[2], day=splittedDate[3], hour=splittedHour[1], min=splittedHour[2]}
	endday = endday + get_timezone()

	local totaltime=endday-startday
	local totaldays=math.floor(totaltime/86400)
	local elapsedtime=today-startday
	local remain=endday-today
	local heure=os.date("%H",today)
	local minute=os.date("%M",today)
	local elapseddays=math.floor(elapsedtime/86400)
	local remaining=endday-today
	local percelapsed=(elapsedtime*100)/totaltime
	local percremain=(remaining*100)/totaltime

if remain > 0 then

	
	 remdays=math.floor(remaining/86400)
	 remhours=math.floor((remaining-(remdays*86400))/3600)
	 remmin=math.floor((remaining-(remdays*86400)-(remhours*3600))/60)
	 remsec=remaining-(remdays*86400)-(remhours*3600)-(remmin*60)
else

	remaining=0	
	percelapsed =100
	percremain = 0
	remdays = 0
	remhours = 0
	remmin = 0
	remsec = 0
	
end

function conky_today()
	return today
end

function conky_endday()
	return endday
end

function conky_remain()
	return remain
end

function conky_startD()
	local startDay=os.date("%d %b %Y",startday)
	return startDay
end

function conky_endD()
	local endDay=os.date("%d %b %Y",endday)
	return endDay
end

function conky_totalD()
	return totaldays
end


function conky_remainD()
	return remdays-1
end

function conky_remainD1()
	return remdays
end

function conky_remainH()
	return remhours
end

function conky_remainM()
	return remmin
end

function conky_remainS()
	return remsec
end


function conky_elapsD()
	return elapseddays
end

function conky_percelapsD()
	return percelapsed
end

function conky_percremainD()
	return percremain
end

cairo_destroy(cr)
cairo_surface_destroy(cs)
cr=nil
end

function string:split(sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
end

function get_timezone()
  local now = os.time()
  return os.difftime(now, os.time(os.date("!*t", now)))
end

