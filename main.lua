-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

--VARIABLES--

local timeElapsed = os.clock()
local eventTime = os.clock()

local followers = 0 --current followers
local fpc = 1 --how many followers are added every tap (followers per click)
local fpcUp = 1 --addded to fpc when entered next stage
local levelUp = 50 --amount at which user enters next stage
local cprMultiplier = 1 --a number fpc is multiplied by
local cprLevelUp = 200 --number at which cprMultipier is upgraded
local managerFpc = 1000 --amount of followers a manager adds
local managerLevelUp = 5000000 --number at which managerFpc is upgraded
local managerOn = false --determines whether managers are active
local managerNr = 0 --number of managers required for a limit
local timeEventOn = false --determines if timed event is on

local stage = 1 --stage count
local nrToEvent = 1 --counts when timed events should occur
local nrToChoiceEvent = 1 --counts when choice events should occur

--variables storing random number called in functions
local randomNumber
local eventRandomNumber

--IMAGES--

local backgroundImages = {"background.jpg", "stage2.jpg"}

local background = display.newImageRect( backgroundImages[1], display.actualContentWidth, display.actualContentHeight )
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
local levelUpText = display.newText( levelUp, display.contentCenterX, display.actualContentHeight -80, native.systemFont, 20 )
local fpcText = display.newText( fpc, 280, 100, native.systemFont, 20 )

local newsText = display.newText( "", display.contentCenterX, 230, native.systemFont, 20 )
newsText.anchorX = 0 --set text anchor point to the far left side of text
local randomNews = {"hello to the world of Follower Frenzy", "story nr 2", "story nr 3", "story nr 4"} --array containing all news text

local eventText = display.newText( "", display.contentCenterX, 280, native.systemFont, 22 )
local acceptButton = display.newText( "", 80, 320, native.systemFont, 21 )
local declineButton = display.newText( "", display.actualContentWidth - 80, 320, native.systemFont, 21 )
local eventAnswer = display.newText( "", display.contentCenterX, 300, native.systemFont, 22 )
local option1 = {"Invited to a tv show", "Featured in a magazine", "Mentioned by a celebrity"} --array containing all event option 1 text
local option2 = {"You were the life\nof the party", "You tried to act\ncool but it backfired",
 "You looked amazing\nand people are taking interest", "You were caught on\nyour bad day",
 "They appriciated your\nwork", "They think you will\nnever make it"} --array containing all event option 2 text

--EVENT OPTIONS--
local function eventOption1()
	eventAnswer.text = ""
	eventRandomNumber = math.random (1, 3)
	eventText.text = option1[eventRandomNumber]
	acceptButton.text = "accept"
	declineButton.text = "decline"
end

local function eventOption2()
	eventText.text = ""
	acceptButton.text = ""
	declineButton.text = ""
	
	if eventRandomNumber == 1 then
		eventRandomNumber = math.random (1, 2)
		eventAnswer.text = option2[eventRandomNumber]
		if eventRandomNumber == 1 then
			followers = followers * 1.3
		end
		if eventRandomNumber == 2 then
			followers = followers * 0.8
		end
		return true
	end
	
	if eventRandomNumber == 2 then
		eventRandomNumber = math.random (3, 4)
		eventAnswer.text = option2[eventRandomNumber]
		if eventRandomNumber == 3 then
			followers = followers * 1.1
		end
		if eventRandomNumber == 4 then
			followers = followers * 0.9
		end
		return true
	end
	
	if eventRandomNumber == 3 then
		eventRandomNumber = math.random (5, 6)
		eventAnswer.text = option2[eventRandomNumber]
		if eventRandomNumber == 5 then
			followers = followers * 1.2
		end
		if eventRandomNumber == 6 then
			followers = followers * 0.9
		end
		return true
	end
end

local function eventFinished()
	eventText.text = ""
	acceptButton.text = ""
	declineButton.text = ""
	eventAnswer.text = ""
end

--FOLLOWERS PER CLICK--

