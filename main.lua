--------------------------------------
--             Fractals             --
--------------------------------------
local fractals = {}
local chosen_fractal = "none"

local wd,ht = love.graphics.getDimensions()

local input = ""
local inputOn = false

local logo
local icons = {}
fonts = {}

local Button = require 'button'
local buttons = {}

local Scrollbar = require 'scrollbar'
local fselect
local fselWD = math.min(wd/3,267)

local inRect = function (x,y,w,h,px,py)
	return px >= x and py >= y and px <= x+w and py <= y+h
end

local function loadFonts()
    fonts.text = love.graphics.newFont("fonts/dejavu.ttf",math.min(wd*3/200,ht*1/50))
    fonts.title2 = love.graphics.newFont("fonts/futura_M.ttf",math.min(wd*1/40,ht*1/30))
    fonts.title1 = love.graphics.newFont("fonts/futura_L.ttf",math.min(wd*1/25,ht*4/75))
end

--alphabetical iteration
local pairsByKeys = function (a)
    local orderedIndexes = {}
    for i,_ in pairs(a) do
        table.insert(orderedIndexes,i)
    end
    table.sort(orderedIndexes)
    
    local index = 0
    local alphaiter = function (t, i)
        index = index + 1
        return orderedIndexes[index],t[orderedIndexes[index]]
    end
    
    return alphaiter, a, nil
end

function love.load()
    --load all fractal types
    for _,file in pairs(love.filesystem.getDirectoryItems("types")) do
        --[[local ftype = string.sub(file,1,-5)
        fractals[ftype] = require("types/"..ftype)]]
        local ftypen = string.sub(file,1,-5)
        local ftype = require("types/"..ftypen)
        fractals[ftype.name] = ftype
    end
    
    logo = love.graphics.newImage("fractals_logo.png")
    icons.ret =  love.graphics.newImage("return_ico.png")
    icons.menu =  love.graphics.newImage("menu_ico.png")
    loadFonts()
    
    love.keyboard.setKeyRepeat(true)
    love.keyboard.setTextInput(false)
    
    fselect = Scrollbar.new(wd/2-fselWD/2,ht*2/5+fonts.title1:getHeight(),fselWD,ht*17/30-fonts.title1:getHeight(),
        ht/15,fonts.title2,
        function (val)
            fselect:move(-fselWD-3,ht/10,0.1)
            buttons.menu.active = true
            if fractals[chosen_fractal] and fractals[chosen_fractal].exit then fractals[chosen_fractal].exit() end
            chosen_fractal = val
            if fractals[chosen_fractal].init then fractals[chosen_fractal].init() end
        end)
    fselect:setColors({t={255,255,255},bg={0,0,0,0}},{t={255,255,255},bg={255,255,255,50}},{t={255,255,255},bg={255,255,255,100}})
    for i,f in pairsByKeys(fractals) do
        fselect:insertRow(f.name,i)
    end
    
    buttons.menu = Button.new(0,0,ht/10,ht/10,0,
        function ()
            fselect:move(0,ht/10,0.1)
            buttons.menu.active = false
        end)
    buttons.menu:setColors({t={0,0,0,0},bg={0,0,0,0}},
                           {t={0,0,0,0},bg={255,255,255,50}},
                           {t={0,0,0,0},bg={255,255,255,100}})
    
    buttons.ret = Button.new(fselect.x,0,ht/10,ht/10,0,
        function ()
            fselect:move(-fselWD-3,ht/10,0.1)
            buttons.menu.active = true
        end)
    buttons.ret:setColors({t={0,0,0,0},bg={0,0,0,255}},
                           {t={0,0,0,0},bg={50,50,50,255}},
                           {t={0,0,0,0},bg={100,100,100,255}})
end

