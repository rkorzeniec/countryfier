# frozen_string_literal: true

class VisitedCountriesQuery
  def initialize(user)
    @user = user
  end

  def count_by_year
    Rails.cache.fetch(cache_key, expires_in: 1.week) do
      visited_country_checkins.group('year(checkins.checkin_date)').count
    end
  end

  private

  attr_reader :user

  def calculate_countries_by_year
    visited_country_checkins.group('year(checkins.checkin_date)').count
  end

  def visited_country_checkins
    @selected_country_checkins ||= user.past_checkins
  end

  def cache_key
    [
      self.class.to_s.underscore, user.id, visited_country_checkins.last&.id
    ].compact.join('/')
  end
end
