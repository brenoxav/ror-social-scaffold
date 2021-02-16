class FriendshipsController < ApplicationController
  def create
    friendship = Friendship.new(friendship_params)
    if submitter.friend?(receiver)
      redirect_back(fallback_location: users_path, notice: "There's already a friendship request for this user!")
    elsif friendship.save
      redirect_back(fallback_location: users_path, notice: 'Friendship request sent successfully!')
    else
      redirect_back(fallback_location: users_path, notice: 'ERROR: Friendship request NOT sent!')
    end
  end

  def update
    if submitter.confirm_friend(receiver)
      redirect_back(fallback_location: users_path, notice: 'Friendship request accepted!')
    else
      redirect_back(fallback_location: users_path, notice: 'Friendship request denied!')
    end
  end

  def destroy
    friendships = submitter.friendships.select do |f|
      s = (submitter.id == f.submitter_id) && (receiver.id == f.receiver_id)
      r = (submitter.id == f.receiver_id) && (receiver.id == f.submitter_id)
      s || r
    end
    if friendships
      friendships.each(&:destroy)
      redirect_back(fallback_location: users_path, notice: 'Friendship canceled!')
    else
      redirect_back(fallback_location: users_path, notice: 'ERROR: Friendship status not changed.')
    end
  end

  private

  def friendship_params
    {
      submitter_id: params[:submitter_id],
      receiver_id: params[:receiver_id],
      status: false
    }
  end

  def submitter
    User.find(friendship_params[:submitter_id])
  end

  def receiver
    User.find(friendship_params[:receiver_id])
  end
end
