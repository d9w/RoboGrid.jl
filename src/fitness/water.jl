function water_map(r::MersenneTwister)
    w = 5; h = 5
    map = Dict{String, Any}("height" => h, "width"  => w)
    sx, sy = rand(r, [(1, 1), (1, w), (h, 1), (h, w)])
    map["starts"] = [Dict("x"=>sx, "y"=>sy)]
    map
end

function water_meta()
    Dict{String, Any}("max_step" => 100)
end

function cov_terminate(e::Episode)
    terminate(e) || all(map(c->object(c) == "empty", e.grid.cells))
end

function coverage_fitness(cont_f::Function; seed::Int64=0)
    r = MersenneTwister(seed)
    map = water_map(r)
    g = Grid(map)
    for c in g.cells
        c.obj = type_to_float("food")
        c.color = color_to_float("green")
    end
    e = Episode(g; reward=food_reward, meta=water_meta())
    total_reward = run!(e, cont_f; terminate=cov_terminate)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    (total_reward + (1.0 - steps / e.meta["max_step"])) / (length(e.grid.cells) + 1)
end

function food_exit_map(seed::Int64=0)
    r = MersenneTwister(seed)
    map = water_map(r)
    ex, ey = rand(r, 2:4), rand(r, 2:4)
    map["exits"] = [Dict("x"=>ex, "y"=>ey)]
    map["objects"] = [Dict("type"=>"food", "color"=>"green", "x"=>ex, "y"=>ey)]
    map
end

function water_search_fitness(cont_f::Function; seed::Int64=0)
    e = Episode(Grid(food_exit_map(seed)); reward=food_reward, meta=water_meta())
    run!(e, cont_f)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    1 - steps / e.meta["max_step"]
end

function water_memorize_fitness(cont_f::Function; seed::Int64=0)
    map_function() = food_exit_map(seed)
    learn_fitness(cont_f, map_function, water_meta)
end
