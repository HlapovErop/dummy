class Request < ApplicationRecord
  belongs_to :user

  enum state: %i[unprocessed confirmed rejected]

  after_initialize :set_default_state, if: :new_record?

  def set_default_state
    self.state = 'unprocessed'
  end
end
