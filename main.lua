-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--VARIABLES--

local timeElapsed = os.clock()
local eventTime = os.clock()

local followers = 0
local fpc = 1
local fpcUp = 1
local levelUp = 50
local cprMultiplier = 1
local cprLevelUp = 200
local managerFpc = 1000
local managerLevelUp = 5000000
local managerOn = false
local managerNr = 0
local timeEventOn = false

local stage = 1
local nrToEvent = 1


--IMAGES--

local background = display.newImageRect( "background.jpg", display.contentCenterX * 2, display.contentCenterY * 2 )
background.x = display.contentCenterX
background.y = display.contentCenterY

local computer = display.newImageRect( "computerButton.jpg", 40, 40)
computer.x = 20
computer.y = 50

local manager = display.newImageRect( "computerButton.jpg", 40, 40)
manager.x = 20
manager.y = 100

--TEXT--

local followersText = display.newText( followers, display.contentCenterX, 50, native.systemFont, 40 )
local stageText = display.newText( string.format("Stage: %.f\n", stage), display.contentCenterX, 20, native.systemFont, 20 )
local levelUpText = display.newText( levelUp, display.contentCenterX, display.contentCenterY *2 -20, native.systemFont, 20 )
local fpcText = display.newText( fpc, 280, 100, native.systemFont, 20 )

--FOLLOWERS PER CLICK--

local function incrFollowers()
	--multiplication for how much followers a user should gain per click
	if followers >= levelUp then
		fpc = fpc + fpcUp --when the timed event is on this multiplier will assure the fpc stays the same when levelUp occurs
		levelUp = levelUp * 2
		stage = stage + 1
		nrToEvent = nrToEvent + 1
		
	end
	
--TIMED EVENT--
	if nrToEvent >= 5 then
		eventTime = os.clock()
		timeEventOn = true
		nrToEvent = 0
		fpc = fpc * 2
		fpcUp = fpcUp * 2
	end
	
	followers = followers + (fpc * cprMultiplier)
	
	levelUpText.text = levelUp --text update of next stage. this is temporal, we could have a progress bar for lvl up and just display stage number
	fpcText.text = fpc * cprMultiplier --this text could be appearing above or next to the character every time the user taps (then disappears) to show how much they've gained
	stageText.text = string.format("Stage: %.f\n", stage) --stage number
end

--COMPUTER UPGRADE--

local function cprUpgrade()
	if followers >= cprLevelUp then
		cprMultiplier = cprMultiplier * 2
		cprLevelUp = cprLevelUp * 4
	end
end

--MANAGERS--

--what can be done is add a graphic when unlocked
--if the graphic is a number and not called here we could have multiple graphics for when the manager is upgraded and increment the graphic number
local function managerUpgrade()
	if managerNr < 4 then
		if followers >= managerLevelUp then
			managerFpc = managerFpc * 10
			managerLevelUp = managerLevelUp * 8
			managerNr = managerNr + 1 --max number of managers is 4 in this case
			managerOn = true
		end
	end
end

local function init()
	if os.clock() - timeElapsed > 2 then --os clock = current time, time elapsed captures current time so: os clock - time elapsed = 0, 1, 2... so on
		if managerOn == true then
			followers = followers + managerFpc
		end
		timeElapsed = timeElapsed + 2 --every 5 seconds ^^^ add the 5 seconds gap which essentially resets the clock
	end
	followersText.text = math.floor(followers) --constantly updating the followers amount text, also round down in case of a decimal which can be encountered in event multiplications
    print(string.format("elapsed time: %.2f\n", os.clock() - eventTime)) --display counting time at console for testing purposes
	
	if timeEventOn == true then
		if os.clock() - eventTime > 10 then
			fpc = fpc / 2
			fpcUp = fpcUp / 2
			timeEventOn = false
		end
	end
end

--FUNCTION CALLS--

background:addEventListener( "tap", incrFollowers )
computer:addEventListener( "tap", cprUpgrade)
manager:addEventListener( "tap", managerUpgrade)
Runtime:addEventListener("enterFrame", init)

--TO DO LIST--------------------------------------------------------------------------------------------------------------------

--COMPLETE--

--tap to get followers ( all calculations included )
--upgrade computer
--managers (4 managers)( ( 5mil * 8 etc ) first at 5mil then 40mil then 320mil then 2,560mil ) ( 10,000 every 5/10 sec then * 10 so 100,000 then 1mil then 10 mil )
--timed event ( new timer, times fpc and fpcUP by 5, after timer is done divide fpc and fpcUP by 5) fpcUP is the amount that is added per click )

--INCOMPLETE--

--choice event ( have multiple questions to ask, answers can be images of yes and no to make it more simple. for example the questions will be picked at random from a selection )
--news feed
--upgrade locations and a system to change the graphics
--graphics
--customize

--taps per second score idea?
--(for 1 sec tap = t + 1. after 1 sec reset, if t > hs (highest score) then hs = t)