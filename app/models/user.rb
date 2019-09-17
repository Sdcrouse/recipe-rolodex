class User < ActiveRecord::Base
  has_secure_password
  has_many :recipes

  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validates :email, presence: true
end