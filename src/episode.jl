export Episode, get_inputs, step!, run!

struct Episode
    robot::Robot
    grid::Grid
    reward::Function
    meta::Dict
end

no_reward(e::Episode) = 0

function Episode(g::Grid; reward::Function=no_reward, meta::Dict=Dict())
    robot = Robot(g)
    Episode(robot, g, reward, meta)
end

function get_inputs(e::Episode)
    inputs = Array{Float64}(undef, 0)
    for dx in -1:1
        for dy in -1:1
            c = get(e.grid.cells, (e.robot.y + dy, e.robot.x + dx), WallCell)
            push!(inputs, c.color)
            push!(inputs, c.obj)
        end
    end
    inputs
end

function step!(e::Episode, action::Int64)
    if action == 1
        move!(e.robot, e.grid)
    elseif action == 2
        move!(e.robot, e.grid; forward=false)
    elseif action == 3
        turn_right!(e.robot)
    elseif action == 4
        turn_left!(e.robot)
    elseif action == 5
        e.grid.cells[e.robot.y, e.robot.x].color = color_to_float("red")
    elseif action == 6
        e.grid.cells[e.robot.y, e.robot.x].color = color_to_float("green")
    end
    e.reward(e)
end

function step!(e::Episode, actions::AbstractArray)
    step!(e, argmax(actions))
end

function step!(e::Episode, controller::Function)
    inputs = get_inputs(e)
    output = controller(inputs)
    step!(e, output)
end

function run!(e::Episode, controller::Function, terminate::Function)
    linds = LinearIndices(e.grid.cells)
    total_reward = 0.0
    while true
        total_reward += step!(e, controller)
        if (terminate(episode) || (linds[e.robot.y, e.robot.x] in e.grid.exits))
            break
        end
    end
    total_reward
end
