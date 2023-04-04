module MatterBots

using ChatThemAll
using HTTP
using JSON

export listen_for_message

export MatterBot, matter_bot

include("api.jl")



struct MatterBot <: ChatThemAll.AbstractBot
    name::String
    token::String
    url::String
    channels::Dict{String,String}
    api_version::String
end

function matter_bot(name, token, url, channels, api_version="v4")
    return MatterBot(name, token, url, channels, api_version)
end

const CHANNELS = Dict([
    "integrations" => "dchg59qoi7nazebnms3q6j3azh",
])

function api_request(bot, method, endpoint, data=nothing)
    headers = [
        "Authorization" => "Bearer $(token(bot))",
        "Content-Type" => "application/json"
    ]
    request_endpoint = "$(ChatThemAll.api_endpoint(bot))/$(endpoint)"
    if data !== nothing
        response = HTTP.request(method, request_endpoint, headers, JSON.json(data))
    else
        response = HTTP.request(method, request_endpoint, headers)
    end
    return JSON.parse(String(response.body))
end


function send_message(
    bot::MatterBot,
    channel_id,
    message;
    root_id="",
    file_ids=[],
    props=Dict()
)
    data = Dict(
        "channel_id" => channel_id,
        "message" => message,
        "root_id" => root_id,
        "file_ids" => file_ids,
        "props" => props,
    )
    return api_request(bot, "POST", "posts", data)
end

function listen_for_messages(bot::MatterBot, channel_id)
    last_post_id = ""
    while true
        response = api_request(bot, "GET", "channels/$channel_id/posts")
        posts = response["posts"]

        for (post_id, post) in posts
            if post_id != last_post_id
                last_post_id = post_id
                user_id = post["user_id"]
                message = post["message"]

                if user_id != "matterbot_jl"  # Replace with your bot's user ID to avoid responding to itself
                    println("Received message: $message")

                    # Add your message handling logic here
                    if lowercase(message) == "hello"
                        send_message(bot, post["channel_id"], "Hello! How can I help you? (sorry for the spam, I'm pretty dumb right now))")
                    end
                end
            end
        end

        sleep(5)  # Poll the API every 5 seconds
    end
end

include("users.jl")

end
