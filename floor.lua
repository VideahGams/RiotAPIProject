Door = class("Door")

function Door:initialize(x, y, width, height, direction)

	self.x = x
	self.y = y

	self.w = 50
	self.h = 50

	self.direction = direction

end

function Door:draw()

	love.graphics.setColor(255, 255, 255)

	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

end

Room = class("Room")

function Room:initialize(x, y, w, h, xgrid, ygrid)

	self.x = x
	self.y = y
	self.w = w
	self.h = h

	self.xgrid = xgrid
	self.ygrid = ygrid

	self.walls = {}
	self.surrounded = false

	self.image = love.graphics.newImage("images/testbg.png")

	local r = math.random(1, 255)
	local g = math.random(1, 255)
	local b = math.random(1, 255)

	self.color = {r, g, b}

	print("Created room at: " .. self.x .. " " .. self.y)

end

function Room:draw()

	love.graphics.setColor(255, 255, 255)

	love.graphics.draw(self.image, self.x, self.y)

end

Floor = class("Floor")

function Floor:initialize(roomW, roomH, doorW, doorH, player, roomCount, initX, initY)

	self.roomW = roomW
	self.roomH = roomH

	self.doorW = doorW
	self.doorH = doorH

	self.player = player

	self.roomCount = roomCount
	self.initX = initX
	self.initY = initY

	self.grid = {}

	for i=-self.roomCount, self.roomCount do
		self.grid[i] = {}
	end

	self.rooms = {}
	self.doors = {}

	self.disableDoors = false

	self.padding = 110

	self:newRoom(0, 0)

	if roomCount > 1 then
		for i=2, roomCount do

			openroom = self:selectOpenRoom()

			newxgrid, newygrid = self:selectAdjacentSpot(openroom)

			self:newRoom(newxgrid, newygrid)

			self:checkForSurrounded()

		end
	end

	self:createDoors()

	print("Created floor.")

end

function Floor:countRoomsAround(roomIndex)

	local counter = 0

	room_xgrid = self.rooms[roomIndex].xgrid
	room_ygrid = self.rooms[roomIndex].ygrid

	if self.grid[room_xgrid + 1][room_ygrid] then
		counter = counter + 1
	end

	if self.grid[room_xgrid - 1][room_ygrid] then
		counter = counter + 1
	end

	if self.grid[room_xgrid][room_ygrid + 1] then
		counter = counter + 1
	end

	if self.grid[room_xgrid][room_ygrid - 1] then
		counter = counter + 1
	end

	return counter

end

function Floor:createDoors()

	for i=1, #self.rooms do

		roomX = self.rooms[i].x
		roomY = self.rooms[i].y

		room_xgrid = self.rooms[i].xgrid
		room_ygrid = self.rooms[i].ygrid

		if self.grid[room_xgrid + 1][room_ygrid] == "room" then
			self:newDoor(room_xgrid, room_ygrid, self.roomW - 50, (self.roomH / 2) - (self.doorH / 2), "right")
		end

		if self.grid[room_xgrid - 1][room_ygrid] == "room" then
			self:newDoor(room_xgrid, room_ygrid, 0, (self.roomH / 2) - (self.doorH / 2), "left")
		end

		if self.grid[room_xgrid][room_ygrid + 1] == "room" then
			self:newDoor(room_xgrid, room_ygrid, (self.roomW / 2) - (self.doorW / 2), self.roomH - 50, "down")
		end

		if self.grid[room_xgrid][room_ygrid - 1] == "room" then
			self:newDoor(room_xgrid, room_ygrid, (self.roomW / 2) - (self.doorW / 2), 0, "up")
		end

	end

end

function Floor:checkForSurrounded()

	for i=1, #self.rooms do
		if self:countRoomsAround(i) >= 3 and not self.rooms[i].surrounded then
			self:closeNode(i)
		end
	end
end

