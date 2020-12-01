# frozen_string_literal: true

describe ApplicationController do
  controller do
    def index
      head :ok
    end
  end

  context 'when user not authenticated' do
    it_behaves_like 'authentication_protected_controller', [
      [:get, :index, { params: {} }]
    ]
  end

  context 'when user signed in' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    describe 'GET index' do
      before { get(:index) }

      it do
        expect(response).to be_successful
      end
    end
  end

  describe '#after_sign_in_path_for' do
    subject { controller.after_sign_in_path_for(nil) }

    it do
      is_expected.to eq('/profile')
    end
  end

  describe '#set_raven_context' do
    it 'sets up Raven' do
      expect(Raven).to receive(:user_context).with(id: session[:current_user_id])
      expect(Raven).to receive(:extra_context).with(
        params: { 'action' => 'index', 'controller' => 'anonymous' },
        url: 'http://test.host/anonymous'
      )

      get(:index)
    end
  end
end
