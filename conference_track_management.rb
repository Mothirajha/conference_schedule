class ConferenceTrackManagement

  attr_accessor :path, :proposals_with_time, :day, :track, :result, :daysession_starts_at,:noonsession_starts_at
  attr_reader :daysession, :noonsession, :lunch, :networking

  # Initialzie the required parameters
  def initialize 
    @proposals_with_time = Hash.new   # Get all proposals with the estimated time
    @result = Hash.new                # Store proposals that are organized as per session    
    @path = 'input.txt'               # Default filename
    @daysession = 180                 # 9am to 12 am(180mins)
    @noonsession = 240                # 1pm to max of 5pm(240mins)
    @track = 0                        # There can be multiple tracks available
    @lunch = "12:00PM Lunch"          # Lunch is always to the same
    @networking = "05:00PM Networking Event"
  end

  def get_time(hour)
    today = Time.now
    Time.new today.year, today.month, today.day, hour
  end

  # Read the file and get required details
  def read_file
    File.open(path, "r").each_line do |line|
      mins = (line.split(" ").last.strip == 'lightning') ? "5min" : line.split(" ").last.strip
      mins = mins.gsub(/[^\d]/,'')
      proposals_with_time[line.gsub(/\n/,'').strip] = mins.to_i
    end
  end

  def generate_proposals_timing
    while proposals_with_time.count != 0
      @track = track + 1
      pick_proposals(track)
    end
  end

  def pick_proposals(track)
    result["Track #{track}"] = pick_proposals_with_timing
  end

  def pick_proposals_with_timing
    timing = 0
    day = 0
    noon = 0
    proposals_for_session = Hash.new
    if proposals_with_time.count != 0
      proposals_with_time.each do |proposal, time|
        if (day+time) <= daysession
          proposals_for_session[:day] ||= []
          proposals_for_session[:day] << [proposal, time]
          proposals_with_time.delete(proposal)
          day = day + time
        elsif (noon + time) <= noonsession
          proposals_for_session[:noon] ||= []
          proposals_for_session[:noon] << [proposal, time]
          proposals_with_time.delete(proposal)
          noon = noon + time
        end
      end
    end
    proposals_for_session
  end

  def write_result
    File.open('output.txt', 'w') { |file| 
      result.each do |track, sessions|
        file.write(track)
        file.write("\n")
        daysession_starts_at = get_time(9)
        noonsession_starts_at = get_time(13)
        sessions[:day].each do |session|
          file.write(daysession_starts_at.strftime("%I:%M%p ") + session[0])
          file.write("\n")
          daysession_starts_at = daysession_starts_at + session[1] * 60
        end
        file.write(lunch)
        file.write("\n")
        if !sessions[:noon].nil?
          sessions[:noon].each do |session|
            file.write(noonsession_starts_at.strftime("%I:%M%p ") + session[0])
            file.write("\n")
            noonsession_starts_at = noonsession_starts_at + session[1] * 60
          end
          file.write(networking) if sessions[:noon].count != 0
          file.write("\n")
        end
      end
    }
  end
end

conference_talks = ConferenceTrackManagement.new
conference_talks.read_file
conference_talks.generate_proposals_timing
conference_talks.write_result