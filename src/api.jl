function read_mattermost_openapi(file_path)
    file_content = read(file_path, String)
    openapi_data = JSON.parse(file_content)
    return openapi_data
end

mattermost_openapi_filepath = "assets/openapi-v4.0.0.json"
const openapi_data = read_mattermost_openapi(mattermost_openapi_filepath)

# login_path = "/users/login"
# login_method = "post"
# login_request_body_schema = openapi_data["paths"][login_path][login_method]["requestBody"]["content"]["application/json"]["schema"]
# login_request_body_properties = login_request_body_schema["properties"]
# login_request_body_required_fields = login_request_body_schema["required"]

function camel_to_underscore_case(str)
    result = ""
    prev_char_whitespace = false
    for (i, c) in enumerate(str)
        if isspace(c)
            if !prev_char_whitespace && i > 1 && i < length(str)
                result *= "_"
            end
            prev_char_whitespace = true
        elseif c ∈ ['\'', '.']
            continue
        else
            result *= lowercase(string(c))
            prev_char_whitespace = false
        end
    end
    return result
end


function extract_request_body_schemas(openapi_data)
    paths = openapi_data["paths"]
    request_body_schemas = Dict{Symbol,Any}()

    for (path, methods) in paths
        for (method, operation) in methods
            if haskey(operation, "summary") && haskey(operation, "requestBody")
                summary_key = camel_to_underscore_case(operation["summary"])
                summary_symbol = Symbol(summary_key)

                if haskey(operation["requestBody"], "content") &&
                   haskey(operation["requestBody"]["content"], "application/json") &&
                   haskey(operation["requestBody"]["content"]["application/json"], "schema")
                    request_body_schema = operation["requestBody"]["content"]["application/json"]["schema"]
                    request_body_schemas[summary_symbol] = request_body_schema
                end
            end
        end
    end

    return request_body_schemas
end

# request_body_schemas = extract_request_body_schemas(openapi_data)

# request_body_schemas = MatterBots.extract_request_body_schemas(MatterBots.openapi_data)
