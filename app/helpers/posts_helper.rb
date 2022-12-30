module PostsHelper
  def display_date_time(time)
    elapsed_seconds = (Time.now - time).seconds
    if elapsed_seconds < 60
      "#{elapsed_seconds.round} seconds ago"
    elsif elapsed_seconds < 3600
      "#{(elapsed_seconds / 60).round} minutes ago"
    elsif time.today?
      "Today @  #{time.strftime('%k %M %p')}"
    else
      "#{time.strftime('%b %e')} @ #{time.strftime('%k %M %p')}"
    end
  end
end
