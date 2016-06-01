class User < ActiveRecord::Base
    validates_length_of :phone_num, :is => 11
    validates_format_of :phone_num, :with => %r{\A[1][358][0-9]{9}\Z}i
    validates_length_of :password, :in => 6..20  
    has_many :clients
    has_many :node_userships
    has_many :nodes, :through => :node_userships
end
