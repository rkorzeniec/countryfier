# frozen_string_literal: true

describe CheckinsController do
  let(:user) { create(:user) }
  let(:country) { create(:country) }
  let!(:checkin) { create(:checkin, user: user, country: country) }

  context 'when user not authenticated' do
    it_behaves_like 'authentication_protected_controller', [
      [:get, :index, { params: {} }],
      [:get, :show, { params: { id: 1 } }],
      [:get, :new, { params: {} }],
      [:get, :edit, { params: { id: 1 } }],
      [:put, :update, { params: { id: 1 } }],
      [:post, :create, { params: {} }],
      [:delete, :destroy, { params: { id: 1 } }]
    ]
  end

  context 'when user signed in' do
    before { sign_in(user) }

    describe 'GET index' do
      let(:country) { create(:country, :african) }
      let(:country_b) { create(:country) }
      let!(:checkin) do
        create(:checkin, user: user, country: country, checkin_date: '2017-02-01')
      end
      let!(:checkin_b) do
        create(:checkin, user: user, country: country, checkin_date: '2017-01-01')
      end
      let!(:checkin_c) { create(:checkin, user: user, country: country_b) }

      it do
        expect(Checkins::TimelineFacade).to receive(:new)
          .with(Checkin.all.order(checkin_date: :desc)).and_call_original

        get(:index)

        expect(response).to be_successful
        expect(subject).to render_template(:index)

        timeline_items = assigns(:timeline).items
        expect(timeline_items.count).to eq(3)
        expect(timeline_items.first.checkin).to eq(checkin_c)
        expect(timeline_items.second.checkin).to eq(checkin)
        expect(timeline_items.third.checkin).to eq(checkin_b)
      end

      context 'with scope' do
        it do
          expect(Checkins::TimelineFacade).to receive(:new)
            .with(Checkin.african.order(checkin_date: :desc)).and_call_original

          get(:index, params: { scope: 'african' })

          expect(response).to be_successful
          expect(subject).to render_template(:index)

          timeline_items = assigns(:timeline).items
          expect(timeline_items.count).to eq(2)
          expect(timeline_items.first.checkin).to eq(checkin)
          expect(timeline_items.second.checkin).to eq(checkin_b)
        end
      end
    end

    describe 'GET show' do
      before { get(:show, params: { id: checkin.id }) }

      it do
        expect(response).to render_template('checkins/_checkin_item')
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'GET new' do
      before { get(:new) }

      it do
        expect(response).to be_successful
        expect(subject).to render_template('checkins/_new')
      end
    end

    describe 'POST create' do
      subject { post(:create, params: params, format: :turbo_stream) }

      let!(:now) { Time.current }
      let(:params) do
        { checkin: { country_id: country.id, checkin_date: now } }
      end

      context 'when successful' do
        it do
          subject

          expect(response).to render_template(:create)
          expect(response).to have_http_status(:ok)
          expect(flash[:success]).to be_present
        end

        it { expect { subject }.to change(Checkin, :count).from(1).to(2) }
      end

      context 'when unsuccessful' do
        let(:params) do
          { checkin: { country_id: 'not_id', checkin_date: 'not_date' } }
        end

        it { expect(subject).to render_template('checkins/_new') }
        it { expect { subject }.not_to change(Checkin, :count) }

        it do
          subject
          expect(flash[:error]).to be_present
        end
      end
    end

    describe 'GET edit' do
      before { get(:edit, params: { id: checkin.id }) }

      it do
        expect(response).to be_successful
        expect(subject).to render_template('checkins/_edit')
        expect(assigns(:checkin)).to eq(checkin)
        expect(response.body).to include(country.name_common)
      end
    end

    describe 'PUT update' do
      subject { post(:update, params: params, format: :turbo_stream) }

      let!(:now) { '2016-01-01' }

      context 'when successful' do
        let(:params) { { id: checkin.id, checkin: { checkin_date: now } } }

        before { subject }

        it do
          expect(response).to render_template(:update)
          expect(response).to have_http_status(:ok)
        end

        it do
          expect(checkin.reload.checkin_date.strftime('%Y-%m-%d')).to eq(now)
        end
      end

      context 'when unsuccessful' do
        let(:params) { { id: checkin.id, checkin: { checkin_date: nil } } }

        it do
          expect { subject }.to raise_error(
            ActiveRecord::RecordInvalid,
            'Validation failed: Checkin date can\'t be blank'
          )
        end
      end
    end

    describe 'DELETE destroy' do
      subject { delete(:destroy, params: { id: checkin.id }, format: :turbo_stream) }

      context 'when successful' do
        it do
          subject

          expect(response).to render_template(:destroy)
          expect(response).to have_http_status(:ok)
          expect(flash[:success]).to be_present
        end

        it { expect { subject }.to change(Checkin, :count).from(1).to(0) }
      end
    end
  end
end
