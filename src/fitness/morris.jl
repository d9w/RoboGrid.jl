morris_map = Dict("height" => 10, "width"  => 10, "starts" => [Dict("x"=>5,"y"=>10)])
morris_meta = Dict{String, Any}("max_step" => 500)

function coverage_fitness(cont_f::Function; seed::Int64=0)
    e = Episode(Grid(morris_map); reward=coverage_reward, meta=morris_meta)
    cov_terminate(e::Episode) = terminate(e) || all(e.meta["visited"])
    run!(e, cont_f; terminate=cov_terminate)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    -steps
end

function food_exit_map(seed::Int64=0)
    r = MersenneTwister(seed)
    ex, ey = rand(r, 1:10), rand(r, 1:4)
    map = morris_map
    map["exits"] = [Dict("x"=>ex, "y"=>ey)]
    map["objects"] = [Dict("type"=>"food", "color"=>"orange", "x"=>ex, "y"=>ey)]
    map
end

function find_exit_fitness(cont_f::Function; seed::Int64=0)
    e = Episode(Grid(food_exit_map(seed)); reward=food_reward, meta=morris_meta)
    run!(e, cont_f)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    -steps
end

function memorize_exit_fitness(cont_f::Function; seed::Int64=0)
    map = food_exit_map(seed)
    for i in 1:5
        e = Episode(Grid(map); reward=food_reward, meta=morris_meta)
        run!(e, cont_f)
        if terminate(e)
            return -((6 - i) * e.meta["max_step"])
        end
    end
    delete!(map, "objects")
    e = Episode(Grid(map); meta=morris_meta)
    run!(e, cont_f)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    -steps
end
