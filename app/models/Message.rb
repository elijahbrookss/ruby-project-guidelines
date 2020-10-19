class Message < ActiveRecord::Base
    belongs_to :user
    has_many :reactions
    belongs_to :channel
end
