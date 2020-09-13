# frozen_string_literal: true

class DashboardFacade
  include CacheFetch

  DELEGATION_METHODS = %i[
    countries_count european_countries_count north_american_countries_count
    south_american_countries_count asian_countries_count african_countries_count
    oceanian_countries_count antarctican_countries_count
  ].freeze

  delegate(*DELEGATION_METHODS, to: :countries_counter)
  delegate(*DELEGATION_METHODS, prefix: :visited, to: :visited_countries_counter)

  def initialize(user)
    @user = user
  end

  def country_code_array
    cache_fetch(__method__) { user_countries.pluck(:cca2) }
  end

  def countries_yearly_chart_data
    cache_fetch(__method__) do
      [
        { name: 'all', query: VisitedCountriesQuery.new(user).count_by_year },
        { name: 'unique', query: UniqVisitedCountriesQuery.new(user).count_by_year }
      ]
    end
  end

  def top_countries_chart_data
    cache_fetch(__method__) do
      TopCountriesQuery.new(user_countries).query
    end
  end

  def top_regions_chart_data
    cache_fetch(__method__) do
      TopRegionsQuery.new(user_countries).query
    end
  end

  private

  attr_reader :user

  def user_countries
    @user_countries ||= user.countries.distinct.load
  end

  def countries_counter
    @countries_counter ||=
      ::Dashboard::CountriesCounter.new(user)
  end

  def visited_countries_counter
    @visited_countries_counter ||=
      ::Dashboard::VisitedCountriesCounter.new(user)
  end
end
