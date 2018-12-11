morris_map = Dict("height" => 10, "width"  => 10, "starts" => [Dict("x"=>5,"y"=>10)])
morris_meta = Dict{String, Any}("max_step" => 2000)

function coverage_fitness(cont_f::Function; seed::Int64=0)
    e = Episode(Grid(copy(morris_map)); reward=coverage_reward, meta=copy(morris_meta))
    cov_terminate(e::Episode) = terminate(e) || all(e.meta["visited"])
    total_reward = run!(e, cont_f; terminate=cov_terminate)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    total_reward + (1.0 - steps / e.meta["max_step"])
end

function food_exit_map(seed::Int64=0)
    r = MersenneTwister(seed)
    ex, ey = rand(r, 1:10), rand(r, 1:5)
    map = copy(morris_map)
    map["exits"] = [Dict("x"=>ex, "y"=>ey)]
    map["objects"] = [Dict("type"=>"food", "color"=>"orange", "x"=>ex, "y"=>ey)]
    map
end

function find_exit_fitness(cont_f::Function; seed::Int64=0)
    e = Episode(Grid(food_exit_map(seed)); reward=food_reward, meta=copy(morris_meta))
    run!(e, cont_f)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    1 - steps / e.meta["max_step"]
end

function memorize_exit_fitness(cont_f::Function; seed::Int64=0)
    map = food_exit_map(seed)
    for i in 1:5
        e = Episode(Grid(map); reward=food_reward, meta=copy(morris_meta))
        run!(e, cont_f)
        if terminate(e)
            return i
        end
    end
    delete!(map, "objects")
    e = Episode(Grid(map); meta=copy(morris_meta))
    run!(e, cont_f)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    6 - steps / e.meta["max_step"]
end