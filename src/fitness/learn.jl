function learn_fitness(cont_f::Function, map_f::Function, meta_f::Function)
    steps = Array{Int64}(undef, 6)
    max_step = -Inf
    for i in 1:6
        e = Episode(Grid(map_f()); reward=food_reward, meta=meta_f())
        run!(e, cont_f)
        if terminate(e)
            return i - 7.0
        end
        steps[i] = e.meta["step"]
        max_step = e.meta["max_step"]
    end
    (steps[1] - steps[6]) / max_step
end
