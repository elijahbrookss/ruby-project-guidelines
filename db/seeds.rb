
Message.destroy_all
Channel.destroy_all

main_chat = Channel.create
developer_chat = Channel.create
game_chat = Channel.create
coding_chat = Channel.create
movie_chat = Channel.create

User.create(username: "elijah")