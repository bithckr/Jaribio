module ApplicationHelper
  def status_helper(status)
    case status
    when Status::PASS
      "status pass"
    when Status::FAIL
      "status fail"
    else
      "status unknown"
    end
  end
end
