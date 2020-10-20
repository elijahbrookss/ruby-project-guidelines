class Channel < ActiveRecord::Base
    has_many :users
    has_many :messages

    def display_messages
        messages = self.messages
        if messages.length > 0 then
            messages.each do |message|
                puts "#{message.user.username}: #{message.content}"
                display_reactions(message)
            end
        else
            puts "This is a brand new channel! Input something to change"
        end

    end
    
    def self.display_channels
        self.all.each do |channel|
            puts channel.id
        end
    end
    
    private

    def display_reactions(message)
        reactions = message.reactions
        reactions.each do |reaction|
            print "#{reaction.emoji} "
        end
        puts
    end

end