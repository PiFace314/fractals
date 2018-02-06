local gasket = {}
gasket.name = "Apollonian Gasket"

local wd,ht
local Complex = require 'complex'

local limit = 4
local size = 100
local rotation = 0

local cirSet = {}

local z1
local z2
local z3
local nc1,nc2
local r1,r2


local function tcFindCurvs(r1,r2,r3)
    local k1 = 1/r1
    local k2 = 1/r2
    local k3 = 1/r3
    return k1+k2+k3+2*math.sqrt(k1*k2+k2*k3+k3*k1),k1+k2+k3-2*math.sqrt(k1*k2+k2*k3+k3*k1)
end

local function tcFindRadii(r1,r2,r3)
    local k1,k2 = tcFindCurvs(r1,r2,r3)
    return math.abs(1/k1),math.abs(1/k2)
end

local function tcFindCenters(r1,r2,r3,c1x,c1y,c2x,c2y,c3x,c3y)
    local k1 = 1/r1
    local k2 = 1/r2
    local k3 = 1/r3
    local z1 = Complex.new(c1x,c1y)
    local z2 = Complex.new(c2x,c2y)
    local z3 = Complex.new(c3x,c3y)
    
    local nk1,nk2 = tcFindCurvs(r1,r2,r3)
    local czySqrt = k1*k2*z1*z2 + k2*k3*z2*z3 + k3*k1*z3*z1
    czySqrt = czySqrt:sqrt()
    return (k1*z1+k2*z2+k3*z3+2*czySqrt)/nk1,(k1*z1+k2*z2+k3*z3-2*czySqrt)/nk2
end


function gasket.init()
    love.graphics.setColor(255,255,255)
    wd,ht = love.graphics.getDimensions()
    
    gasket.reset()
end

function gasket.reset()
    cirSet = {}
    collectgarbage()
    local r = 2*size/math.sqrt(3)
    local rot = math.rad(rotation)
    z1 = Complex.new((math.cos(rot-math.pi/2)*r)+wd/2,(math.sin(rot-math.pi/2)*r)+ht/2)
    z2 = Complex.new((math.cos(math.pi*2/3+rot-math.pi/2)*r)+wd/2,(math.sin(math.pi*2/3+rot-math.pi/2)*r)+ht/2)
    z3 = Complex.new((math.cos(math.pi*4/3+rot-math.pi/2)*r)+wd/2,(math.sin(math.pi*4/3+rot-math.pi/2)*r)+ht/2)
    r1,r2 = tcFindRadii(size,size,size)
    nc1,nc2 = tcFindCenters(size,size,size,z1.real,z1.imag,z2.real,z2.imag,z3.real,z3.imag)
end

function gasket.draw()
    love.graphics.setFont(fonts.text)
    love.graphics.setColor(255,255,255)
    love.graphics.printf("Press 'Q' to decrease and 'W' to\n increase the number of steps.\n\nPress 'A' to decrease and 'S' to\n increase the radii of the initial circles.\n\nScroll up or down to rotate.\nAngle: "..rotation.."°",0,10,wd-10,'right')
    
    love.graphics.circle('line',z1.real,z1.imag,size)
    love.graphics.circle('line',z2.real,z2.imag,size)
    love.graphics.circle('line',z3.real,z3.imag,size)
    love.graphics.circle('line',nc1.real,nc1.imag,r1)
    love.graphics.circle('line',nc2.real,nc2.imag,r2)
    
end

function gasket.keypressed(key)
    if key=='q' and limit > 0 then 
        limit = limit - 1
    elseif key=='w' then
        limit = limit + 1
    elseif key=='a' and size > 10 then
        size = size - 10
    elseif key=='s' then
        size = size + 10
    end
    gasket.reset()
end

function gasket.wheelmoved(x, y) 
    if y > 0 then
        rotation = rotation + 1
        if rotation > 360 then rotation = -360 end
        gasket.reset()
    elseif y < 0 then
        rotation = rotation - 1
        if rotation < -360 then rotation = 360 end
        gasket.reset()
    end
end

function gasket.resize(w,h)
    gasket.init()
end

function gasket.exit()
    cirSet = {}
    collectgarbage()
end

return gasket
