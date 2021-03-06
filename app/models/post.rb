class Post < ApplicationRecord
	belongs_to :user
	has_many :post_comments, dependent: :destroy

	has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def create_notification_favorite!(current_user)
    # whereでいいねされているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
      #valid?はエラーなしでtrue、エラーありでfalseになるメソッド
    end
  end

  def create_notification_post_comment!(current_user, post_comment_id)
    # コメントしている人をすべて取得、where.not(user_id: current_user.id)で自分を除外。全員に通知を送る
    #selectしてdistinctで重複を解消
    temp_ids = PostComment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_post_comment!(current_user, post_comment_id, temp_id['user_id'])
    end
    # 誰もコメントしていない時、投稿者に通知
    #後置ifでも可能
    save_notification_post_comment!(current_user, post_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_post_comment!(current_user, post_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      post_comment_id: post_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end
