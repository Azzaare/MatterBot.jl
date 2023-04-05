struct MatterBot <: ChatThemAll.AbstractBot
    name::String
    token::String
    url::String
    channels::Dict{String,String}
    api_version::String

    function MatterBot(;
        name,
        token,
        url,
        channels=Dict{String,String}(),
        api_version="v4"
    )
        return new(name, token, url, channels, api_version)
    end
end

function bot_id(bot::MatterBot)
    # Initialize Mattermost API client
    headers = Dict(
        "Authorization" => "Bearer $(token(bot))",
        "Content-Type" => "application/json"
    )
    client = Client(api_endpoint(bot); headers)
    users_api = MatterMost.UsersApi(client)

    # Get the bot user's ID
    bot_user, _ = get_user(users_api, "me")

    return bot_user.id
end