function Floor:closeNode(roomIndex)

	self.rooms[roomIndex].surrounded = true

	room_xgrid = self.rooms[roomIndex].xgrid
	room_ygrid = self.rooms[roomIndex].ygrid

	if not self.grid[room_xgrid - 1][room_ygrid] then
		self.grid[room_xgrid - 1][room_ygrid] = "block"
	end

	if not self.grid[room_xgrid + 1][room_ygrid] then
		self.grid[room_xgrid + 1][room_ygrid] = "block"
	end

	if not self.grid[room_xgrid][room_ygrid - 1] then
		self.grid[room_xgrid][room_ygrid - 1] = "block"
	end

	if not self.grid[room_xgrid][room_ygrid + 1] then
		self.grid[room_xgrid][room_ygrid + 1] = "block"
	end

end

function Floor:selectOpenRoom()

	local selected = false

	while not selected do
		randomRoom = math.random(1, #self.rooms)

		if not self.rooms[randomRoom].surrounded then
			selected = randomRoom
		end
	end

	return selected

end

function Floor:selectAdjacentSpot(roomIndex)

	local column = false
	local row = false

	room_xgrid = self.rooms[roomIndex].xgrid
	room_ygrid = self.rooms[roomIndex].ygrid

	while not column and not row do

		local randomAdjacent = math.random(1, 4)

		if randomAdjacent == 1 then
			if not self.grid[room_xgrid][room_ygrid - 1] then
				column = room_xgrid
				row = room_ygrid - 1
			end
		elseif randomAdjacent == 2 then
			if not self.grid[room_xgrid + 1][room_ygrid] then
				column = room_xgrid + 1
				row = room_ygrid
			end
		elseif randomAdjacent == 3 then
			if not self.grid[room_xgrid][room_ygrid + 1] then
				column = room_xgrid
				row = room_ygrid + 1
			end
		elseif randomAdjacent == 4 then
			if not self.grid[room_xgrid - 1][room_ygrid] then
				column = room_xgrid - 1
				row = room_ygrid
			end
		end

	end

	return column, row

end

function Floor:newRoom(xgrid, ygrid)

	thisRoomX = self.initX + (self.roomW + self.padding) * xgrid
	thisRoomY = self.initY + (self.roomH + self.padding) * ygrid

	self.grid[xgrid][ygrid] = 'room'
	table.insert(self.rooms, Room:new(thisRoomX, thisRoomY, self.roomW, self.roomH, xgrid, ygrid))

end

function Floor:newDoor(xgrid, ygrid, xoffset, yoffset, direction)

	xoffset = xoffset or 0
	yoffset = yoffset or 0

	thisRoomX = (self.initX + (self.roomW + self.padding) * xgrid) + xoffset
	thisRoomY = (self.initY + (self.roomH + self.padding) * ygrid) + yoffset

	table.insert(self.doors, Door:new(thisRoomX, thisRoomY, 50, 50, direction))

end

function Floor:draw()

	for i, room in ipairs(self.rooms) do
		room:draw()
	end

	for i, door in ipairs(self.doors) do
		door:draw()
	end

end

function Floor:update(dt)

	for i, door in ipairs(self.doors) do

		if self.player.x + (self.player.w / 2) > door.x and self.player.y + (self.player.h / 2) > door.y and self.player.x + (self.player.w / 2) < (door.x + door.w) and self.player.y + (self.player.h / 2) < (door.y + door.h) then
				
			if not self.disableDoors then

				if door.direction == "up" then
					self.player.y = self.player.y - 200
					self.disableDoors = true
					camera:jump("up")
				end

				if door.direction == "down" then
					self.player.y = self.player.y + 200
					self.disableDoors = true
					camera:jump("down")
				end

				if door.direction == "left" then
					self.player.x = self.player.x - 200
					self.disableDoors = true
					camera:jump("left")
				end

				if door.direction == "right" then
					self.player.x = self.player.x + 200
					self.disableDoors = true
					camera:jump("right")
				end

			end
		else
			self.disableDoors = false
		end
	end

end

return Floor