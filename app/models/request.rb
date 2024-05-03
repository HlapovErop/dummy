class Request < ApplicationRecord
  belongs_to :user

  enum state: %i[unprocessed confirmed rejected]

  after_create :set_default_state

  def set_default_state
    self.state = 'unprocessed'
  end
end
