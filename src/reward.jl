function exit_reward(e::Episode; reward::Float64=1.0)
    if e.grid.linds[e.robot.y, e.robot.x] in e.grid.exits
        return reward
    end
    0.0
end

function food_reward(e::Episode; reward::Float64=1.0)
    if object(e.grid[e.robot.y, e.robot.x]) == "food"
        e.grid[e.robot.y, e.robot.x].obj = type_to_float("empty")
        return reward
    end
    0.0
end

function coverage_reward(e::Episode, visited::BitArray; reward::Float64=1.0)
    if ~visited[e.robot.y, e.robot.x]
        visited[e.robot.y, e.robot.x] = true
        return 1.0
    end
    0.0
end


