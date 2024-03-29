# frozen_string_literal: true

describe Country do
  it { is_expected.to have_many(:checkins).dependent(:restrict_with_error) }
  it { is_expected.to have_many(:currencies).dependent(:restrict_with_error) }

  it do
    is_expected.to have_many(:top_level_domains)
      .dependent(:restrict_with_error)
  end

  it { is_expected.to have_many(:country_languages).dependent(:destroy) }
  it { is_expected.to have_many(:country_calling_codes).dependent(:destroy) }
  it { is_expected.to have_many(:border_countries).dependent(:destroy) }

  it do
    is_expected.to have_many(:country_alternative_spellings)
      .dependent(:destroy)
  end

  describe '.arranged_by_name' do
    subject { described_class.arranged_by_name }

    let!(:switzerland) { create(:country) }
    let!(:australia) { create(:country, :oceanian) }
    let!(:united_states) { create(:country, name_common: 'United States') }

    it do
      is_expected.to eq([australia, switzerland, united_states])
    end
  end

  describe '.un_member' do
    subject { described_class.un_member }

    let!(:switzerland) { create(:country, un_member: true) }
    let!(:madagascar) { create(:country, :african, un_member: false) }

    it { is_expected.to eq([switzerland]) }
  end

  describe '.independent' do
    subject { described_class.independent }

    let!(:switzerland) { create(:country, independent: true) }
    let!(:madagascar) { create(:country, :african, independent: false) }

    it { is_expected.to eq([switzerland]) }
  end

  describe '.find_by_any' do
    subject { described_class.find_by_any(name) }

    let!(:switzerland) { create(:country) }
    let!(:united_states) do
      create(
        :country,
        name_common: 'United States', name_official: 'United States of America',
        cca2: 'US', ccn3: '840', cca3: 'USA', cioc: 'USA'
      )
    end

    context 'when name is cca2' do
      let(:name) { 'CH' }

      it { is_expected.to eq(switzerland) }

      context 'with prefix' do
        let(:name) { 'C' }

        it { is_expected.to eq(switzerland) }
      end

      context 'with suffix' do
        let(:name) { 'H' }

        it { is_expected.to eq(switzerland) }
      end
    end

    context 'when name is ccn3' do
      let(:name) { 756 }

      it { is_expected.to eq(switzerland) }

      context 'with prefix' do
        let(:name) { 7 }

        it { is_expected.to eq(switzerland) }
      end

      context 'with suffix' do
        let(:name) { 56 }

        it { is_expected.to eq(switzerland) }
      end
    end

    context 'when name is cca3' do
      let(:name) { 'CHE' }

      it { is_expected.to eq(switzerland) }

      context 'with prefix' do
        let(:name) { 'CH' }

        it { is_expected.to eq(switzerland) }
      end

      context 'with suffix' do
        let(:name) { 'E' }

        it { is_expected.to eq(switzerland) }
      end
    end

    context 'when name is cioc' do
      let(:name) { 'SUI' }

      it { is_expected.to eq(switzerland) }

      context 'with prefix' do
        let(:name) { 'SU' }

        it { is_expected.to eq(switzerland) }
      end

      context 'with suffix' do
        let(:name) { 'I' }

        it { is_expected.to eq(switzerland) }
      end
    end

    context 'when name is neither' do
      let(:name) { nil }

      it { is_expected.to eq(described_class.first) }
    end
  end

  describe '#european' do
    it do
      expect { create(:country) }.to change { described_class.european.count }
        .from(0).to(1)
    end

    it do
      expect { create(:country, :asian) }
        .not_to change { described_class.european.count }
    end
  end

  describe '#asian' do
    it do
      expect { create(:country, :asian) }.to change {
        described_class.asian.count
      }.from(0).to(1)
    end

    it do
      expect { create(:country) }.not_to change { described_class.asian.count }
    end
  end

  describe '#african' do
    it do
      expect { create(:country, :african) }.to change {
        described_class.african.count
      }.from(0).to(1)
    end

    it do
      expect { create(:country) }.not_to change { described_class.african.count }
    end
  end

  describe '#antarctican' do
    it do
      expect { create(:country, :antarctican) }.to change {
        described_class.antarctican.count
      }.from(0).to(1)
    end

    it do
      expect { create(:country) }.not_to change { described_class.antarctican.count }
    end
  end

  describe '#oceanian' do
    it do
      expect { create(:country, :oceanian) }.to change {
        described_class.oceanian.count
      }.from(0).to(1)
    end

    it do
      expect { create(:country) }.not_to change { described_class.oceanian.count }
    end
  end

  describe '#north_american' do
    it do
      expect { create(:country, :north_american) }.to change {
        described_class.north_american.count
      }.from(0).to(1)
    end

    it do
      expect { create(:country, :caribbean) }.to change {
        described_class.north_american.count
      }.from(0).to(1)
    end

    it do
      expect { create(:country, :central_american) }.to change {
        described_class.north_american.count
      }.from(0).to(1)
    end

    it do
      expect { create(:country, :south_american) }
        .not_to change { described_class.north_american.count }
    end
  end

  describe '#south_american' do
    it do
      expect { create(:country, :south_american) }.to change {
        described_class.south_american.count
      }.from(0).to(1)
    end

    it do
      expect { create(:country) }.not_to change {
        described_class.south_american.count
      }
    end
  end

  describe '#flag_image_path' do
    subject { country.flag_image_path }

    context 'when flag does not exist' do
      let(:country) { build_stubbed(:country, cca2: 'mambo') }

      it do
        is_expected.to eq(
          ActionController::Base.helpers.asset_path('flags/unknown.png')
        )
      end
    end

    context 'when flag exist' do
      let(:country) { build_stubbed(:country, cca2: 'CH') }

      it { is_expected.to match(%r{/assets/flags/CH-.*\.png}) }
    end
  end
end
