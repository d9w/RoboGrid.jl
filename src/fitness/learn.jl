function learn_fitness(cont_f::Function, map_f::Function, meta_f::Function;
                       neps::Int64=6)
    steps = Array{Int64}(undef, neps)
    max_step = -Inf
    for i in 1:neps
        e = Episode(Grid(map_f()); reward=food_reward, meta=meta_f())
        run!(e, cont_f)
        if terminate(e)
            if i == 1
                return Float64(-neps)
            else
                return Float64(i - neps - steps[i-1] / e.meta["max_step"])
            end
        end
        steps[i] = e.meta["step"]
        max_step = e.meta["max_step"]
    end
    (steps[1] - steps[neps]) / max_step
end
