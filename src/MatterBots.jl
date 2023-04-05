module MatterBots

using ChatThemAll
using HTTP
using JSON
using MatterMost
using OpenAPI
using OpenAPI.Clients

import OpenAPI.Clients: Client, set_header

export listen_for_messages

export MatterBot

include("utils.jl")
include("bot.jl")

# function handle_message(message)
#     if startswith(message, "/")
#         # Add your custom message handling logic here
#         println("Received command: ", message)
#     end
# end

function process_message(message::String)
    if startswith(message, "/")
        # Parse and execute the command
        println("Received command: ", message[2:end])
    end
end

function listen_for_messages(
    posts_api::MatterMost.PostsApi,
    channels_api::MatterMost.ChannelsApi,
    user_id::String,
    channel_id::String
)
    while true
        # @info "debug: incrementing loop" channel_id user_id
        posts_list, _ = get_posts_around_last_unread(posts_api, user_id, channel_id; limit_before=0)
        # @info posts_list fieldnames(typeof(posts_list))
        !isnothing(posts_list) && for (_, post) in posts_list.posts
            # @info post fieldnames(typeof(post))
            process_message(post.message)

            # Mark the channel as read
            channel_view_request = MatterMost.ViewChannelRequest(; channel_id)
            view_channel(channels_api, user_id, channel_view_request)
        end

        break
        sleep(5) # Wait for 5 seconds before checking for new messages
    end
end

# function listen_for_messages(api::MatterMost.PostsApi, channel_id::String)
#     last_post_id = ""

#     while true
#         # Use the MatterMost.jl generated function to fetch the channel's posts
#         posts, _ = get_posts_for_channel(api, channel_id, page=0, per_page=10, since=0)

#         for (id, post) in posts.posts
#             @info "debug" id post
#             if post.id != last_post_id && post.message != ""
#                 handle_message(post.message)
#                 last_post_id = post.id
#             end
#         end

#         sleep(5) # Polling interval
#     end
# end

# function listen_for_messages(bot::MatterBot, channel_id::String)
#     headers = Dict([
#         "Authorization" => "Bearer $(token(bot))",
#         "Content-Type" => "application/json"
#     ])
#     # Initialize MatterMost API context
#     client_context = Client(api_endpoint(bot); headers)
#     api = MatterMost.PostsApi(client_context)

#     # Call listen_for_messages with the appropriate channel_id
#     listen_for_messages(api, channel_id)
# end

function listen_for_messages(bot::MatterBot)
    # Initialize Mattermost API client
    headers = Dict(
        "Authorization" => "Bearer $(token(bot))",
        "Content-Type" => "application/json"
    )
    client = Client(api_endpoint(bot); headers)
    channels_api = MatterMost.ChannelsApi(client)
    posts_api = MatterMost.PostsApi(client)

    # Get the bot user's ID
    bot_user_id = bot_id(bot)

    # Get the list of accessible channels
    # channels, _ = get_channels_for_user(channels_api, "me")
    channels, _ = get_all_channels(channels_api)

    # Start listening to each channel
    for channel in channels
        # @info "debug: listening to channel" channel
        listen_for_messages(posts_api, channels_api, bot_user_id, channel.id)
    end
end

end
