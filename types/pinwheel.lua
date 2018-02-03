local pinwheel = {}
pinwheel.name = "Pinwheel Fractal"

local wd,ht

local limit = 4
local size = 300
local mode = true

local pinSet = {}

local function genFrac(step,ax,ay,bx,by,cx,cy)
    
    if step < limit then
        local i1x = ax + (cx-ax)/5 
        local i1y = ay + (cy-ay)/5
        local i2x = bx + (i1x-bx)/2
        local i2y = by + (i1y-by)/2
        local i3x = ax + 3*(cx-ax)/5
        local i3y = ay + 3*(cy-ay)/5
        local i4x = bx + (cx-bx)/2
        local i4y = by + (cy-by)/2
        
        if not mode then
            genFrac(step+1,i1x,i1y,i2x,i2y,i4x,i4y)
        end
        genFrac(step+1,ax,ay,i1x,i1y,bx,by)
        genFrac(step+1,i4x,i4y,i3x,i3y,i1x,i1y)
        genFrac(step+1,bx,by,i2x,i2y,i4x,i4y)
        genFrac(step+1,i4x,i4y,i3x,i3y,cx,cy)
    else
        table.insert(pinSet,{ax,ay,bx,by,cx,cy})
    end
    
end

function pinwheel.init()
    love.graphics.setColor(255,255,255)
    wd,ht = love.graphics.getDimensions()
    
    pinwheel.reset()
end

function pinwheel.reset()
    pinSet = {}
    collectgarbage()
    genFrac(0,wd/2-size,ht/2-size/2,wd/2-size,ht/2+size/2,wd/2+size,ht/2+size/2)
end

function pinwheel.draw()
    love.graphics.setFont(fonts.text)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("Press 'Q' to decrease and 'W' to\n increase the number of steps.\n\nPress 'A' to decrease and 'S' to\n increase the size of the initial triangle.\n\nPress SPACE to switch between\nthe outline or filled version.",0,10,wd-10,'right')
    
    if mode then
        love.graphics.setColor(255,255,255,150)
        for i,tri in pairs(pinSet) do
            love.graphics.polygon('fill',tri)
        end
    end
    for i,tri in pairs(pinSet) do
        love.graphics.polygon('line',tri)
    end
end

function pinwheel.keypressed(key)
    if key=='q' and limit > 0 then 
        limit = limit - 1
    elseif key=='w' then
        limit = limit + 1
    elseif key=='a' then
        size = size - 10
    elseif key=='s' then
        size = size + 10
    elseif key=='space' then
        mode = not mode
    end
    pinwheel.reset()
end

function pinwheel.resize(w,h)
    pinwheel.init()
end

function pinwheel.exit()
    pinSet = {}
    collectgarbage()
end

return pinwheel