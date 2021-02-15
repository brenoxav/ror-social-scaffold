class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :submitted_friendships, foreign_key: 'submitter_id', class_name: 'Friendship'
  has_many :received_friendships, foreign_key: 'receiver_id', class_name: 'Friendship'

  # Return an array with all confirmed friends (submitted and received)
  def friends
    s = submitted_friendships.map { |f| f.receiver if f.status }
    r = received_friendships.map { |f| f.submitter if f.status }
    (s + r).compact
  end

  def friendships
    s = submitted_friendships
    r = received_friendships
    (s + r)
  end

  def pending_submissions
    submitted_friendships.select { |f| f.submitter if !f.status }
  end

  def pending_receipts
    received_friendships.select { |f| f.receiver if !f.status }
  end

  def confirm_friend(submitter)
    friendship = received_friendships.find{ |f| f.submitter == submitter }
    friendship.status = true
    friendship.save
  end

  def friend?(user)
    friends.include?(user)
  end
end
