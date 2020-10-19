class User < ActiveRecord::Base
    has_many :messages
    has_many :reactions
    belongs_to :channel
end
