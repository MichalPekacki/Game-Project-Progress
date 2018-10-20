-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--VARIABLES--

local timeElapsed = os.clock()

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
local eventOn = false

local stage = 1


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

--RANDOM EVENTS--

--choice events--

local function randomEvent()
	math.randomseed(os.time())
	local r = math.random(1,3)
	
	eventOn = true
	
	if r == 1 then
		local eventText = display.newText( "how bad did you lose?", display.contentCenterX, display.contentCenterY, native.systemFont, 20 )
		local eventTextAns1 = display.newText( "bad", display.contentCenterX - 50, display.contentCenterY + 50, native.systemFont, 40 )
		local eventTextAns2 = display.newText( "baaad", display.contentCenterX + 50, display.contentCenterY + 50, native.systemFont, 40 )
		local function good()
			followers = followers - 10
			if followers < 0 then
				followers = 0
			end
			eventOn = false
			display.remove(eventText)
			display.remove(eventTextAns1)
			display.remove(eventTextAns2)
		end
		local function bad()
			followers = followers - 10
			if followers < 0 then
				followers = 0
			end
			eventOn = false
			display.remove(eventText)
			display.remove(eventTextAns1)
			display.remove(eventTextAns2)
		end
		eventTextAns1:addEventListener( "tap", good )
		eventTextAns2:addEventListener( "tap", bad )
	end
	
	if r == 2 then
		local eventText = display.newText( "winner!!!", display.contentCenterX, display.contentCenterY, native.systemFont, 40 )
		local function good()
			followers = followers * 1.25
			eventOn = false
			display.remove(eventText)
		end
		eventText:addEventListener( "tap", good )
	end
	
	if r == 3 then
		local eventText = display.newText( "loser!!!", display.contentCenterX, display.contentCenterY, native.systemFont, 40 )
		local function good()
			followers = followers * 0.8
			math.floor(followers)
			eventOn = false
			display.remove(eventText)
		end
		eventText:addEventListener( "tap", good )
	end
end

--timed events--



--FOLLOWERS PER CLICK--

local function incrFollowers()
	--multiplication for how much followers a user should gain per click
	if followers >= levelUp then
		fpc = fpc + fpcUp
		levelUp = levelUp * 2
		stage = stage + 1
		
		randomEvent()
	end
	
	if eventOn == false then
		followers = followers + (fpc * cprMultiplier)
	end
	
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
	if os.clock() - timeElapsed > 5 then --time (os.clock()) - time elapsed gives you time in seconds dunno why so... if time (sec) > 5
		if managerOn == true then
			followers = followers + managerFpc
		end
		timeElapsed = timeElapsed + 5 --every 5 seconds ^^^ add the 5 seconds gap which essentially resets the clock
	end
	followersText.text = math.floor(followers) --constantly updating the followers amount text, also round down in case of a decimal which can be encountered in event multiplications
    print(string.format("elapsed time: %.2f\n", os.clock() - timeElapsed)) --just in case i count the time for now
end

--FUNCTION CALLS--

background:addEventListener( "tap", incrFollowers )
computer:addEventListener( "tap", cprUpgrade)
manager:addEventListener( "tap", managerUpgrade)
Runtime:addEventListener("enterFrame", init)

--TO DO LIST--------------------------------------------------------------------------------------------------------------------

--COMPLETE

--tap to get followers ( all calculations included )
--upgrade computer
--managers (4 managers)( ( 5mil * 8 etc ) first at 5mil then 40mil then 320mil then 2,560mil ) ( 10,000 every 5/10 sec then * 10 so 100,000 then 1mil then 10 mil )

--INCOMPLETE

--choice event ( have multiple questions to ask, answers can be images of yes and no to make it more simple. for example the questions will be picked at random from a selection)
--timed event ( new timer, times fpc and fpcUP by 10, after timer is done divide fpc and fpcUP by 10)
--news feed
--upgrade locations and a system to change the graphics
--graphics
--customize

--taps per second score idea?
--(for 1 sec tap = t + 1. after 1 sec reset, if t > hs (highest score) then hs = t)