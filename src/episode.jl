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
    meta["step"] = get(meta, "step", 0)
    meta["max_step"] = get(meta, "max_step", 100)
    meta["time"] = get(meta, "time", 0.0)
    meta["max_time"] = get(meta, "max_time", 10.0)
    meta["memory"] = get(meta, "memory", 0)
    meta["max_memory"] = get(meta, "max_memory", 1073741824)
    meta["reward"] = get(meta, "reward", 0.0)
    Episode(robot, g, reward, meta)
end

function get_inputs(e::Episode)
    cids = Array{Int64}(undef, (3, 3))
    linds = LinearIndices(e.grid.cells)
    i = 1
    for dy in -1:1
        for dx in -1:1
            cids[i] = get(linds, (e.robot.y + dy, e.robot.x + dx), 0)
            i += 1
        end
    end
    if e.robot.d > 0
        cids = [rotr90, rot180, rotl90][e.robot.d](cids)
    end
    inputs = Array{Float64}(undef, 10)
    inputs[1] = e.meta["reward"]
    i = 2
    for cid in cids
        c = get(e.grid.cells, cid, WallCell)
        inputs[i] = c.obj
        # inputs[i+1] = c.color
        i += 1
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
    e.meta["reward"] = e.reward(e)
    e.meta["reward"]
end

function step!(e::Episode, actions::AbstractArray)
    step!(e, argmax(actions))
end

function step!(e::Episode, controller::Function)
    inputs = get_inputs(e)
    output = controller(inputs)
    step!(e, output)
end

function terminate(e::Episode)
    (e.meta["step"] >= e.meta["max_step"] ||
     e.meta["time"] >= e.meta["max_time"] ||
     e.meta["memory"] >= e.meta["max_memory"])
end

function run!(e::Episode, controller::Function; terminate::Function=terminate)
    linds = LinearIndices(e.grid.cells)
    total_reward = 0.0
    while true
        rew, t, bytes, gctime, memallocs = @timed step!(e, controller)
        total_reward += rew
        e.meta["step"] += 1
        e.meta["time"] += t
        e.meta["memory"] += bytes
        if (terminate(e) || (linds[e.robot.y, e.robot.x] in e.grid.exits))
            break
        end
    end
    total_reward
end
