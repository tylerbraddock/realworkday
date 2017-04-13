require 'rails_helper'

RSpec.describe WorkdaysController, type: :controller do
  describe "workdays#index" do
    it "should successfully show page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "workdays#new" do
    it "should require users to be signed in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show new form" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "workday#create" do
    it "should require users to be signed in" do
      workday1 = FactoryGirl.attributes_for(:workday)
      post :create, params: { workday: workday1 }

      expect(response).to redirect_to new_user_session_path
    end

    it "should create new workday in database" do
      user = FactoryGirl.create(:user)
      sign_in user

      workday1 = FactoryGirl.attributes_for(:workday)
      post :create, params: { workday: workday1 }

      expect(response).to redirect_to workdays_path

      work = Workday.last
      expect(work.job_title).to eq(workday1[:job_title])
      expect(work.industry).to eq(workday1[:industry])
      expect(work.description).to eq(workday1[:description])
      expect(work.user).to eq(user)
    end

    it "should properly address validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, params: { workday: { job_title: '', industry: '', description: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Workday.count).to eq 0
    end
  end

  describe "workdays#show" do
    it "should successfully show page if workday is found" do
      workday1 = FactoryGirl.create(:workday)
      get :show, params: { id: workday1.id }
      expect(response).to have_http_status(:success)
    end

    it "should return HTTP status code 404 if workday not found" do
      get :show, params: { id: "fake_id" }
      expect(response).to have_http_status(:not_found)
    end
  end

end
