describe Dashboard::VisitedCountriesCounter do
  let(:counter) { described_class.new(user) }
  let(:user) { create(:user) }

  let(:european_country) { create(:country) }
  let(:asian_country) { create(:country, :asian) }
  let(:oceanian_country) { create(:country, :oceanian) }
  let(:african_country) { create(:country, :african) }
  let(:antarctic_country) { create(:country, :antarctican) }
  let(:north_american_country) { create(:country, :north_american) }
  let(:central_american_country) { create(:country, :central_american) }
  let(:caribbean_country) { create(:country, :caribbean) }
  let(:south_american_country) { create(:country, :south_american) }
  let(:european_checkin) do
    create(:checkin, user: user, country: european_country)
  end
  let(:north_american_checkin) do
    create(:checkin, user: user, country: north_american_country)
  end
  let(:south_american_checkin) do
    create(:checkin, user: user, country: south_american_country)
  end
  let(:asian_checkin) do
    create(:checkin, user: user, country: asian_country)
  end
  let(:african_checkin) do
    create(:checkin, user: user, country: african_country)
  end
  let(:oceanian_checkin) do
    create(:checkin, user: user, country: oceanian_country)
  end
  let(:antarctic_checkin) do
    create(:checkin, user: user, country: antarctic_country)
  end

  shared_context 'cached_method' do
    let(:cache) { double('cache') }
    let(:cache_key) do
      [
        'dashboard/visited_countries_counter',
        method_name,
        user.id
      ].join('/')
    end

    it do
      expect(Rails).to receive(:cache).and_return(cache)
      expect(cache).to receive(:fetch).with(cache_key, expires_in: 1.week)
      subject
    end
  end

  describe '#visited_world_countries_count' do
    subject { counter.visited_world_countries_count }

    it_behaves_like 'cached_method' do
      let(:method_name) { 'visited_world_countries_count' }
    end

    context 'when world checkin exist' do
      before do
        european_checkin
        asian_checkin
        african_checkin
      end

      it { is_expected.to eq(3) }

      context 'with two same countries' do
        let!(:european_checkin_b) do
          create(:checkin, user: user, country: european_country)
        end

        it { is_expected.to eq(3) }
      end
    end

    context 'when world checkin does not exist' do
      it { is_expected.to eq(0) }
    end
  end

  describe '#visited_european_countries_count' do
    subject { counter.visited_european_countries_count }

    it_behaves_like 'cached_method' do
      let(:method_name) { 'visited_european_countries_count' }
    end

    context 'when european checkin exist' do
      before { european_checkin }

      it { is_expected.to eq(1) }

      context 'with two same countries' do
        let!(:european_checkin_b) do
          create(:checkin, user: user, country: european_country)
        end

        it { is_expected.to eq(1) }
      end
    end

    context 'when european checkin does not exist' do
      it { is_expected.to eq(0) }
    end
  end

  describe '#visited_north_american_countries_count' do
    subject { counter.visited_north_american_countries_count }

    it_behaves_like 'cached_method' do
      let(:method_name) { 'visited_north_american_countries_count' }
    end

    context 'when north american checkin exist' do
      before { north_american_checkin }

      it { is_expected.to eq(1) }

      context 'with central american country' do
        let(:central_american_checkin) do
          create(:checkin, user: user, country: central_american_country)
        end

        before { central_american_checkin }

        it { is_expected.to eq(2) }
      end

      context 'with caribbean country' do
        let(:caribbean_checkin) do
          create(:checkin, user: user, country: caribbean_country)
        end

        before { caribbean_checkin }

        it { is_expected.to eq(2) }
      end

      context 'with two same countries' do
        let!(:north_american_checkin_b) do
          create(:checkin, user: user, country: north_american_country)
        end

        it { is_expected.to eq(1) }
      end
    end

    context 'when north american checkin does not exist' do
      it { is_expected.to eq(0) }
    end
  end

  describe '#visited_south_american_countries_count' do
    subject { counter.visited_south_american_countries_count }

    it_behaves_like 'cached_method' do
      let(:method_name) { 'visited_south_american_countries_count' }
    end

    context 'when south american checkin exist' do
      before { south_american_checkin }

      it { is_expected.to eq(1) }

      context 'with two same countries' do
        let!(:south_american_checkin_b) do
          create(:checkin, user: user, country: south_american_country)
        end

        it { is_expected.to eq(1) }
      end
    end

    context 'when south american checkin does not exist' do
      it { is_expected.to eq(0) }
    end
  end

  describe '#visited_asian_countries_count' do
    subject { counter.visited_asian_countries_count }

    it_behaves_like 'cached_method' do
      let(:method_name) { 'visited_asian_countries_count' }
    end

    context 'when asian checkin exist' do
      before { asian_checkin }

      it { is_expected.to eq(1) }

      context 'with two same countries' do
        let!(:asian_checkin_b) do
          create(:checkin, user: user, country: asian_country)
        end

        it { is_expected.to eq(1) }
      end
    end

    context 'when asian checkin does not exist' do
      it { is_expected.to eq(0) }
    end
  end

  describe '#visited_oceanian_countries_count' do
    subject { counter.visited_oceanian_countries_count }

    it_behaves_like 'cached_method' do
      let(:method_name) { 'visited_oceanian_countries_count' }
    end

    context 'when oceanian checkin exist' do
      before { oceanian_checkin }

      it { is_expected.to eq(1) }

      context 'with two same countries' do
        let!(:oceanian_checkin_b) do
          create(:checkin, user: user, country: oceanian_country)
        end

        it { is_expected.to eq(1) }
      end
    end

    context 'when oceanian checkin does not exist' do
      it { is_expected.to eq(0) }
    end
  end

  describe '#visited_african_countries_count' do
    subject { counter.visited_african_countries_count }

    it_behaves_like 'cached_method' do
      let(:method_name) { 'visited_african_countries_count' }
    end

    context 'when african checkin exist' do
      before { african_checkin }

      it { is_expected.to eq(1) }

      context 'with two same countries' do
        let!(:african_checkin_b) do
          create(:checkin, user: user, country: african_country)
        end

        it { is_expected.to eq(1) }
      end
    end

    context 'when african checkin does not exist' do
      it { is_expected.to eq(0) }
    end
  end

  describe '#visited_antarctican_countries_count' do
    subject { counter.visited_antarctican_countries_count }

    it_behaves_like 'cached_method' do
      let(:method_name) { 'visited_antarctican_countries_count' }
    end

    context 'when antarctic checkin exist' do
      before { antarctic_checkin }

      it { is_expected.to eq(1) }

      context 'with two same countries' do
        let!(:antarctic_checkin_b) do
          create(:checkin, user: user, country: antarctic_country)
        end

        it { is_expected.to eq(1) }
      end
    end

    context 'when antarctic checkin does not exist' do
      it { is_expected.to eq(0) }
    end
  end

  describe '#cache_key' do
    subject { counter.send(:cache_key, 'visited_european_countries_count') }

    before { european_checkin }

    it do
      is_expected.to eq(
        'dashboard/visited_countries_counter/visited_european_countries_count/' \
        "#{user.id}/#{european_checkin.id}"
      )
    end
  end
end
