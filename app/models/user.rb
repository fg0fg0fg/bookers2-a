class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  #フォローする人(User)->relationshipsを持っている紐づけはfollower_id
  #フォローされる人(User)->relationshipsを持っている紐づけはfollowed_id
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  #自身がフォローしている全ユーザー,モデルを通して,followedを参照
  #自身をフォローしている全ユーザー
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def self.looks(search, word)
    if search == "perfect"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward"
      @user = User.where("name LIKE?", "#{word}%")
    elsif search == "backward"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "partial"
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end
end
