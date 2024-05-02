class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :recoverable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: %i[user admin]
  after_initialize :set_default_role, if: :new_record?
  # set default role to user  if not set
  def set_default_role
    self.role ||= :user
  end
end