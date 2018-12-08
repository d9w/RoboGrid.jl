function test_episode(e::Episode, controller::Function)
    for i in 1:10
        inputs = get_inputs(e)
        @test length(inputs) == 18
        @test all(inputs .>= 0.0)
        @test all(inputs .<= 1.0)
        output = controller(inputs)
        println(RoboGrid.ACTIONS[output])
        @time step!(e, output)
        @test e.robot.y >= 1
        @test e.robot.y <= size(e.grid.cells, 1)
        @test e.robot.x >= 1
        @test e.robot.x <= size(e.grid.cells, 2)
    end
end

@testset "Random controller" begin
    e = Episode(Grid())
    c(x::Array{Float64}) = rand(1:length(RoboGrid.ACTIONS))
    test_episode(e, c)
end

@testset "Run and terminate" begin
    e = Episode(Grid())
    c(x::Array{Float64}) = rand(1:length(RoboGrid.ACTIONS))
    terminate(e::Episode) = RoboGrid.terminate(e; steps=10)
    total_reward = run!(e, c; terminate=terminate)
    @test total_reward == 0.0
    @test e.meta["step"] <= 10
    @test e.meta["t"] <= 10.0
    @test e.meta["memory"] <= 1073741824
end
