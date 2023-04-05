function Base.convert(::Type{Union{Nothing,Bool}}, x::String)
    return if x == "true"
        true
    elseif x == "false"
        false
    else
        nothing
    end
end

function OpenAPI.from_json(::Vector{MatterMost.PostMetadataImagesInner}, json::Dict{String,Any})
    # @warn "debug MatterMost.PostMetadataImagesInner" json
    X = Vector{MatterMost.PostMetadataImagesInner}()
    for value in values(json)
        x = PostMetadataImagesInner(;
            height=get(value, "height", nothing),
            width=get(value, "width", nothing)
        )
        push!(X, x)
    end
    return X
end
