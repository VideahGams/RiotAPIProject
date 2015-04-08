local camera = {}

camera.x = 0
camera.y = 0
camera.angle = 0

camera.scaleX = 1
camera.scaleY = 1

camera.strict = true

camera.shakeX = 0
camera.shakeY = 0
camera.shaking = false
camera.shakeIntensity = 10
camera.shakeDuration = nil

local function round(what, precision)
   return math.floor(what*math.pow(10,precision)+0.5) / math.pow(10,precision)
end

function camera:set()

	local finalx = -self.x + -self.shakeX
	local finaly = -self.y + -self.shakeY

	if self.strict then
		finalx = math.floor(finalx)
		finaly = math.floor(finaly)
	end


	love.graphics.push()
	love.graphics.scale(round(self.scaleX, 2), round(self.scaleY, 2))
	love.graphics.translate(finalx, finaly)
	love.graphics.rotate(-self.angle)

end

function camera:unset()

	love.graphics.pop()

end

-- Positioning --

function camera:jump(direction)

	if direction == "left" then
		camera.x = camera.x - 910
	elseif direction == "right" then
		camera.x = camera.x + 910
	elseif direction == "up" then
		camera.y = camera.y - 610
	elseif direction == "down" then
		camera.y = camera.y + 610
	end

end

function camera:setPosition(x, y)

	self.x, self.y = x, y

end

function camera:move(direction, amount)

	amount = amount or 5

	local dir = string.lower(direction)

	if dir == "up" then
		self.y = self.y - amount
	elseif dir == "down" then
		self.y = self.y + amount
	elseif dir == "left" then
		self.x = self.x - amount
	elseif dir == "right" then
		self.x = self.x + amount
	end

end

function camera:getPosition()

	local finalx = -self.x + -self.shakeX
	local finaly = -self.y + -self.shakeY

	if self.strict then
		finalx = math.floor(finalx)
		finaly = math.floor(finaly)
	end

	return finalx, finaly
end

function camera:getX()

	local finalx = -self.x + -self.shakeX

	if self.strict then
		finalx = math.floor(finalx)
	end

	return finalx
end

function camera:getY()

	local finaly = -self.y + -self.shakeY

	if self.strict then
		finaly = math.floor(finaly)
	end
	
	return finaly
end

function camera:getScale()
	return self.scale
end

function camera:getMousePosition()
	return math.floor(_G.cursorx + self.x), math.floor(_G.cursory + self.y)
end

function camera:getMouseX()
	return math.floor(_G.cursorx + self.x)
end

function camera:getMouseY()
	return math.floor(_G.cursory + self.y)
end

-- Camera Shake --

function camera:shake(intesity, duration)

	self.shaking = true
	self.shakeIntensity = intesity or 10
	self.shakeDuration = duration or nil

end

function camera.update(dt)

	if camera.shaking then

		local shakeoffsetx = math.random(-camera.shakeIntensity, camera.shakeIntensity)
		local shakeoffsety = math.random(-camera.shakeIntensity, camera.shakeIntensity)

		camera.shakeX, camera.shakeY = camera:getPosition()

		camera.shakeX = camera.shakeX + shakeoffsetx
		camera.shakeY = camera.shakeY + shakeoffsety

		if camera.shakeDuration ~= nil then
			camera.shakeIntensity = camera.shakeIntensity - (1 / (camera.shakeDuration * 10))

			if camera.shakeIntensity <= 0 then
				camera.shakeDuration = nil
				camera.shaking = false
			end
		end
	else

		camera.shakeX, camera.shakeY = 0, 0

	end

end

return camera