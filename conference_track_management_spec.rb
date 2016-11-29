require './conference_track_management'
require 'rspec'

RSpec.describe ConferenceTrackManagement do
  describe "#conference_track_management" do

    it "check input file is present" do
      conference_talks = ConferenceTrackManagement.new
      expect(File.exist?(conference_talks.path)).to eq(true)
    end

    it "check input file is present" do
      conference_talks = ConferenceTrackManagement.new
      expect(File.exist?(conference_talks.path)).to eq(true)
    end

    it "check daysession timing" do
      conference_talks = ConferenceTrackManagement.new
      today = Time.now
      start_time = Time.new today.year, today.month, today.day, 9
      end_time = Time.new today.year, today.month, today.day, 12
      session_time = end_time - start_time
      expect(conference_talks.daysession).to eq((session_time / 60).to_i)
    end

    it "check noonsession timing" do
      conference_talks = ConferenceTrackManagement.new
      today = Time.now
      start_time = Time.new today.year, today.month, today.day, 13
      end_time = Time.new today.year, today.month, today.day, 17
      session_time = end_time - start_time
      expect(conference_talks.noonsession).to eq((session_time / 60).to_i)
    end

    it "check lunch timing" do
      conference_talks = ConferenceTrackManagement.new
      expect(conference_talks.lunch).to eq("12:00PM Lunch")
    end

    it "check network timing" do
      conference_talks = ConferenceTrackManagement.new
      expect(conference_talks.networking).to eq("05:00PM Networking Event")
    end

  end
end