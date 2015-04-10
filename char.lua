Char = class("Char")

function Char:initialize(x, y, width, height, speed, health)

	self.x = x
	self.y = y

	self.w = width
	self.h = height

	self.speed = speed or 100

end

function Char:setPosition(x, y)

	self.x = x
	self.y = y

end

function Char:move(direction, amount)

	amount = amount or self.speed

	dir = string.lower(direction)

	if dir == "left" then
		self.x = self.x - amount
	end

	if dir == "right" then
		self.x = self.x + amount
	end

	if dir == "up" then
		self.y = self.y - amount
	end

	if dir == "down" then
		self.y = self.y + amount
	end

end

return Char