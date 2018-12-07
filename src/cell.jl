export Cell

mutable struct Cell
    color::Float64
    obj::Float64
end

function Cell(color::String, obj::String)
    Cell(color_to_float(color), type_to_float(obj))
end

WallCell = Cell("black", "wall")

function Cell()
    Cell("white", "empty")
end

function object(c::Cell)
    float_to_type(c.obj)
end

function color(c::Cell)
    float_to_color(c.color)
end
