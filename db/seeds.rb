
Message.destroy_all
Channel.destroy_all
User.destroy_all
Reaction.destroy_all
Friend.destroy_all
Direct_Channel.destroy_all


Channel.create(name: "Main Chat")

User.create(username: "user1", password: "abc123")
User.create(username: "user2", password: "abc123")
