using ArgParse
using YAML
using Distributed

@everywhere include("evo/robo.jl")
@everywhere r(i::Individual) = robo_eval(i, 19, length(RoboGrid.ACTIONS))

s = ArgParse.ArgParseSettings()

ArgParse.@add_arg_table(
    s,
    "--seed", arg_type=Int, default=0,
    "--id", arg_type=String, default="test",
    "--log", arg_type=String, default="evolution.log",
    "--cfg", arg_type=String, default="cfg/darwin.yaml",
)

args = ArgParse.parse_args(s)
cfg = YAML.load_file(args["cfg"])
cfg["seed"] = args["seed"]
cfg["n_fitness"] = 1
cfg["nin"] = 19
cfg["nout"] = length(RoboGrid.ACTIONS)

e = Evolution(CGPInd, cfg; id=args["id"], logfile=args["log"])
e.evaluation = r
e.generation = generation
Darwin.run!(e)
