local Button = {}
Button.__index = Button

local inRect = function (x,y,w,h,px,py)
	return px >= x and py >= y and px <= x+w and py <= y+h
end

function Button.new(x,y,w,h,r,click,t,font)
    return setmetatable({
            x = x or 0,
            y = y or 0,
            w = w or 1,
            h = h or 1,
            r = r or 0,
            state = 'normal',
            active = true,
            t = t or "",
            font = font or love.graphics.getFont(),
            colors = {normal = {t = {},bg = {}},hover = {t = {},bg = {}}, click = {t = {},bg = {}}},
            click = click or function () end
        },Button)
end

function Button:setDimensions(x,y,w,h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function Button:setColors(normal,hover,click)
    self.colors.normal.t = {normal.t[1],normal.t[2],normal.t[3],normal.t[4] or 255}
    self.colors.normal.bg = {normal.bg[1],normal.bg[2],normal.bg[3],normal.bg[4] or 255}
    self.colors.hover.t = {hover.t[1],hover.t[2],hover.t[3],hover.t[4] or 255}
    self.colors.hover.bg = {hover.bg[1],hover.bg[2],hover.bg[3],hover.bg[4] or 255}
    self.colors.click.t = {click.t[1],click.t[2],click.t[3],click.t[4] or 255}
    self.colors.click.bg = {click.bg[1],click.bg[2],click.bg[3],click.bg[4] or 255}
end

function Button:update(dt)
    if self.active and inRect(self.x,self.y,self.w,self.h,love.mouse.getX(),love.mouse.getY()) and not love.mouse.isDown(1) then
        self.state = 'hover'
    elseif not love.mouse.isDown(1) then
        self.state = 'normal'
    end
end

function Button:draw()
    love.graphics.setColor(self.colors[self.state].bg)
    love.graphics.rectangle('fill',self.x,self.y,self.w,self.h,self.r,self.r)
    love.graphics.setColor(self.colors[self.state].t)
    love.graphics.printf(self.t,self.x,self.y,self.w,'center',0,1,1,0,self.font:getHeight()/2)
end

function Button:mousepressed(x,y,button)
    if self.active and button==1 and inRect(self.x,self.y,self.w,self.h,x,y) then
        self.state = 'click'
    end
end

function Button:mousereleased(x,y,button)
    if self.active and button==1 and inRect(self.x,self.y,self.w,self.h,x,y) then
        self.state = 'normal'
        self.click()
    end
end

return Button