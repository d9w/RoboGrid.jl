function test_episode(e::Episode, controller::Function)
    for i in 1:10
        inputs = get_inputs(e)
        @test length(inputs) == 10
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

@testset "Inputs" begin
    g = Grid("maps/empty.yaml")
    e = Episode(g)
    obj = rand()
    g.cells[e.robot.y, e.robot.x].obj = obj
    inputs = get_inputs(e)
    orig_inputs = copy(inputs)
    @test inputs[1] == 0.0
    @test inputs[3] == RoboGrid.type_to_float("wall")
    @test inputs[6] == obj
    RoboGrid.turn_left!(e.robot)
    inputs = get_inputs(e)
    @test inputs[1] == 0.0
    @test inputs[3] == RoboGrid.type_to_float("wall")
    @test inputs[6] == obj
    RoboGrid.turn_left!(e.robot)
    inputs = get_inputs(e)
    @test inputs[1] == 0.0
    @test inputs[3] == RoboGrid.type_to_float("empty")
    @test inputs[6] == obj
    RoboGrid.turn_left!(e.robot)
    inputs = get_inputs(e)
    @test inputs[1] == 0.0
    @test inputs[3] == RoboGrid.type_to_float("empty")
    @test inputs[6] == obj
    RoboGrid.turn_left!(e.robot)
    inputs = get_inputs(e)
    @test all(inputs .== orig_inputs)
end

@testset "Random controller" begin
    e = Episode(Grid())
    c(x::Array{Float64}) = rand(1:length(RoboGrid.ACTIONS))
    test_episode(e, c)
end

@testset "Run and terminate" begin
    e = Episode(Grid(); meta=Dict{String, Any}("max_step"=>10))
    c(x::Array{Float64}) = rand(1:length(RoboGrid.ACTIONS))
    total_reward = run!(e, c)
    @test total_reward == 0.0
    @test e.meta["step"] <= e.meta["max_step"]
    @test e.meta["time"] <= e.meta["max_time"]
    @test e.meta["memory"] <= e.meta["max_memory"]
end
