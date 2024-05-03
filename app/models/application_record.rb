class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  default_scope -> { where(deleted_at: nil) }

end
