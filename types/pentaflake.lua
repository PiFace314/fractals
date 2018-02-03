local pentaflake = {}
pentaflake.name = "Pentaflake"

local wd,ht

local limit = 5
local size = 300
local central = true

local ratio = (math.sqrt(5) + 1)/2 + 1
local an = math.rad(72)
local tan36 = math.sqrt(10-2*math.sqrt(5))/(math.sqrt(5)+1)
local sin36 = math.sqrt(10-2*math.sqrt(5))/4

local pentaSet = {}

local function genPenta(step,length,cx,cy,adj)
    local newcx,newcy
    if not pentaSet[step] then pentaSet[step] = {} end
    for c=1,5 do
        newcx = (math.cos(an*c-math.pi/2+adj) * (length/tan36)) + cx
        newcy = (math.sin(an*c-math.pi/2+adj) * (length/tan36)) + cy
        table.insert(pentaSet[step],{})
        for i=1,5 do
            table.insert(pentaSet[step][#pentaSet[step]],(math.cos(an*i-math.pi/2+adj) * length/(2*sin36)) + newcx)
            table.insert(pentaSet[step][#pentaSet[step]],(math.sin(an*i-math.pi/2+adj) * length/(2*sin36)) + newcy)
        end
        if step < limit then
            genPenta(step+1,length/ratio,newcx,newcy,adj)
        end
    end
    
    if central then
        table.insert(pentaSet[step],{})
        for i=1,5 do
            table.insert(pentaSet[step][#pentaSet[step]],(math.cos(an*i+math.pi/2+adj) * length/(2*sin36)) + cx)
            table.insert(pentaSet[step][#pentaSet[step]],(math.sin(an*i+math.pi/2+adj) * length/(2*sin36)) + cy)
        end
        if step < limit then
            genPenta(step+1,length/ratio,cx,cy,adj+math.pi)
        end
    end
end

function pentaflake.init()
    love.graphics.setColor(255,255,255)
    love.graphics.setLineWidth(1)
    wd,ht = love.graphics.getDimensions()
    
    pentaflake.reset()
end

function pentaflake.reset()
    local cx,cy = wd/2,ht/2
    pentaSet = {}
    pentaSet[0] = {{}}
    
    for i=1,5 do
        table.insert(pentaSet[0][1],(math.cos(an*i-math.pi/2) * size/(2*sin36)) + cx)
        table.insert(pentaSet[0][1],(math.sin(an*i-math.pi/2) * size/(2*sin36)) + cy)
    end
    genPenta(1,size/ratio,cx,cy,0)
end

function pentaflake.draw()
    love.graphics.setFont(fonts.text)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("Press 'Q' to decrease and 'W' to\n increase the number of steps.\n\nPress 'A' to decrease and 'S' to\n increase the size of the initial pentagon.\n\nPress SPACE to show or hide\nthe central pentagons.",0,10,wd-10,'right')
    
    for i,penta in ipairs(pentaSet[limit]) do
        love.graphics.polygon('fill',penta)
    end
    
end

function pentaflake.keypressed(key)
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
    pentaflake.reset()
end

function pentaflake.resize(w,h)
    pentaflake.init()
end

function pentaflake.exit()
    pentaSet = {}
    collectgarbage()
end

return pentaflake