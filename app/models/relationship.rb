class Relationship < ApplicationRecord

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  #Relationshipはfollower(User)に属する
  #Relationshipはfollowed(User)に属する
end
