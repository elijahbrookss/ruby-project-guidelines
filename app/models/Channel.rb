class Channel < ActiveRecord::Base
    has_many :users
    has_many :messages

    def display_messages
        messages = self.messages
        messages.each do |message|
            puts "#{message.user.username}: #{message.content}"
            display_reactions(message)
        end
    end
    

    private

    def display_reactions(message)
        reactions = message.reactions
        reactions.each do |reaction|
            print "#{reaction.emoji}"
        end
        puts
    end

end