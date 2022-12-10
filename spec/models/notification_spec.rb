# frozen_string_literal: true

describe Notification do
  it { is_expected.to belong_to(:notifiable) }
  it { is_expected.to belong_to(:recipient).class_name('User') }

  it { is_expected.to delegate_method(:message).to(:notifiable) }

  describe '.unread' do
    context 'when unread' do
      let(:notification) { create(:notification, :unread) }

      it do
        expect { notification }.to change { described_class.unread.count }
          .from(0).to(1)

        expect(described_class.last).to eq(notification)
      end
    end

    context 'when read' do
      let(:notification) { create(:notification) }

      it do
        expect { notification }.not_to change { described_class.unread.count }
      end
    end
  end

  describe '.with_notifiable' do
    let(:notification) { create(:notification, :unread) }

    it do
      expect { notification }.to change { described_class.with_notifiable.count }
        .from(0).to(1)

      expect(described_class.with_notifiable.first).to eq(notification)
    end
  end

  describe '#mark_as_read' do
    subject { notification.mark_as_read }

    let(:notification) { create(:notification, :unread) }
    let(:now) { Time.zone.local(2020, 6, 20, 12, 53, 25) }

    before { Timecop.freeze(now) }

    after { Timecop.return }

    it do
      expect { subject }.to change { notification.read_at }.from(nil).to(now)
    end
  end

  describe '#notification_type' do
    subject { notification.notification_type }

    let(:notification) { build_stubbed(:notification) }

    context 'with announcement type' do
      it { is_expected.to eq('announcement') }
    end

    context 'with other type' do
      before { allow(notification).to receive(:notifiable_type).and_return('ActionCable') }

      it { is_expected.to eq('action_cable') }
    end
  end
end
