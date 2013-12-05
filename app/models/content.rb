require 'bcrypt'

class Content < ActiveRecord::Base
  
  validates :upload_file, presence: { message: 'ファイルを選択してください'}

  before_save { self.password = BCrypt::Password.create(password) }
end
