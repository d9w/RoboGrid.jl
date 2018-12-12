@testset "Move" begin
    g = Grid("maps/empty.yaml")
    r = Robot()
    r.x = 3
    r.y = 3
    move!(r, g)
    @test r.x == 3
    @test r.y == 2
    move!(r, g; forward=false)
    @test r.x == 3
    @test r.y == 3
end

@testset "Rotate right" begin
    g = Grid("maps/empty.yaml")
    r = Robot()
    r.x = 2
    r.y = 2
    turn_right!(r)
    move!(r, g)
    @test r.x == 3
    @test r.y == 2
    turn_right!(r)
    move!(r, g)
    @test r.x == 3
    @test r.y == 3
    turn_right!(r)
    move!(r, g)
    @test r.x == 2
    @test r.y == 3
    turn_right!(r)
    move!(r, g)
    @test r.x == 2
    @test r.y == 2
end

@testset "Rotate left" begin
    g = Grid("maps/empty.yaml")
    r = Robot()
    r.x = 2
    r.y = 2
    turn_left!(r)
    move!(r, g)
    @test r.x == 1
    @test r.y == 2
    turn_left!(r)
    move!(r, g)
    @test r.x == 1
    @test r.y == 3
    turn_left!(r)
    move!(r, g)
    @test r.x == 2
    @test r.y == 3
    turn_left!(r)
    move!(r, g)
    @test r.x == 2
    @test r.y == 2
end

@testset "Boundaries" begin
    g = Grid("maps/empty.yaml")
    r = Robot()
    move!(r, g)
    @test r.x == 1
    @test r.y == 1
    turn_right!(r)
    r.x = size(g.cells, 2)
    move!(r, g)
    @test r.x == size(g.cells, 2)
    turn_right!(r)
    r.y = size(g.cells, 1)
    move!(r, g)
    @test r.y == size(g.cells, 1)
    turn_right!(r)
    r.x = 1
    move!(r, g)
    @test r.x == 1
end

@testset "Walls" begin
    g = Grid("maps/empty.yaml")
    r = Robot()
    r.x = 1
    r.y = 2
    g.cells[1, 1].obj = 1.0
    move!(r, g)
    @test r.x == 1
    @test r.y == 2
end
