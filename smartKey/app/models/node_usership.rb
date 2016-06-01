class NodeUsership < ActiveRecord::Base
    belongs_to :node
    belongs_to :user
end
