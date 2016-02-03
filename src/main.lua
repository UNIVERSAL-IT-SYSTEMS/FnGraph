function love.run()
	if love.math then
		love.math.setRandomSeed(os.time())
	end

	if love.load then love.load(arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update.
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end

		-- Call update.
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

        --[[
		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end
        --]]

		if love.timer then love.timer.sleep(0.001) end
	end
end

local insert = table.insert
local abs = math.abs
local function getPoints(fn, info)
    local points = {}

    if not info then
        info = {
            domain = {-100, 100},
            detail = 1
        }
    end

    local function loop(from, to, iteration)
        local hold = false
        for x=from, to, iteration do
            local y = fn(x)
            if hold and (abs(hold - y) > 1) and (iteration > 0.0001) then
                loop(x-1, x, iteration/10)
            else
                hold = y
                insert(points, x)
                insert(points, y)
            end
        end
    end

    loop(info.domain[1], info.domain[2], info.detail)

    return points
end

function love.load()
    local fn

    --fn = function(x) return 1/3*x*x*x + 5*x*x + x - 14 end
    fn = function(x) return 1/(x+4) end

    local points = getPoints(fn)

    for i=1, #points do
        if (points[i] == math.huge) or (points[i] == -math.huge) then
            points[i] = 0
        end
    end

    draw(points)
end

local function draw(points)
    if love.graphics and love.graphics.isActive() then
        love.graphics.clear(love.graphics.getBackgroundColor())
        love.graphics.origin()

        --TODO stuff
        lg.translate(lg.getWidth()/2, lg.getHeight()/2)
        lg.line(points)

        love.graphics.present()
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end








--[[
local lg = love.graphics
local insert = table.insert

local domain = {-100, 100} -- domain of current graph




-- where
local domain = {-100, 100} -- domain of graph to draw
local detail = 1           -- interval between x values (I want to make this redundant)

-- view
local scale = {10, 10}     -- x/y axis scaling
local offset = {0, 0}      -- x/y offset where are we viewing

-- data
local points = {}          -- points to draw
local miny = false         -- set to lowest y point
local maxy = false         -- set to highest y point

local fn = function(x)
    return 1/3*(x*x*x) + 3*x*x - 5
end

local function

local function getPoints()
    points = {}
    for x = domain[1], domain[2], detail do
        insert(points, x * scale[1])
        insert(points, -fn(x) * scale[2])
    end
end

local function getMinMaxY()
    for i=1, #points do
        if (not miny) or (miny > points[i]) then
            miny = points[i]
        end
        if (not maxy) or (maxy < points[i]) then
            maxy = points[i]
        end
    end
end

local function removeInfinites()
    for i=1, #points do
        if (points[i] == math.huge) or (points[i] == -math.huge) then
            points[i] = 0
        end
    end
end

function love.load()
    --fn = function(x) return x*x end
    fn = function(x) return 1/(x+4) end --NOTE breaks detail!

    getPoints(fn)
    removeInfinites() -- if this isn't done BEFORE min/max, min/max will be infinite too!
    getMinMaxY()
end

function love.draw()
    lg.translate(lg.getWidth()/2 + offset[1], lg.getHeight()/2 + offset[2])

    lg.setColor(50, 50, 50, 255)

    lg.line(-lg.getWidth()/2 - offset[1], -offset[2], lg.getWidth()/2 - offset[1], -offset[2])
    lg.line(-offset[1], -lg.getHeight()/2 - offset[2], -offset[1], lg.getHeight()/2 - offset[2])

    lg.setColor(100, 100, 100, 255)

    --NOTE 50 is distance between each, arbitrary
    for x=domain[1], domain[2], 40 do
        lg.print(x, x, 0)
    end

    --NOTE again, 50 is arbitrary
    for y=math.floor(miny), maxy, 40 do
        lg.print(y, 0, y)
    end

    lg.setColor(255, 255, 255, 255)
    lg.line(points)
end
--]]
