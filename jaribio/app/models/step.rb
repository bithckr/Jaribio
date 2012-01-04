class Step < ActiveRecord::Base
  belongs_to :test_casea

  include RankedModel
  ranks :sort_order, :with_same => :test_case_id
end
