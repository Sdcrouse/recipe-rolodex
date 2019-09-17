class User < ActiveRecord::Base
  has_secure_password
  has_many :recipes

  # Credit for the format idea goes to Ayana Zaire and https://stackoverflow.com/questions/18281198/rails-validate-no-white-space-in-user-name#answer-18281988
  validates :username, presence: true, uniqueness: true, format: { without: /[\W]+/, 
    message: "should only contain letters, numbers, and underscores (_)" }

  # Credit for the URI::MailTo::EMAIL_REGEXP idea goes to https://stackoverflow.com/questions/38611405/how-to-do-email-validation-in-ruby-on-rails#answer-49925333
  validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}
end