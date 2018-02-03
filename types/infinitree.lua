local tree = {}
tree.name = "Infinitree"

local wd,ht

local limit = 5

local branchesSet = {}
local theta = 90
local ratio = 1/2

local function branches(step,size,pos,an)
    
    local branch = {
        pos.x,pos.y,
        pos.x + size*math.cos(math.rad(an)),
        pos.y + size*math.sin(math.rad(an))
    }
    
    if not branchesSet[step] then branchesSet[step] = {} end
    table.insert(branchesSet[step],branch)
    
    if step > 0 then
        
        branches(step-1,size*ratio,{x = branch[3],y = branch[4]},an-theta/2)
        branches(step-1,size*ratio,{x = branch[3],y = branch[4]},an+theta/2)
        
    end
end

function tree.reset()
    branchesSet = {}
    branches(limit,ht/3,{x = wd/2,y = ht},-90)
end

function tree.init()
    love.graphics.setColor(255,255,255)
    love.graphics.setLineWidth(1)
    wd,ht = love.graphics.getDimensions()
    
    tree.reset()
end

function tree.draw()
    love.graphics.setFont(fonts.text)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("Press 'Q' to decrease and 'W' to\n increase the number of steps.\n\nPress 'A' to decrease and 'S' to\n increase the size of the branches.\n\nScroll up or down to change the angle.\nAngle: "..theta.."°",0,10,wd-10,'right')
    
    for i,s in pairs(branchesSet) do
        if i<=limit/2+1 then
            love.graphics.setColor(0,255,0)
        else
            love.graphics.setColor(170,80,0)
        end
        
        for _,b in pairs(s) do
            love.graphics.line(b)
        end
    end
end

function tree.keypressed(key)
    if key=='q' and limit > 0 then 
        limit = limit - 1
    elseif key=='w' then
        limit = limit + 1
    elseif key=='a' then
        ratio = ratio - 0.01
    elseif key=='s' then
        ratio = ratio + 0.01
    end
    if not love.keyboard.hasTextInput() then
        tree.reset()
    end
end

function tree.wheelmoved(x, y) 
    if y > 0 then
        theta = theta + 1
        if theta > 360 then theta = -360 end
        tree.reset()
    elseif y < 0 then
        theta = theta - 1
        if theta < -360 then theta = 360 end
        tree.reset()
    end
end

function tree.resize(w,h)
    tree.init()
end

function tree.exit()
    branchesSet = {}
    collectgarbage()
end

return tree