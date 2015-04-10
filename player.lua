Char = require("char")

Player = class("Player", Char)

function Player:initialize(x, y, width, height, speed)

	Char.initialize(self, x, y, width, height, speed)

	print("Created Player.")

end

function Player:draw()

	love.graphics.setColor(255, 155, 255)

	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

end

function Player:update(dt)

	if love.keyboard.isDown("a") then
		self:move("left", self.speed * dt)
	end

	if love.keyboard.isDown("d") then
		self:move("right", self.speed * dt)
	end

	if love.keyboard.isDown("w") then
		self:move("up", self.speed * dt)
	end

	if love.keyboard.isDown("s") then
		self:move("down", self.speed * dt)
	end

end

return Player