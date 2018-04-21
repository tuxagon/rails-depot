class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validate :old_password_authenticates, on: :update
  has_secure_password
  after_destroy :ensure_an_admin_remains

  attr_accessor :old_password

  class Error < StandardError
  end

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "Can't delete the last user"
      end
    end

    def old_password_authenticates
      unless try(:authenticate, old_password)
        errors.add(:old_password, "is incorrect")
      end
    end
end
