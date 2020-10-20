
Message.destroy_all
Channel.destroy_all

main_chat = Channel.create(name: "Main Chat")
developer_chat = Channel.create(name: "Developer Chat")
game_chat = Channel.create(name: "Game Chat")
coding_chat = Channel.create(name: "Coding Chat")
movie_chat = Channel.create(name: "Movie Chat")

User.create(username: "elijah")