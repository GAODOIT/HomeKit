class Node < ActiveRecord::Base
    has_many :node_userships
    has_many :users, :through => :node_userships
end
