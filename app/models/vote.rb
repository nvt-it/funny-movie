# == Schema Information
#
# Table name: votes
#
#  id         :bigint           unsigned, not null, primary key
#  user_id    :bigint           not null
#  movie_id   :bigint           not null
#  vote_type  :integer          default("up"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Vote < ApplicationRecord
  belongs_to :movie, inverse_of: :votes
  belongs_to :user, inverse_of: :votes

  counter_culture :movie, column_name: proc {|model| model.up? ? 'vote_ups_count' : 'vote_downs_count' }

  enum vote_type: ['up', 'down']

  validates :movie_id, uniqueness: { scope: :user_id, message: 'has been voted' }
end
