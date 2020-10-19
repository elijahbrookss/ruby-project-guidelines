
User.destroy_all
Message.destroy_all
Reaction.destroy_all
Channel.destroy_all

main_chat = Channel.create

user1 = User.create(username: "random", channel_id: main_chat.id)
user2 = User.create(username: "random_2", channel_id: main_chat.id)


message1 = Message.create(content: "Hello World!", user_id: user1.id, channel_id: main_chat.id)
message2 = Message.create(content: "Bye World!", user_id: user2.id, channel_id: main_chat.id)

Reaction.create(emoji: ":)", user_id: user1.id, message_id: message2.id)