function love.update(dt)
    fselect:update(dt)
    if chosen_fractal == "none" then
        fselect:setDimensions(wd/2-fselWD/2,ht*2/5+fonts.title1:getHeight(),fselWD,ht*17/30-fonts.title1:getHeight())
    else
        fselect:setDimensions(fselect.x,ht/10,fselWD,ht*9/10)
        buttons.ret:setDimensions(fselect.x,0,ht/10,ht/10)
        buttons.menu:update(dt)
        buttons.ret:update(dt)
    end
    if fractals[chosen_fractal] and fractals[chosen_fractal].update then fractals[chosen_fractal].update(dt) end
end

function love.draw()
    love.graphics.setColor(255,255,255)
    
    if fractals[chosen_fractal] and fractals[chosen_fractal].draw then
        buttons.menu:draw()
        love.graphics.setColor(255,255,255)
        love.graphics.draw(icons.menu,0,0,0,(ht/10)/icons.menu:getWidth())
        love.graphics.setFont(fonts.title2)
        love.graphics.print(fractals[chosen_fractal].name,ht/10+10,ht/20,0,1,1,0,fonts.title2:getHeight()/2)
        fractals[chosen_fractal].draw()
        
        love.graphics.setColor(0,0,0,200)
        love.graphics.rectangle('fill',fselect.x,0,fselect.w,ht)
        buttons.ret:draw()
        love.graphics.setColor(255,255,255)
        love.graphics.draw(icons.ret,fselect.x,0,0,(ht/10)/icons.ret:getWidth())
        love.graphics.rectangle('fill',fselect.x+fselect.w,0,3,ht)
    else
        love.graphics.rectangle('fill',0,ht/30-3,wd,3)
        love.graphics.draw(logo,wd/2,ht/6,0,(ht*3/15-6)/logo:getHeight(),(ht*3/15-6)/logo:getHeight(),
            logo:getWidth()/2,logo:getHeight()/2)
        love.graphics.rectangle('fill',0,ht*9/30,wd,3)
        
        love.graphics.setFont(fonts.title1)
        love.graphics.printf("Choose a fractal:",0,ht*11/30,wd,'center')
        love.graphics.rectangle('line',wd/2-fselWD/2-3,ht*2/5+fonts.title1:getHeight()-3,
            fselWD+6,ht*17/30-fonts.title1:getHeight()+6,3,3)
        
    end
    
    fselect:draw()
end

function love.keypressed(key)
    if key=='escape' then
        if fractals[chosen_fractal] and fractals[chosen_fractal].exit then fractals[chosen_fractal].exit() end
        chosen_fractal = 'none'
    end
    if fractals[chosen_fractal] and fractals[chosen_fractal].keypressed then 
        fractals[chosen_fractal].keypressed(key)
    end
end

function love.mousepressed(x,y,button)
    if chosen_fractal~="none" then
        buttons.menu:mousepressed(x,y,button)
        buttons.ret:mousepressed(x,y,button)
    end
    if fractals[chosen_fractal] and fractals[chosen_fractal].mousereleased then
        fractals[chosen_fractal].mousereleased(x,y,button)
    end
end

function love.mousereleased(x,y,button)
    fselect:mousereleased(x,y,button)
    if chosen_fractal~="none" then
        buttons.menu:mousereleased(x,y,button)
        buttons.ret:mousereleased(x,y,button)
    end
    if fractals[chosen_fractal] and fractals[chosen_fractal].mousereleased then
        fractals[chosen_fractal].mousereleased(x,y,button)
    end
end

function love.wheelmoved(x,y)
    fselect:wheelmoved(x,y)
    if fractals[chosen_fractal] and fractals[chosen_fractal].wheelmoved then fractals[chosen_fractal].wheelmoved(x,y) end
end

function love.resize(w,h)
    if fractals[chosen_fractal] and fractals[chosen_fractal].resize then fractals[chosen_fractal].resize(w,h) end
    wd,ht = w,h
    buttons.menu:setDimensions(0,0,ht/10,ht/10)
    buttons.ret:setDimensions(fselect.x,0,ht/10,ht/10)
    fselWD = math.min(wd/3,267)
    loadFonts()
end