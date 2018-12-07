export Grid

struct Grid
    cells::Array{Cell}
    starts::Array{Int64}
    exits::Array{Int64}
end

function get_empty(cells::Array{Cell}, x::Int64, y::Int64)
    xs = x > 0 ? [x] : shuffle!(collect(1:size(cells, 2)))
    ys = y > 0 ? [y] : shuffle!(collect(1:size(cells, 1)))
    for xi in xs
        for yi in ys
            if cells[yi, xi].obj == 0.0
                return xi, yi
            end
        end
    end
    error("No empty cell found for $x, $y")
end

function Grid(map::String="maps/default.yaml")
    m = YAML.load_file(map)
    cells = Array{Cell}(undef, m["height"], m["width"])
    for i in eachindex(cells)
        cells[i] = Cell()
    end
    for o in m["objects"]
        color = get(o, "color", "white")
        obj = get(o, "type", "empty")
        x = get(o, "x", 0)
        y = get(o, "y", 0)
        x, y = get_empty(cells, x, y)
        cells[y, x] = Cell(color, obj)
    end
    inds = LinearIndices(cells)
    starts = Array{Int64}(undef, 0)
    if "starts" in keys(m)
        for s in m["starts"]
            x = get(s, "x", 0)
            y = get(s, "y", 0)
            if (x == 0 || y == 0)
                x, y = get_empty(cells, x, y)
            end
            x, y = get_empty(cells, x, y)
            push!(starts, inds[y, x])
        end
    else
        for i in eachindex(cells)
            if object(cell) != "wall"
                push!(starts, i)
            end
        end
    end
    exits = Array{Int64}(undef, 0)
    if "exits" in keys(m)
        for e in m["exits"]
            x = get(e, "x", 0)
            y = get(e, "y", 0)
            if (x == 0 || y == 0)
                x, y = get_empty(cells, x, y)
            end
            push!(exits, inds[y, x])
        end
    else
        for i in eachindex(cells)
            if object(cell) != "wall"
                push!(exits, i)
            end
        end
    end
    Grid(cells, starts, exits)
end
