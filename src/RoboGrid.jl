module RoboGrid

import YAML
using Random
# using Reel
# using Luxor

# empty must be first object, wall must be last object
global const OBJECT_TYPES = ["empty", "food", "wall"]
global const ACTIONS = ["move forward", "move backward", "turn right",
                        "turn left"]
global const COLORS = ["white", "red", "orange", "yellow", "green", "blue",
                       "purple", "black"]

function float_to_ind(f::Float64, x::AbstractArray)
    x[round(Int64, f * (length(x) - 1)) + 1]
end
float_to_color(f::Float64) = float_to_ind(f, COLORS)
float_to_type(f::Float64) = float_to_ind(f, OBJECT_TYPES)

function ind_to_float(s::String, x::Array{String})
    r = range(0.0; stop=1.0, length=length(x))
    r[findfirst(x .== s)]
end
color_to_float(s::String) = ind_to_float(s, COLORS)
type_to_float(s::String) = ind_to_float(s, OBJECT_TYPES)

include("cell.jl")
include("grid.jl")
include("robot.jl")
include("episode.jl")
include("reward.jl")
include("fitness/water.jl")
include("fitness/cross.jl")

end
