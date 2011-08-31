class Execution < ActiveRecord::Base
  belongs_to :user
  belongs_to :executable, :polymorphic => true
end
