class Channel < ActiveRecord::Base

    PROMPT = TTY::Prompt.new

    has_many :users
    has_many :messages

    def display_messages
        puts "                         #{self.name}                                   "
        puts "================================================================"
        messages = self.messages
        if messages.length > 0 then
            messages.each do |message|

                puts "#{message.user.username}: #{message.content}"
                display_reactions(message)
            end
        else
            puts "This is a brand new channel, create the first message."
        end
        puts "================================================================"
    end
    
    def self.display_channels
        choice_hash = {}
        self.all.each_with_index do |channel, index|
            if !(channel.masked) then
                value = "#{channel.name}"
                choice_hash[value] = index
            end
        end
        new_channel = "Make a new channel"
        go_back =  "Go Back"
        choice_hash[new_channel] = self.all.length + 1
        choice_hash[go_back] = self.all.length + 2

        PROMPT.select("Global Channels", choice_hash)

    end
    
    private

    def display_reactions(message)
        reactions = message.reactions
        reactions.each do |reaction|
            print "#{reaction.emoji}||"
        end
        puts
    end

end