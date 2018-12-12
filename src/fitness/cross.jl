function cross_map(r::MersenneTwister)
    map = YAML.load_file("maps/cross.yaml")
    exits = [(4, 1), (1, 4), (4, 7), (7, 4)]
    start = rand(r, exits)
    exit = rand(r, setdiff(exits, start))
    map["starts"] = [Dict("x"=>start[2], "y"=>start[1])]
    map["exits"] = [Dict("x"=>exit[2], "y"=>exit[1])]
    map
end

function cross_map(seed::Int64)
    r = MersenneTwister(seed)
    cross_map(r)
end

function cross_meta()
    Dict{String, Any}("max_step" => 500)
end

function cross_search_fitness(cont_f::Function; seed::Int64=0)
    e = Episode(Grid(cross_map(seed)); reward=food_reward, meta=cross_meta())
    run!(e, cont_f)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    1 - steps / e.meta["max_step"]
end

function cross_memorize_fitness(cont_f::Function; seed::Int64=0)
    for i in 1:5
        e = Episode(Grid(cross_map(seed)); reward=food_reward, meta=cross_meta())
        run!(e, cont_f)
        if terminate(e)
            return i / 6
        end
    end
    e = Episode(Grid(cross_map(seed)); reward=food_reward, meta=cross_meta())
    run!(e, cont_f)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    (6 - steps / e.meta["max_step"]) / 6
end

function cross_map(r::MersenneTwister, strategy::Int64)
    map = YAML.load_file("maps/cross.yaml")
    exits = [(4, 1), (1, 4), (4, 7), (7, 4)]
    si = rand(r, 1:4)
    start = exits[si]
    exit = exits[mod((si-1)+strategy, 4)+1]
    map["starts"] = [Dict("x"=>start[2], "y"=>start[1])]
    map["exits"] = [Dict("x"=>exit[2], "y"=>exit[1])]
    map
end

function cross_strategy_fitness(cont_f::Function; seed::Int64=0)
    r = MersenneTwister(seed)
    strategy = rand(r, 1:3)
    for i in 1:5
        e = Episode(Grid(cross_map(r, strategy));
                    reward=food_reward, meta=cross_meta())
        run!(e, cont_f)
        if terminate(e)
            return i / 6
        end
    end
    e = Episode(Grid(cross_map(r, strategy));
                reward=food_reward, meta=cross_meta())
    run!(e, cont_f)
    steps = terminate(e) ? e.meta["max_step"] : e.meta["step"]
    (6 - steps / e.meta["max_step"]) / 6
end
