module ApplicationHelper
  def status_class_helper(status)
    case status
    when Status::PASS
      "pass"
    when Status::FAIL
      "fail"
    else
      "unknown"
    end
  end

  def status_text(status)
    case status
    when Status::PASS
      "PASS"
    when Status::FAIL
      "FAIL"
    else
      "UNKNOWN"
    end
  end

  def status_checked_helper(status, expected)
    if (status == expected)
      return true
    end
    false
  end

  def status_disabled_helper(status = Status::UNKNOWN)
    if (status == Status::UNKNOWN)
      return false
    end
    true
  end
end
