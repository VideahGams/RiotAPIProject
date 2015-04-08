io.stdout:setvbuf("no") -- Prints to SublimeText's console

function love.conf(c)

	c.window.resizable = true
	c.window.minwidth = 800
	c.window.minheight = 600
	c.console = true

end