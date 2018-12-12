function test_fitness(fitness::Function, cont_f::Function;
                      maxfit::Float64=1.0, minfit::Float64=0.0)
    fit = fitness(cont_f; seed=0)
    @test fit <= maxfit
    @test fit >= minfit
    fit2, t, bytes, gctime, memallocs = @timed fitness(cont_f; seed=1234)
    println("Fitness of $fit2 in $t s, $bytes bytes")
    @test fit2 <= maxfit
    @test fit2 >= minfit
end

rand_cont(x::Array{Float64}) = rand(1:4)

@testset "Coverage fitness" begin
    test_fitness(RoboGrid.coverage_fitness, rand_cont)
end

@testset "Water search fitness" begin
    test_fitness(RoboGrid.water_search_fitness, rand_cont)
end

@testset "Water memorize fitness" begin
    test_fitness(RoboGrid.water_memorize_fitness, rand_cont)
end

@testset "Cross search fitness" begin
    test_fitness(RoboGrid.cross_search_fitness, rand_cont)
end

@testset "Cross memorize fitness" begin
    test_fitness(RoboGrid.cross_memorize_fitness, rand_cont)
end

@testset "Cross strategy fitness" begin
    test_fitness(RoboGrid.cross_strategy_fitness, rand_cont)
end
