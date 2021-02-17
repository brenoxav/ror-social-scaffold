module ApplicationHelper
  def menu_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'menu-item active' : 'menu-item'

    content_tag(:div, class: class_name) do
      link_to link_text, link_path
    end
  end

  def like_or_dislike_btn(post)
    like = Like.find_by(post: post, user: current_user)
    if like
      link_to('Dislike!', post_like_path(id: like.id, post_id: post.id), method: :delete)
    else
      link_to('Like!', post_likes_path(post_id: post.id), method: :post)
    end
  end

  def add_friend_btn(receiver)
    submitter = User.find(current_user.id)
    if submitter == receiver
      button_to 'You', user_path(submitter.id), method: :get, disabled: true
    elsif submitter.friend?(receiver)
      button_to 'Unfriend', friendship_path(1), method: :delete,
                                                params: { submitter_id: submitter.id, receiver_id: receiver.id }
    elsif submitter.pending_submissions.select { |s| s.receiver == receiver }.any?
      button_to 'Cancel', friendship_path(1), method: :delete,
                                              params: { submitter_id: submitter.id, receiver_id: receiver.id }
    elsif submitter.pending_receipts.select { |s| s.submitter == receiver }.any?
      button_to 'Accept', friendship_path(1), method: :patch,
                                              params: { submitter_id: submitter.id, receiver_id: receiver.id }
    else
      button_to '+ Friend', friendships_path, params: { submitter_id: submitter.id, receiver_id: receiver.id }
    end
  end
end
