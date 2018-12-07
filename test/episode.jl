function test_episode(e::Episode, controller::Function)
    for i in 1:10
        inputs = get_inputs(e)
        @test length(inputs) == 18
        @test all(inputs .>= 0.0)
        @test all(inputs .<= 1.0)
        step!(e, controller(inputs))
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
