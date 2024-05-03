class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :requests, dependent: :destroy

  devise :database_authenticatable, :registerable, :recoverable, :jwt_authenticatable, jwt_revocation_strategy: self, authentication_keys: [:username]

  enum role: %i[user admin]

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  after_initialize :set_default_role, if: :new_record?
  # set default role to user  if not set
  def set_default_role
    self.role ||= :user
  end
end