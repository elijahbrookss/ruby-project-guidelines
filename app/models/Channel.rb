class Channel < ActiveRecord::Base
    has_many :users
    has_many :messages
    
    def display_messages
        messages = Message.where(channel_id: self.id)
        messages.each do |message|
            puts "#{message.user.username}: #{message.content}"
        end
    end
    
end