export Cell, Grid

mutable struct Cell
    cstr::String
    color::Float64
    ostr::String
    obj::Float64
    reward::Float64
end

struct Grid
    cells::Array{Cell}
    starts::Array{Int64}
    exits::Array{Int64}
end

function color_to_float(x::String)
    min(1.0, colordiff(colorant"white", parse(Colorant, x)) / 100.0)
end

function type_to_float(x::String)
    findfirst(OBJECT_TYPES .== x) / length(OBJECT_TYPES)
end

function Cell(color::String, obj::String, reward::Float64)
    Cell(color, color_to_float(color), obj, type_to_float(obj), reward)
end

function Cell()
    Cell("white", "empty", 0.0)
end

function Grid(;map::String="maps/default.yaml")
    m = YAML.load_file(map)
    cells = Array{Cell}(undef, m["height"], m["width"])
    for i in eachindex(cells)
        cells[i] = Cell()
    end
    for o in m["objects"]
        color = "color" in keys(o) ? o["color"] : "white"
        obj = "type" in keys(o) ? o["type"] : "empty"
        reward = "reward" in keys(o) ? o["reward"] : 0.0
        cells[o["y"], o["x"]] = Cell(color, obj, reward)
    end
    inds = LinearIndices(cells)
    starts = Array{Int64}(undef, 0)
    if "starts" in keys(m)
        for s in m["starts"]
            push!(starts, inds[s["y"], s["x"]])
        end
    else
        for i in eachindex(cells)
            if cell.ostr != "wall"
                push!(starts, i)
            end
        end
    end
    exits = Array{Int64}(undef, 0)
    if "exits" in keys(m)
        for e in m["exits"]
            push!(exits, inds[e["y"], e["x"]])
        end
    else
        for i in eachindex(cells)
            if cell.ostr != "wall"
                push!(exits, i)
            end
        end
    end
    Grid(cells, starts, exits)
end
