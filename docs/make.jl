using MatterBot
using Documenter

DocMeta.setdocmeta!(MatterBot, :DocTestSetup, :(using MatterBot); recursive=true)

makedocs(;
    modules=[MatterBot],
    authors="azzaare <jf@baffier.fr> and contributors",
    repo="https://github.com/Azzaare/MatterBot.jl/blob/{commit}{path}#{line}",
    sitename="MatterBot.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Azzaare.github.io/MatterBot.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Azzaare/MatterBot.jl",
    devbranch="main",
)
