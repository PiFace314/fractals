---------------------
-- Complex Numbers --
---------------------
local Complex = {}
Complex.__index = Complex

function Complex.new(a,b)
    return setmetatable({
            real = a or 0,
            imag = b or 0
        },Complex)
end

local function isComplex(z)
    return type(z) == 'table' and type(z.real) == 'number' and type(z.imag) == 'number'
end

local function sgn(x)
    if x==0 then
        return 0
    elseif x<0 then
        return -1
    else
        return 1
    end
end

function Complex.__tostring(z)
    return z.real.." + "..z.imag.." i"
end

function Complex.__add(a,b)
    if type(a)=='number' then
        return Complex.new(a+b.real,b.imag)
    elseif type(b)=='number' then
        return Complex.new(a.real+b,a.imag)
    else
        assert(isComplex(a) and isComplex(b), "Add: wrong argument types (<complex> or <number> expected)")
        return Complex.new(a.real+b.real,a.imag+b.imag)
    end
end

function Complex.__sub(a,b)
    if type(a)=='number' then
        return Complex.new(a-b.real,-b.imag)
    elseif type(b)=='number' then
        return Complex.new(a.real-b,a.imag)
    else
        assert(isComplex(a) and isComplex(b), "Sub: wrong argument types (<complex> or <number> expected)")
        return Complex.new(a.real-b.real,a.imag-b.imag)
    end
end

function Complex.__mul(a,b)
    if type(a)=='number' then
        return Complex.new(a*b.real,a*b.imag)
    elseif type(b)=='number' then
        return Complex.new(a.real*b,a.imag*b)
    else
        assert(isComplex(a) and isComplex(b), "Mul: wrong argument types (<complex> or <number> expected)")
        return Complex.new(a.real*b.real-a.imag*b.imag,a.real*b.imag+a.imag*b.real)
    end
end

function Complex.__div(a,b)
    if type(a)=='number' then
        return Complex.new(a*b.real/(b.real*b.real+b.imag*b.imag),-a*b.imag/(b.real*b.real+b.imag*b.imag))
    elseif type(b)=='number' then
        return Complex.new(a.real/b,a.imag/b)
    else
        assert(isComplex(a) and isComplex(b), "Div: wrong argument types (<complex> or <number> expected)")
        return Complex.new((a.real*b.real+a.imag*b.imag)/(b.real*b.real+b.imag*b.imag),
            (a.imag*b.real-a.real*b.imag)/(b.real*b.real+b.imag*b.imag))
    end
end

function Complex:arg()
    return math.atan2(self.imag,self.real)
end

function Complex:abs()
    return math.sqrt(self.real*self.real+self.imag*self.imag)
end

function Complex:sqrt()
    local sqrtR = math.sqrt(self:abs())
    if sqrtR==0 then
        return Complex.new()
    else
        local sinPhi2 = math.sqrt((1-self.real/self:abs())/2)
        local cosPhi2 = math.sqrt((1+self.real/self:abs())/2)
        return Complex.new(sqrtR*cosPhi2,sqrtR*sinPhi2)
    end
end

return Complex

---------------------
---------------------
