module ApplicationHelper
  def fix_url(str)
    str.starts_with?('http://') ? str : "http://#{str}"
  end

  def timestamp(datetime)
     datetime.strftime("%m/%d/%Y at %I:%M %p")
  end
end