local function incrFollowers()
	--next stage upgrades and multiplications
	if followers >= levelUp then
		fpc = fpc + fpcUp --when the timed event is on this multiplier will assure the fpc stays the same when levelUp occurs
		levelUp = levelUp * 2
		stage = stage + 1
		nrToEvent = nrToEvent + 1
		nrToChoiceEvent = nrToChoiceEvent + 1
		background = display.newImageRect( backgroundImages[stage], display.actualContentWidth, display.actualContentHeight ) --change graphics
	end
	
--TIMED EVENT--
	if nrToEvent >= 5 then
		eventTime = os.clock()
		timeEventOn = true
		nrToEvent = 0
		fpc = fpc * 2
		fpcUp = fpcUp * 2
	end
	
--CHOICE EVENT--
	if nrToChoiceEvent >= 3 then
		eventOption1()
		nrToChoiceEvent = 0
	end
	
	followers = followers + (fpc * cprMultiplier) --multiplication for how much followers a user should gain per click
	
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

--also add grahpic when 
local function managerUpgrade()
	if managerNr < 4 then
		if followers >= managerLevelUp then
			timeElapsed = os.clock()
			managerFpc = managerFpc * 10
			managerLevelUp = managerLevelUp * 8
			managerNr = managerNr + 1 --max number of managers is 4 in this case
			managerOn = true
		end
	end
end

local function init()
--MANAGERS CLOCK--
	if managerOn == true then
		if os.clock() - timeElapsed > 2 then --os clock = current time, time elapsed captures current time so: os clock - time elapsed = 0, 1, 2... so on
			followers = followers + managerFpc
			timeElapsed = timeElapsed + 2 --every 2 seconds ^^^ add the 2 seconds gap which essentially resets the clock
		end
	end

--TIMED EVENT CLOCK--
	if timeEventOn == true then
		if os.clock() - eventTime > 10 then
			fpc = fpc / 2
			fpcUp = fpcUp / 2
			timeEventOn = false
		end
	end
	
--NEWS MOVEMENT AND UPDATE--
	newsText.x = newsText.x - 0.5 --move text to the left. speed depends on frames but does not affect gameplay
	if ( newsText.x + newsText.width ) <= 0 then --left side + the width of text = right side x point is less than 0
		randomNumber = math.random (1, 4) --pick random news text from the array specified earlier
		newsText.text = randomNews[randomNumber] --update text
		newsText.x = display.actualContentWidth --reset text position on the right side of screen
	end
	
	followersText.text = math.floor(followers) --constantly updating the followers amount text, also round down in case of a decimal
	--print(string.format("elapsed time: %.2f\n", os.clock() - eventTime)) --display counting time at console for testing purposes
	
end

--FUNCTION CALLS--

acceptButton:addEventListener( "tap", eventOption2 )
declineButton:addEventListener( "tap", eventFinished )
eventAnswer:addEventListener( "tap", eventFinished )

background:addEventListener( "tap", incrFollowers )
computer:addEventListener( "tap", cprUpgrade)
manager:addEventListener( "tap", managerUpgrade)
Runtime:addEventListener("enterFrame", init)

--TO DO LIST--------------------------------------------------------------------------------------------------------------------

--COMPLETE--

--tap to get followers ( all calculations included )
--upgrade computer
--managers(max 4 managers)( ( 5mil * 8 etc ) first at 5mil then 40mil then 320mil then 2,560mil ) ( 10,000 every 5/10 sec then * 10 so 100,000 then 1mil then 10 mil )
--timed event ( new timer, times fpc and fpcUP by 2, after timer is done divide fpc and fpcUP by 2) fpcUP is the amount that is added per click )
--news feed ( appear constantly, world related )
--choice event ( accept / decline )

--IN PROGRESS--

--upgrade locations and a system to change the graphics ( done at lvl up ) ( max 30 stages before max population )

--INCOMPLETE--

--automatically save game progress (stage and followers, when loading load the graphic corresponding to the stage)
--home screen, instructions screen
--graphics
--overall look and feedback of the game to the user ( testing )