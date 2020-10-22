
Message.destroy_all
Channel.destroy_all
User.destroy_all
Reaction.destroy_all
Friend.destroy_all
Direct_Channel.destroy_all


main_chat = Channel.create(name: "Main Chat")