local fn = function(x)
    return 1/3*(x*x*x) + 3*x*x - 5
end

local points = {}

for i=-250,250 do
    table.insert(points, i)
    table.insert(points, fn(i))
end

function love.draw()
    love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    love.graphics.line(points)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
