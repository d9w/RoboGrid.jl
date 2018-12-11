using RoboGrid
using Darwin
using CGP
import Base.isless
import JSON.json

CGP.Config.init("cfg/cgp.yaml")

function robo_eval(ind::Individual, nin::Int64, nout::Int64)
    c = PCGPChromo(ind.genes, nin, nout)
    f(x::Array{Float64}) = process(c, x)
    [ind.func(f; seed=ind.seed)]
end

mutable struct CGPInd <: Individual
    genes::Array{Float64}
    fitness::Array{Float64}
    func::Function
    seed::Int64
end

isless(i1::CGPInd, i2::CGPInd) = i1.fitness[1] < i2.fitness[1]

function CGPInd(cfg::Dict)
    c = PCGPChromo(cfg["nin"], cfg["nout"])
    CGPInd(c.genes, [-Inf], RoboGrid.coverage_fitness, 1)
end

function CGPInd(genes::Array{Float64}, fitness::Array{Float64})
    CGPInd(genes, fitness, RoboGrid.coverage_fitness, 1)
end

function json(i::CGPInd)
    json(Dict("genes"=>i.genes, "fitness"=>i.fitness))
end

function generation(e::Evolution)
    for i in e.population
        i.seed = e.gen
        if e.gen > e.cfg["goal_gen"]
            i.func = RoboGrid.find_exit_fitness
        elseif e.gen > 2 * e.cfg["goal_gen"]
            i.func = RoboGrid.memorize_exit_fitness
        end
    end
end
