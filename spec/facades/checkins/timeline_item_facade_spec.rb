# frozen_string_literal: true

describe Checkins::TimelineItemFacade do
  let(:now) { Time.zone.local(2017, 12, 16) }
  let(:checkin) { instance_double(Checkin) }
  let(:facade) { described_class.new(checkin) }

  before { Timecop.freeze(now) }

  after { Timecop.return }

  describe 'delegations' do
    it { expect(facade).to delegate_method(:country).to(:checkin) }
    it { expect(facade).to delegate_method(:to_key).to(:checkin) }
    it { expect(facade).to delegate_method(:model_name).to(:checkin) }
    it { expect(facade).to delegate_method(:destroyed?).to(:checkin) }
    it { expect(facade).to delegate_method(:flag_image_path).to(:country) }

    it do
      expect(facade).to delegate_method(:cca2).to(:country).with_prefix(true)
    end
  end

  describe '#checkin_date' do
    subject { facade.checkin_date }

    let(:date) { Date.new(2018, 1, 11) }
    let(:checkin) { instance_double(Checkin, checkin_date: date) }

    it { is_expected.to eq('2018-01-11') }
  end

  describe '#checkin_year' do
    subject { facade.checkin_year }

    let(:date) { Date.new(2018, 1, 11) }
    let(:checkin) { instance_double(Checkin, checkin_date: date) }

    it { is_expected.to eq(2018) }
  end

  describe '#future_checkin?' do
    subject { facade.future_checkin? }

    let(:checkin) { instance_double(Checkin, checkin_date: date) }

    context 'when in past' do
      let(:date) { Date.new(2017, 11, 11) }

      it { is_expected.to be_falsey }
    end

    context 'when in present' do
      let(:date) { Date.new(2017, 12, 16) }

      it { is_expected.to be_truthy }
    end

    context 'when in future' do
      let(:date) { Date.new(2018, 1, 1) }

      it { is_expected.to be_truthy }
    end
  end

  describe '#country_cca2' do
    subject { facade.country_cca2 }

    let(:country) { instance_double(Country, cca2: 'CH') }
    let(:checkin) { instance_double(Checkin, country: country) }

    it { is_expected.to eq('CH') }
  end

  describe '#country_common_name' do
    subject { facade.country_common_name }

    let(:country) { instance_double(Country, name_common: 'Switzerland') }
    let(:checkin) { instance_double(Checkin, country: country) }

    it { is_expected.to eq('Switzerland') }
  end

  describe '#flag_image_path' do
    subject { facade.flag_image_path }

    let(:country) do
      instance_double(Country, flag_image_path: 'images/flags/ch.png')
    end

    let(:checkin) { instance_double(Checkin, country: country) }

    it { is_expected.to eq('images/flags/ch.png') }
  end
end
