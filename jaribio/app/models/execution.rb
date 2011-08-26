class Execution < ActiveRecord::Base
  belongs_to :user
  belongs_to :execution, :polymorphic => true
end
