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

  # Copied from Rails 3.1
  def button_tag(label = "Button", options = {})
    options.stringify_keys!

    if disable_with = options.delete("disable_with")
      options["data-disable-with"] = disable_with
    end

    if confirm = options.delete("confirm")
      options["data-confirm"] = confirm
    end

    ["type", "name"].each do |option|
      options[option] = "button" unless options[option]
    end

    content_tag :button, label.to_s.html_safe, { "type" => options.delete("type") }.update(options)
  end
end
