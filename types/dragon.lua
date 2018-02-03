local dragon = {}
dragon.name = "Dragon Curve"

local wd,ht

local limit = 5
local initSize
local rotation = -45
local showN = 3

local scalesSet = {}

local colorMod = -1
local colors = {
    {255,  0,  0},
    {255,127,  0},
    {255,255,  0},
    {127,255,  0},
    {  0,255,  0},
    {  0,255,127},
    {  0,255,255},
    {  0,127,255},
    {  0,  0,255},
    {127,  0,255},
    {255,  0,255},
    {255,  0,127}
}

local ratio = 1/math.sqrt(2)

local function scales(step,size,pos,an)
    
    local scale = {
        pos.x,pos.y,
        pos.x + size*math.cos(an),
        pos.y + size*math.sin(an)
    }
    
    if not scalesSet[step] then scalesSet[step] = {} end
    table.insert(scalesSet[step],scale)
    
    
    if step > 0 then
        if #scalesSet[step]%2==1 then
            scales(step-1,size*ratio,pos,an-math.pi/4)
            scales(step-1,size*ratio,
                {x = pos.x+size*ratio*math.cos(an-math.pi/4),y = pos.y+size*ratio*math.sin(an-math.pi/4)},an+math.pi/4)
        else
            scales(step-1,size*ratio,pos,an+math.pi/4)
            scales(step-1,size*ratio,
                {x = pos.x+size*ratio*math.cos(an+math.pi/4),y = pos.y+size*ratio*math.sin(an+math.pi/4)},an-math.pi/4)
        end
    end
end

function dragon.reset()
    scalesSet = {}
    scales(limit,initSize,{x = wd/3,y = ht*4/6},math.rad(rotation))
end

function dragon.init()
    wd,ht = love.graphics.getDimensions()
    
    initSize = ht/3
    
    dragon.reset()
end

function dragon.draw()
    love.graphics.setFont(fonts.text)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("Press 'Q' to decrease and 'W' to\n increase the number of steps.\n\nPress 'A' to decrease and 'S' to\n increase the size of the dragon.\n\nScroll up or down to change the angle.\n\nPress 'Z' to decrease and 'X' to\n increase the number of visible steps.\n\nPress 'E' and 'R' to change the colors.",0,10,wd-10,'right')
    
    
    for i=1,math.min(showN,limit) do
        local colorIndex = (i + colorMod)%12 + 1
        love.graphics.setColor(colors[colorIndex][1],colors[colorIndex][2],colors[colorIndex][3],math.ceil(255/i))
        for _,l in pairs(scalesSet[i]) do
            love.graphics.line(l)
        end
    end
end

function dragon.keypressed(key)
    if key=='q' and limit > 1 then 
        limit = limit - 1
    elseif key=='w' then
        limit = limit + 1
    elseif key=='a' then
        initSize = initSize - 10
    elseif key=='s' then
        initSize = initSize + 10
    elseif key=='z' and showN > 1 then
        showN = showN - 1
    elseif key=='x' and showN < limit then
        showN = showN + 1
    elseif key=='e' then
        colorMod = colorMod - 1
    elseif key=='r' then
        colorMod = colorMod + 1
    end
    if not love.keyboard.hasTextInput() then
        dragon.reset()
    end
end

function dragon.wheelmoved(x, y) 
    if y > 0 then
        rotation = rotation + 1
        if rotation > 360 then rotation = -360 end
        dragon.reset()
    elseif y < 0 then
        rotation = rotation - 1
        if rotation < -360 then rotation = 360 end
        dragon.reset()
    end
end

function dragon.resize(w,h)
    dragon.init()
end

function dragon.exit()
    scalesSet = {}
    collectgarbage()
end

return dragon