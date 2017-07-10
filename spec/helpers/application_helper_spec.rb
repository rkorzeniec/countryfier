describe ApplicationHelper do
  describe '#page_title' do
    subject { helper.page_title }

    context 'when default title' do
      it { expect(subject).to eq('Countryfier') }
    end

    context 'when page title' do
      let(:title) { 'Checkins | Countryfier' }

      it do
        assign(:page_title, title)
        expect(subject).to eq(title)
      end
    end
  end

  describe '#render_date' do
    subject { helper.render_date(date) }

    context 'when date is provided' do
      let(:date) { Time.zone.now }

      it { expect(subject).to eq(date.strftime('%Y-%m-%d')) }
    end

    context 'when date is not provided' do
      let(:date) { nil }

      it { expect(subject).to be_nil }
    end
  end

  describe '#embedded_svg' do
    context 'when file exists' do
      it 'is a pending example'
    end

    context 'when class is supplied' do
      it 'is a pending example'
    end

    context 'when class is not supplied' do
      it 'is a pending example'
    end
  end
end
