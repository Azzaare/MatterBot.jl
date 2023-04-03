using MatterBots
using Documenter

DocMeta.setdocmeta!(MatterBots, :DocTestSetup, :(using MatterBots); recursive=true)

makedocs(;
    modules=[MatterBots],
    authors="azzaare <jf@baffier.fr> and contributors",
    repo="https://github.com/Azzaare/MatterBots.jl/blob/{commit}{path}#{line}",
    sitename="MatterBots.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Azzaare.github.io/MatterBots.jl",
        edit_link="main",
        assets=String[]
    ),
    pages=[
        "Home" => "index.md",
    ]
)

deploydocs(;
    repo="github.com/Azzaare/MatterBots.jl",
    devbranch="main"
)
