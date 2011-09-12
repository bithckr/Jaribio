class Execution < ActiveRecord::Base
  belongs_to :user
  belongs_to :executable, :polymorphic => true

  validates_presence_of :status_code
end
