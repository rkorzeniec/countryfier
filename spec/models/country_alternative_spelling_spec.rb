# frozen_string_literal: true

describe CountryAlternativeSpelling do
  it { is_expected.to belong_to(:country) }

  it { is_expected.to validate_presence_of(:name) }
end
