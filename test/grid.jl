function test_grid(g::Grid)
    for c in g.cells
        @test c.obj <= 1.0
        @test c.obj >= 0.0
        @test c.color <= 1.0
        @test c.color >= 0.0
    end
    for s in g.starts
        @test s >= 1
        @test s <= length(g.cells)
    end
    for e in g.exits
        @test e >= 1
        @test e <= length(g.cells)
    end
end

@testset "Empty grid" begin
    g = Grid("maps/default.yaml")
    test_grid(g)
end

@testset "Default grid" begin
    g = Grid("maps/default.yaml")
    test_grid(g)
end

@testset "T-maze grid" begin
    g = Grid("maps/tmaze.yaml")
    test_grid(g)
    nfood = 0
    for c in g.cells
        if RoboGrid.object(c) == "food"
            nfood += 1
        end
    end
    @test nfood == 2
end
