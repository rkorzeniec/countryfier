# frozen_string_literal: true

describe Admin::BorderCountriesController do
  let(:country) { create(:border_country) }

  context 'when user not authenticated' do
    it_behaves_like 'protected_admin_controller', [
      [:get, :index, { params: {} }],
      [:get, :new, { params: {} }],
      [:get, :edit, { params: { id: 1 } }],
      [:put, :update, { params: { id: 1 } }],
      [:post, :create, { params: {} }],
      [:delete, :destroy, { params: { id: 1 } }]
    ]
  end

  context 'when user signed in' do
    let(:user) { create(:user, admin: true) }

    before { sign_in(user) }

    it 'index' do
      get(:index)
      expect(response.status).to eq(200)
    end

    it 'new' do
      get(:new)
      expect(response.status).to eq(200)
    end

    it 'edit' do
      get(:edit, params: { id: country.id })
      expect(response.status).to eq(200)
    end

    it 'delete' do
      post(:destroy, params: { id: country.id })
      expect(response.status).to eq(302)
    end
  end
end
