# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  email               :string           not null
#  encrypted_password  :string           not null
#  remember_created_at :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :rememberable, :validatable
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { in: 8..20 }

  has_many :movies, dependent: :destroy, inverse_of: :user
  has_many :votes, dependent: :destroy, inverse_of: :user
end
