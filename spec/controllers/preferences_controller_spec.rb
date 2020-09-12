# frozen_string_literal: true

describe PreferencesController do
  context 'when user not authenticated' do
    it_behaves_like 'authentication_protected_controller', [
      [:get, :edit, { params: { id: 1 } }],
      [:put, :update, { params: { id: 1 } }]
    ]
  end

  context 'when user signed in' do
    let!(:user) { create(:user, countries_cluster: 'all') }

    before { sign_in(user) }

    describe 'GET edit' do
      before { get(:edit) }

      it do
        expect(response).to be_successful
        expect(subject).to render_template(:edit)
      end
    end

    describe 'PUT update' do
      subject { post(:update, params: params) }

      let!(:now) { '2016-01-01' }

      context 'when successful' do
        let(:params) { { user: { countries: 'independent', color: '#FFF' } } }

        it do
          expect(subject).to redirect_to(edit_preferences_path)
          expect(flash[:success]).to be_present
        end

        it do
          expect { subject }.to change { user.reload.color }
            .from(nil).to('#FFF')
            .and change { user.countries_cluster }
            .from('all').to('independent')
        end
      end

      context 'when unsuccessful' do
        let(:params) { { user: { color: 'some_colour' } } }

        before do
          allow_any_instance_of(User).to receive(:update)
            .and_return(false)
        end

        it do
          expect(subject).to render_template(:edit)
          expect(flash[:error]).to be_present
        end
      end
    end
  end
end
