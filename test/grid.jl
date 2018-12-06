function test_grid(g::Grid)
    for c in g.cells
        @test c.obj <= 1.0
        @test c.obj >= 0.0
        @test c.color <= 1.0
        @test c.color >= 0.0
        @test c.ostr in RoboGrid.OBJECT_TYPES
        @test c.reward <= 1.0
        @test c.reward >= 0.0
    end
    @test length(g.starts) > 0
    for s in g.starts
        @test s >= 1
        @test s <= length(g.cells)
    end
    @test length(g.exits) > 0
    for e in g.exits
        @test e >= 1
        @test e <= length(g.cells)
    end
end

@testset "T-maze grid" begin
    g = Grid()
    test_grid(g)
    nfood = 0
    reward = 0
    for c in g.cells
        if c.ostr == "food"
            nfood += 1
        end
        reward += c.reward
    end
    @test nfood == 2
    @test reward == 2.0
end
