class InitializeSuiteCaseOrder
  def self.run
    Suite.find_each do |suite|
      suite.suite_test_cases.joins(:test_case).order("test_cases.name").select("suites_test_cases.*").each do |stc|
        stc.sort_order_position = :last
        stc.save!
      end
    end
  end
end
