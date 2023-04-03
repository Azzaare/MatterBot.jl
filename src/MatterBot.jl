module MatterBot

using HTTP
using JSON

export listen_for_messages

const MATTERMOST_URL = ENV["MATTERBOT_URL"]
const API_VERSION = "v4"
const API_ENDPOINT = "$(MATTERMOST_URL)/api/$(API_VERSION)"
const BOT_TOKEN = ENV["MATTERBOT_TOKEN"]

const CHANNELS = Dict([
    "integrations" => "dchg59qoi7nazebnms3q6j3azh",
])

function api_request(method, endpoint, data=nothing)
    headers = [
        "Authorization" => "Bearer $(BOT_TOKEN)",
        "Content-Type" => "application/json"
    ]
    if data !== nothing
        response = HTTP.request(method, "$(API_ENDPOINT)/$(endpoint)", headers, JSON.json(data))
    else
        response = HTTP.request(method, "$(API_ENDPOINT)/$(endpoint)", headers)
    end
    return JSON.parse(String(response.body))
end


function send_message(channel_id, message)
    data = Dict(
        "channel_id" => channel_id,
        "message" => message,
        "root_id" => "",
        "file_ids" => [],
        "props" => Dict()
    )
    return api_request("POST", "posts", data)
end

function listen_for_messages()
    last_post_id = ""
    while true
        response = api_request("GET", "channels/$(CHANNELS["integrations"])/posts")
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
                        send_message(post["channel_id"], "Hello! How can I help you?")
                    end
                end
            end
        end

        sleep(5)  # Poll the API every 5 seconds
    end
end


end
