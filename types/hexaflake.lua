local hexaflake = {}
hexaflake.name = "Hexaflake"

local wd,ht

local limit = 4
local size = 250
local central = true

local an = math.pi/3
local sin60 = math.sqrt(3)/2
local cos60 = 1/2
local tan60 = math.sqrt(3)

local hexaSet = {}

local function genHexa(step,length,cx,cy)
    local newcx,newcy
    if not hexaSet[step] then hexaSet[step] = {} end
    for c=1,6 do
        newcx = (math.cos(an*c-math.pi/2) * (2*length)) + cx
        newcy = (math.sin(an*c-math.pi/2) * (2*length)) + cy
        table.insert(hexaSet[step],{})
        for i=1,6 do
            table.insert(hexaSet[step][#hexaSet[step]],(math.cos(an*i-math.pi/2) * length) + newcx)
            table.insert(hexaSet[step][#hexaSet[step]],(math.sin(an*i-math.pi/2) * length) + newcy)
        end
        if step < limit then
            genHexa(step+1,length/3,newcx,newcy)
        end
    end
    
    if central then
        table.insert(hexaSet[step],{})
        for i=1,6 do
            table.insert(hexaSet[step][#hexaSet[step]],(math.cos(an*i+math.pi/2) * length) + cx)
            table.insert(hexaSet[step][#hexaSet[step]],(math.sin(an*i+math.pi/2) * length) + cy)
        end
        if step < limit then
            genHexa(step+1,length/3,cx,cy)
        end
    end
end

function hexaflake.init()
    love.graphics.setColor(255,255,255)
    wd,ht = love.graphics.getDimensions()
    
    hexaflake.reset()
end

function hexaflake.reset()
    local cx,cy = wd/2,ht/2
    hexaSet = {}
    hexaSet[0] = {{}}
    
    for i=1,6 do
        table.insert(hexaSet[0][1],(math.cos(an*i-math.pi/2) * size) + cx)
        table.insert(hexaSet[0][1],(math.sin(an*i-math.pi/2) * size) + cy)
    end
    genHexa(1,size/3,cx,cy)
end

function hexaflake.draw()
    love.graphics.setFont(fonts.text)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("Press 'Q' to decrease and 'W' to\n increase the number of steps.\n\nPress 'A' to decrease and 'S' to\n increase the size of the initial hexagon.\n\nPress SPACE to show or hide\nthe central hexagons.",0,10,wd-10,'right')
    
    for i,penta in ipairs(hexaSet[limit]) do
        love.graphics.polygon('fill',penta)
    end
    
end

function hexaflake.keypressed(key)
    if key=='q' and limit > 0 then 
        limit = limit - 1
    elseif key=='w' then
        limit = limit + 1
    elseif key=='a' then
        size = size - 10
    elseif key=='s' then
        size = size + 10
    elseif key=='space' then
        central = not central
    end
    hexaflake.reset()
end

function hexaflake.resize(w,h)
    hexaflake.init()
end

function hexaflake.exit()
    hexaSet = {}
    collectgarbage()
end

return hexaflake