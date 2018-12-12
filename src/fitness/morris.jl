function morris_map(r::MersenneTwister)
    w = 7; h = 7
    map = Dict{String, Any}("height" => h, "width"  => w)
    sx, sy = rand(r, [(1, 1), (1, w), (h, 1), (h, w)])
    map["starts"] = [Dict("x"=>sx, "y"=>sy)]
    map
end

function morris_meta()
    Dict{String, Any}("max_step" => 500)
end

function cov_terminate(e::Episode)
    terminate(e) || all(map(c->object(c) == "empty", e.grid.cells))
end

function coverage_fitness(cont_f::Function; seed::Int64=0)
    r = MersenneTwister(seed)
    map = morris_map(r)
    g = Grid(map)
    for c in g.cells
        c.obj = type_to_float("food")
    end
    e = Episode(g; reward=food_reward, meta=morris_meta())
    total_reward = run!(e, cont_f; terminate=cov_terminate)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    (total_reward + (1.0 - steps / e.meta["max_step"])) / (length(e.grid.cells) + 1)
end

function food_exit_map(seed::Int64=0)
    r = MersenneTwister(seed)
    map = morris_map(r)
    ex, ey = rand(r, 3:5), rand(r, 3:5)
    map["exits"] = [Dict("x"=>ex, "y"=>ey)]
    map["objects"] = [Dict("type"=>"food", "color"=>"orange", "x"=>ex, "y"=>ey)]
    map
end

function find_exit_fitness(cont_f::Function; seed::Int64=0)
    e = Episode(Grid(food_exit_map(seed)); reward=food_reward, meta=morris_meta())
    run!(e, cont_f)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    1 - steps / e.meta["max_step"]
end

function memorize_exit_fitness(cont_f::Function; seed::Int64=0)
    for i in 1:3
        map = food_exit_map(seed)
        e = Episode(Grid(map); reward=food_reward, meta=morris_meta())
        run!(e, cont_f)
        if terminate(e)
            return i / 6
        end
    end
    map = food_exit_map(seed)
    delete!(map, "objects")
    e = Episode(Grid(map); meta=morris_meta())
    run!(e, cont_f)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    (6 - steps / e.meta["max_step"]) / 6
end
