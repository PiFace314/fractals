local koch = {}
koch.name = "Koch Curve"

local wd,ht

local color = {255,255,255}
local limit = 3
local rad60 = math.pi/3

local lineSet = {}

local function lineDraw (l)
    lineSet[l+1] = {}
    
    local x = 0
    local y = ht-100
    local an = 0
    
    for i=1,#lineSet[l]-2,2 do
        
        local dx,dy = (lineSet[l][i+2]-lineSet[l][i])/3,(lineSet[l][i+3]-lineSet[l][i+1])/3
        local d = math.sqrt(dx*dx + dy*dy)
        
        if dx > 0 then
            if dy > 0 then
                an = 0
            elseif dy < 0 then
                an = -2*rad60
            else
                an = -rad60
            end
        elseif dx < 0 then
            if dy > 0 then
                an = rad60
            elseif dy < 0 then
                an = -3*rad60
            else
                an = 2*rad60
            end
        end
        
        if math.abs(an) < 0.1 then an = 0 end
        
        for j=1,3 do
            table.insert(lineSet[l+1],x)
            table.insert(lineSet[l+1],y)
            if j==2 then
                table.insert(lineSet[l+1],x + math.cos(an)*d)
                table.insert(lineSet[l+1],y + math.sin(an)*d)
            end
            x = x + dx
            y = y + dy
        end
        
    end
    
    table.insert(lineSet[l+1],wd)
    table.insert(lineSet[l+1],ht-100)
    
    if l < limit then
        lineDraw(l+1)
    end
end


function koch.init()
    wd,ht = love.graphics.getDimensions()
    lineSet = {{0, ht-100, wd, ht-100}}
    lineDraw(1)
end

function koch.draw()
    love.graphics.setColor(color)
    love.graphics.setLineWidth(1)
    love.graphics.line(lineSet[limit])
    love.graphics.setFont(fonts.text)
    love.graphics.printf("Press 'Q' to decrease and 'W' to increase the number of steps.",wd-210,10,200,"right")
end

function koch.keypressed(key)
    if key=='q' and limit > 1 then 
        limit = limit - 1
        lineDraw(1)
    end
    if key=='w' then
        limit = limit + 1
        lineDraw(1)
    end
end

function koch.resize(w,h)
    wd = w
    ht = h
    lineSet = {{0, ht-100, wd, ht-100}}
    lineDraw(1)
end

function koch.exit()
    lineSet = {}
    collectgarbage()
end

return koch