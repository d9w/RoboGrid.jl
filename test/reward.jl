function coverage_robot(inputs::Array{Float64})
    # TODO: visualize why this doesn't work
    # wall or covered spot in front
    # green = RoboGrid.color_to_float("green")
    # if inputs[3] == 1.0 || inputs[4] == green
    #     return rand([3, 4])
    # end
    # # paint green in self spot
    # if inputs[10] != "green"
    #     return 6
    # end
    # 1
    rand(1:4)
end

@testset "Exit reward" begin
    e = Episode(Grid(), reward=RoboGrid.exit_reward)
    total_reward = run!(e, coverage_robot)
    println("Found exit in ", e.meta["step"], " steps, ", e.meta["t"], " s, ",
            e.meta["memory"], " bytes")
    @test total_reward == 1.0
end

@testset "Food reward" begin
    g = Grid()
    foodind = findfirst([RoboGrid.object(c) == "food" for c in g.cells])
    g.exits[1] = LinearIndices(g.cells)[foodind]
    e = Episode(g, reward=RoboGrid.food_reward)
    total_reward = run!(e, coverage_robot)
    println("Found food in ", e.meta["step"], " steps, ", e.meta["t"], " s, ",
            e.meta["memory"], " bytes")
    @test total_reward == 1.0
    @test sum(map(c->RoboGrid.object(c) == "food", e.grid.cells)) == 0
end

@testset "Coverage reward" begin
    e = Episode(Grid(), reward=RoboGrid.coverage_reward)
    total_reward = run!(e, coverage_robot)
    println("Found exit in ", e.meta["step"], " steps, ", e.meta["t"], " s, ",
            e.meta["memory"], " bytes")
    ngreen = sum(map(c->RoboGrid.color(c) == "green", e.grid.cells))
    println("Covered $ngreen cells for $total_reward")
    @test total_reward > 1
    # @test abs(total_reward - ngreen) <= 1
end

