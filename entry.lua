local entry = {}

local textareax = (love.graphics.getWidth() / 2) - (556 / 2)
local textareay = (love.graphics.getHeight() / 2) - (50 / 2)

local textarea = UI.Textarea(textareax, textareay, 556, 50, {extensions = {theme.Textarea}, font = font, text_margin = 3, single_line = true})
local linkbutton = UI.Button("Don't have one?", smallfont, textarea.x, textarea.y + (smallfont:getHeight() + 10) + 30, smallfont:getWidth("Don't have one?") + 10, smallfont:getHeight() + 10, {extensions = {theme.Button}})
local submitbutton = UI.Button("Submit", smallfont, (textarea.x + textarea.w) - (smallfont:getWidth("Submit") + 10), textarea.y + (smallfont:getHeight() + 10) + 30, smallfont:getWidth("Submit") + 10, smallfont:getHeight() + 10, {extensions = {theme.Button}})

function entry.draw()

	love.graphics.setBackgroundColor(31, 37, 61)

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.setFont(font) 
	love.graphics.print("Please paste in your Riot Games API Key.", textarea.x, textarea.y - 50)

	textarea:draw()
	linkbutton:draw()
	submitbutton:draw()

end

function entry.update(dt)

	textarea:update(dt)
	submitbutton:update(dt)
	linkbutton:update(dt)

	if linkbutton.pressed then
		love.system.openURL("https://developer.riotgames.com")
	end

	if submitbutton.pressed and string.len(textarea.text.text) > 0 then
		api:setKey(textarea.text.text)
		c = api:ping()
		textarea:selectAll()
		textarea:delete()

		if tostring(c) == "200" then
			state.setState("game")
		end

	end

end

function entry.resize(w, h)

	textarea.x = (w / 2) - (556 / 2)
	textarea.y = (h / 2) - (50 / 2)
	textarea.text_x = textarea.x
	textarea.text_y = textarea.y

	linkbutton.x = textarea.x
	linkbutton.y = textarea.y + (smallfont:getHeight() + 10) + 30

	submitbutton.x = (textarea.x + textarea.w) - (smallfont:getWidth("Submit") + 10)
	submitbutton.y = textarea.y + (smallfont:getHeight() + 10) + 30


end

return entry