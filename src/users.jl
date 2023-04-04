module Users

using ..MatterBots

function login(
    bot::MatterBot;
    id::String,
    login_id::String,
    token::String,
    device_id::String,
    ldap_only::Bool=true,
    password::String
)
    data = Dict(
        "id" => id,
        "login_id" => login_id,
        "token" => token,
        "device_id" => device_id,
        "ldap_only" => ldap_only,
        "password" => password,
    )

    endpoint = "/users/login"

    return api_request(bot, "POST", endpoint, data)
end

end # module Users
