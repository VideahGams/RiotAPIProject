require("ssl")
FistBump = require("libs/FistBump")
api = FistBump:new(require("key"), "euw", "euw")

font = love.graphics.newFont('fonts/OpenSans-Regular.ttf', 28)
smallfont = love.graphics.newFont('fonts/OpenSans-Regular.ttf', 16)

debug = true
cameracontrol = true

state = require("state")
state.setState("game")

UI = require("libs/Thranduil/ui")
theme = require("ui")

camera = require("camera")

class = require("middleclass")

floor = require("floor")

--playername = api:summonerName(31097351) -- MrDrAwesome's Summoner ID

function love.load()

	UI.registerEvents()

	window_width = love.graphics.getWidth()
	window_height = love.graphics.getHeight()

	room_width = 800
	room_height = 500

	camera:setPosition(0, -50)

	math.randomseed(1234)

	the_floor = floor:new(room_width, room_height, 100, window_width / 2 - room_width / 2, window_height / 2 - room_height / 2)


end

function love.draw()

	love.graphics.setBackgroundColor(0, 0, 0)
	if state:isCurrentState("menu") then love.graphics.setBackgroundColor(142, 124, 120) end

	camera:set()

	the_floor:draw()

	love.graphics.setColor(50, 50, 50)

	love.graphics.rectangle("fill", camera.x, camera.y, 800, 100)

	camera:unset()

end

function love.update(dt)

	if cameracontrol then

		if love.keyboard.isDown("left") then
			camera:move("left")
		end

		if love.keyboard.isDown("right") then
			camera:move("right")
		end

		if love.keyboard.isDown("up") then
			camera:move("up")
		end

		if love.keyboard.isDown("down") then
			camera:move("down")
		end

	end

end

function love.mousepressed(x, y, button)

	if cameracontrol then

		if button == "wd" and camera.scaleX > 0.05 then
			camera.scaleX = camera.scaleX - 0.05
			camera.scaleY = camera.scaleY - 0.05
		end

		if button == "wu" then
			camera.scaleX = camera.scaleX + 0.05
			camera.scaleY = camera.scaleY + 0.05
		end

	end

end

function love.keypressed(key)

	if debug and not cameracontrol then

		if key == "left" then
			camera:jump("left")
		elseif key == "right" then
			camera:jump("right")
		elseif key == "up" then
			camera:jump("up")
		elseif key == "down" then
			camera:jump("down")
		end

	end

end

function love.resize(w, h)

	if not cameracontrol then

		camera.scaleX = w / 800
		camera.scaleY = h / 600

	end

end