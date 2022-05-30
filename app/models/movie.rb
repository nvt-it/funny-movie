# == Schema Information
#
# Table name: movies
#
#  id               :bigint           not null, primary key
#  user_id          :bigint           not null
#  title            :string           not null
#  description      :text
#  thumb_url        :string           not null
#  video_id         :string           not null
#  vote_downs_count :bigint           default(0), not null
#  vote_ups_count   :bigint           default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Movie < ApplicationRecord
  validates_presence_of :title, :thumb_url
  validates :video_id, presence: true, uniqueness: true

  belongs_to :user, inverse_of: :movies
  has_many :votes, dependent: :destroy, inverse_of: :movie

  def embed_url
    "https://www.youtube.com/embed/#{video_id}?autoplay=0&amp;cc_load_policy=1&amp;controls=2&amp;hl=vi&amp;rel=0&amp;enablejsapi=1&amp;widgetid=1"
  end

  def is_voted_by?(user_id)
    return false if user_id.blank?

    votes.find_by(user_id: user_id).present?
  end
end
