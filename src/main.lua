local lg = love.graphics
local insert = table.insert

local scale = {10, 10}       -- x/y axis scaling
local domain = {-10, 10} -- domain of graph to draw
local detail = 1/4           -- interval between x values
local offset = {0, 0}      -- x/y offset where are we viewing
local points = {}          -- points to draw
local miny = false         -- set to lowest y point
local maxy = false         -- set to highest y point

local fn = function(x)
    return 1/3*(x*x*x) + 3*x*x - 5
end

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

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
