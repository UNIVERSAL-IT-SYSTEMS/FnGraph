local lg = love.graphics
local insert = table.insert

local scale = {1, 1}       -- x/y axis scaling
local domain = {-100, 100} -- domain of graph to draw
local detail = 1           -- interval between x values
local offset = {0, 0}      -- x/y offset where are we viewing
local points = {}          -- points to draw

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

function love.load()
    getPoints(function(x) return 1/3*x*x*x + 3*x*x -5 end)
end

function love.draw()
    lg.translate(lg.getWidth()/2 + offset[1], lg.getHeight()/2 + offset[2])
    lg.line(points)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
