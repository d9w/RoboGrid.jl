function exit_reward(e::Episode; reward::Float64=1.0)
    linds = LinearIndices(e.grid.cells)
    if linds[e.robot.y, e.robot.x] in e.grid.exits
        return reward
    end
    0.0
end

function food_reward(e::Episode; reward::Float64=1.0)
    if object(e.grid.cells[e.robot.y, e.robot.x]) == "food"
        e.grid.cells[e.robot.y, e.robot.x].obj = type_to_float("empty")
        return reward
    end
    0.0
end

function coverage_reward(e::Episode; reward::Float64=1.0)
    if ~("visited" in keys(e.meta))
        e.meta["visited"] = falses(size(e.grid.cells))
    end
    if ~e.meta["visited"][e.robot.y, e.robot.x]
        e.meta["visited"][e.robot.y, e.robot.x] = true
        return reward
    end
    0.0
end


