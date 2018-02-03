local sierpinski = {}
sierpinski.name = "Sierpinski's Triangle"

local wd,ht

local limit = 5
local length = 400
local mode = 'line'

local triSet = {}

local function genTri(step,px,py)
    if not triSet[step] then triSet[step] = {} end
    local newlen = length/(2^step)
    local newht = newlen/2 * math.sqrt(3)
    
    table.insert(triSet[step],{px-newlen/2,py+newht,px+newlen/2,py+newht,px,py+newht*2})
    
    if step < limit then
        genTri(step+1,px,py)
        genTri(step+1,px-newlen/2,py+newht)
        genTri(step+1,px+newlen/2,py+newht)
    end
end

function sierpinski.reset()
    local triht = length/2 * math.sqrt(3)
    triSet = {}
    triSet[0] = {{
        wd/2,          ht/2-triht/2,
        wd/2-length/2, ht/2+triht/2,
        wd/2+length/2, ht/2+triht/2
    }}
    if limit >= 1 then
        genTri(1,wd/2,ht/2-triht/2)
    end
end

function sierpinski.init()
    love.graphics.setColor(255,255,255)
    love.graphics.setLineWidth(1)
    wd,ht = love.graphics.getDimensions()
    
    sierpinski.reset()
end

function sierpinski.draw()
    love.graphics.setFont(fonts.text)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("Press 'Q' to decrease and 'W' to\n increase the number of steps.\n\nPress 'A' to decrease and 'S' to\n increase the length of the initial triangle.\n\nPress SPACE to switch between\nthe outline or filled versions.",0,10,wd-10,'right')
    
    love.graphics.polygon(mode,triSet[0][1])
    
    if mode=='fill' then love.graphics.setColor(0,0,0) end
    for step,tris in ipairs(triSet) do
        for i,tri in pairs(tris) do
            love.graphics.polygon(mode,tri)
        end
    end
end

function sierpinski.keypressed(key)
    if key=='q' and limit > 0 then 
        limit = limit - 1
    elseif key=='w' then
        limit = limit + 1
    elseif key=='a' then
        length = length - 10
    elseif key=='s' then
        length = length + 10
    elseif key=='space' then
        if mode=='fill' then
            mode = 'line'
        else
            mode = 'fill'
        end
    end
    sierpinski.reset()
end

function sierpinski.resize(w,h)
    sierpinski.init()
end

function sierpinski.exit()
    triSet = {}
    collectgarbage()
end

return sierpinski