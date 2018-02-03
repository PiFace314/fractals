local vicsek = {}
vicsek.name = "Vicsek Flake"

local wd,ht

local limit = 5
local size = 200

local saltireSet = {}
local crossSet = {}

local function genSaltire(step,px,py)
    if not saltireSet[step] then saltireSet[step] = {} end
    table.insert(saltireSet[step],{px,py})
    table.insert(saltireSet[step],{px + 2*size/(3^step),py})
    table.insert(saltireSet[step],{px + size/(3^step),py + size/(3^step)})
    table.insert(saltireSet[step],{px,py + 2*size/(3^step)})
    table.insert(saltireSet[step],{px + 2*size/(3^step),py + 2*size/(3^step)})
    
    if step < limit then
        genSaltire(step+1,px,py)
        genSaltire(step+1,px+2*size/(3^step),py)
        genSaltire(step+1,px+size/(3^step),py+size/(3^step))
        genSaltire(step+1,px,py+2*size/(3^step))
        genSaltire(step+1,px+2*size/(3^step),py+2*size/(3^step))
    end
end

local function genCross(step,px,py)
    if not crossSet[step] then crossSet[step] = {} end
    table.insert(crossSet[step],{px + size/(3^step),py})
    table.insert(crossSet[step],{px,py + size/(3^step)})
    table.insert(crossSet[step],{px + size/(3^step),py + size/(3^step)})
    table.insert(crossSet[step],{px + 2*size/(3^step),py + size/(3^step)})
    table.insert(crossSet[step],{px + size/(3^step),py + 2*size/(3^step)})
    
    if step < limit then
        genCross(step+1,px+size/(3^step),py)
        genCross(step+1,px,py+size/(3^step))
        genCross(step+1,px+size/(3^step),py+size/(3^step))
        genCross(step+1,px+2*size/(3^step),py+size/(3^step))
        genCross(step+1,px+size/(3^step),py+2*size/(3^step))
    end
end

function vicsek.init()
    love.graphics.setColor(255,255,255)
    love.graphics.setLineWidth(1)
    wd,ht = love.graphics.getDimensions()
    
    vicsek.reset()
end

function vicsek.reset()
    saltireSet = {}
    saltireSet[0] = {{wd/4-size/2,ht/2-size/2}}
    genSaltire(1,wd/4-size/2,ht/2-size/2)
    crossSet = {}
    crossSet[0] = {{wd*3/4-size/2,ht/2-size/2}}
    genCross(1,wd*3/4-size/2,ht/2-size/2)
end

function vicsek.draw()
    love.graphics.setFont(fonts.text)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("Press 'Q' to decrease and 'W' to\n increase the number of steps.\n\nPress 'A' to decrease and 'S' to\n increase the size of the initial squares.",0,10,wd-10,'right')
    love.graphics.setFont(fonts.title2)
    love.graphics.printf("Saltire Form",0,ht-fonts.title2:getHeight()-3,wd/2,'center')
    love.graphics.printf("Cross Form",wd/2,ht-fonts.title2:getHeight()-3,wd/2,'center')
    
    for i,sq in pairs(saltireSet[limit]) do
        love.graphics.rectangle('fill',sq[1],sq[2],size/(3^limit),size/(3^limit))
    end
    for i,sq in pairs(crossSet[limit]) do
        love.graphics.rectangle('fill',sq[1],sq[2],size/(3^limit),size/(3^limit))
    end
    
end

function vicsek.keypressed(key)
    if key=='q' and limit > 0 then 
        limit = limit - 1
    elseif key=='w' then
        limit = limit + 1
    elseif key=='a' then
        size = size - 10
    elseif key=='s' then
        size = size + 10
    end
    vicsek.reset()
end

function vicsek.resize(w,h)
    vicsek.init()
end

function vicsek.exit()
    saltireSet = {}
    crossSet = {}
    collectgarbage()
end

return vicsek