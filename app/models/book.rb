class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  #has_many :favorited_users, througth: :favorites, source: :user
  #BookはFavoriteを通じてUserへの間接的に繋がる

  has_many :week_favorites, -> { where(create_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search ==  "perfect"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "forward"
      @book = Book.where("title LIKE?", "#{word}%")
    elsif search == "backward"
      @book = Book.where("title LIKE?", "%#{word}")
    elsif search == "partial"
      @book = Book.where("title LIKE?", "%#{word}")
    else
      @book = Book.all
    end
  end
end
