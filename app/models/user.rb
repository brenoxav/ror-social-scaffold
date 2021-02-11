class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :submitted_friendships, foreign_key: 'submitter_id', class_name: 'Friendships'
  has_many :received_friendships, foreign_key: 'receiver_id', class_name: 'Friendships'

  #has_many :submitted_friendships, ->(user) { where(submitter_id: :user_id) }, foreign_key: 'submitter_id', class_name: 'Friendships'
  #has_many :received_friendships, ->(user) { where(receiver_id: :user_id) }, foreign_key: 'submitter_id', class_name: 'Friendships'
  #has_many :friendships, -> { where("submitter_id = ? OR receiver_id = ?", id, id) }
  #has_many :friendships

  def friends
    Friendship.where(submitter_id: id, status: true).pluck(:receiver_id) + Friendship.where(receiver_id: id, status: true).pluck(:submitter_id)
  end

  def submit_friendship(receiver_id)
    Friendship.create(submitter_id: self.id, receiver_id: receiver_id)
  end

  def abort_friendship(receiver_id)
    Friendship.where(submitter_id: self.id).and(Friendship.where(receiver_id: receiver_id)).destroy
  end

  def accept_friendship(submitter_id)
    Friendship.where(submitter_id: submitter_id).and(Friendship.where(receiver_id: self.id)).update(status: true)
  end

  def reject_friendship(submitter_id)
    Friendship.where(submitter_id: submitter_id).and(Friendship.where(receiver_id: self.id)).destroy
  end

end
