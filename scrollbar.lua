local Scrollbar = {}
Scrollbar.__index = Scrollbar

local inRect = function (x,y,w,h,px,py)
	return px >= x and py >= y and px <= x+w and py <= y+h
end

function Scrollbar.new(x,y,w,h,rh,font,click)
    return setmetatable({
            x = x or 0,
            y = y or 0,
            w = w or 1,
            h = h or 1,
            rh = rh or 1,
            offset = 0,
            font = font or love.graphics.getFont(),
            colors = {normal = {t = {},bg = {}},hover = {t = {},bg = {}}, click = {t = {},bg = {}}},
            rows = {},
            click = click or function () end
        },Scrollbar)
end

function Scrollbar:setDimensions(x,y,w,h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function Scrollbar:setColors(normal,hover,click)
    self.colors.normal.t = {normal.t[1],normal.t[2],normal.t[3],normal.t[4] or 255}
    self.colors.normal.bg = {normal.bg[1],normal.bg[2],normal.bg[3],normal.bg[4] or 255}
    self.colors.hover.t = {hover.t[1],hover.t[2],hover.t[3],hover.t[4] or 255}
    self.colors.hover.bg = {hover.bg[1],hover.bg[2],hover.bg[3],hover.bg[4] or 255}
    self.colors.click.t = {click.t[1],click.t[2],click.t[3],click.t[4] or 255}
    self.colors.click.bg = {click.bg[1],click.bg[2],click.bg[3],click.bg[4] or 255}
end

function Scrollbar:setFont(font)
    self.font = font
end

function Scrollbar:insertRow(text,value)
    table.insert(self.rows,{t = text,val = value,state = "normal"})
end

function Scrollbar:update(dt)
    if inRect(self.x,self.y,self.w,self.h,love.mouse.getX(),love.mouse.getY()) then
        for i,row in ipairs(self.rows) do
            if inRect(self.x,self.y-self.offset+(i-1)*self.rh,self.w,self.rh,love.mouse.getX(),love.mouse.getY()) then
                if love.mouse.isDown(1) then
                    row.state = "click"
                else
                    row.state = "hover"
                end
            else
                row.state = "normal"
            end
        end
    end
    if self.moveOp then
        self.moveOp(dt)
    end
end

function Scrollbar:draw()
    love.graphics.setScissor(self.x,self.y,self.w,self.h)
        love.graphics.setFont(self.font)
        for i,row in ipairs(self.rows) do
            if i*self.rh-self.offset >= 0 and (i-1)*self.rh-self.offset-self.h <= 0  then
                love.graphics.setColor(self.colors[row.state].bg)
                love.graphics.rectangle('fill',self.x,self.y-self.offset+(i-1)*self.rh,self.w,self.rh)
                love.graphics.setColor(self.colors[row.state].t)
                love.graphics.printf("  "..row.t,self.x,self.y-self.offset+(i-0.5)*self.rh,
                    self.w,'left',0,1,1,0,self.font:getHeight()/2)
            end
        end
    love.graphics.setScissor()
end

function Scrollbar:mousereleased(x,y,button)
    if button==1 then
        for i,row in ipairs(self.rows) do
            if inRect(self.x,self.y-self.offset+(i-1)*self.rh,self.w,self.rh,x,y) then
                self.click(row.val)
                row.state = "normal"
            end
        end
    end
end

function Scrollbar:wheelmoved(x,y)
    local speed = 10
    if inRect(self.x,self.y,self.w,self.h,love.mouse.getX(),love.mouse.getY()) then
        if y > 0 and self.offset > 0 then
            if self.offset-speed <= 0 then
                self.offset = 0
            else
                self.offset = self.offset - speed
            end
        elseif y < 0 and self.offset < #self.rows*self.rh - self.h then
            if self.offset+speed >= #self.rows*self.rh - self.h then
                self.offset = #self.rows*self.rh - self.h
            else
                self.offset = self.offset + speed
            end
        end
    end
end

function Scrollbar:move(tgx,tgy,speed)
    local dx,dy = tgx-self.x,tgy-self.y
    self.moveOp = function (dt)
        dx = tgx - self.x
		dy = tgy - self.y
		self.x = self.x + dx * speed
		self.y = self.y + dy * speed
		if (math.sqrt(dx*dx + dy*dy) <= 2) then
            self.x = tgx
			self.y = tgy
			self.moveOp = nil
		end
    end
end

return Scrollbar