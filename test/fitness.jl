function test_fitness(fitness::Function, cont_f::Function; minfit::Int64=-500)
    fit = fitness(cont_f; seed=0)
    @test fit <= -1
    @test fit >= minfit
    fit2, t, bytes, gctime, memallocs = @timed fitness(cont_f; seed=1234)
    println("Fitness of $fit2 in $t s, $bytes bytes")
    @test fit2 <= -1
    @test fit2 >= minfit
end

rand_cont(x::Array{Float64}) = rand(1:4)

@testset "Coverage fitness" begin
    test_fitness(RoboGrid.coverage_fitness, rand_cont)
end

@testset "Find exit fitness" begin
    test_fitness(RoboGrid.find_exit_fitness, rand_cont)
end

@testset "Memorize exit" begin
    test_fitness(RoboGrid.memorize_exit_fitness, rand_cont; minfit=-2500)
end
