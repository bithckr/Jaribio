class Step < ActiveRecord::Base
  validates :position, :presence => true, :numericality => true
end
