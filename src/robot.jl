export Robot, move!, turn_right!, turn_left!

mutable struct Robot
    x::Int64
    y::Int64
    d::Int64
end

function Robot(x::Int64, y::Int64)
    Robot(x, y, 0)
end

function Robot()
    Robot(1, 1)
end

function Robot(g::Grid)
    inds = CartesianIndices(g.cells)
    i = inds[rand(g.starts)]
    Robot(i[2], i[1])
end

function move!(r::Robot, g::Grid; forward::Bool=true)
    f = forward ? 1 : -1
    if r.d == 0
        newx, newy = r.x, r.y - f
    elseif r.d == 1
        newx, newy = r.x + f, r.y
    elseif r.d == 2
        newx, newy = r.x, r.y + f
    else
        newx, newy = r.x - f, r.y
    end
    newx = min(size(g.cells, 2), max(1, newx))
    newy = min(size(g.cells, 1), max(1, newy))
    if object(g.cells[newy, newx]) != "wall"
        r.x = newx
        r.y = newy
    end
    nothing
end

function turn_right!(r::Robot)
    r.d = mod(r.d + 1, 4)
end

function turn_left!(r::Robot)
    r.d = mod(r.d - 1, 4)
end
