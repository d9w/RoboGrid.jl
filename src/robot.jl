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
    if mod(r.d, 2) == 0
        dy = r.d == 0 ? 1 : -1
        newx, newy = r.x, min(size(g.cells, 2), max(1, r.y + f * dy))
    else
        dx = r.d == 1 ? 1 : -1
        newx, newy = min(size(g.cells, 2), max(1, r.y + f * dx)), r.y
    end
    if g.cells[newy, newx].obj != 1.0
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
