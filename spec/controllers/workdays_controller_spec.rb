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

  describe "workdays#edit" do
    it "should successfully show edit form if workday is found" do
      workday1 = FactoryGirl.create(:workday)
      sign_in workday1.user

      get :edit, params: { id: workday1.id }
      expect(response).to have_http_status(:success)
    end

    it "should return HTTP status code 404 if workday not found" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :edit, params: { id: 'fake_id' }
      expect(response).to have_http_status(:not_found)
    end

    it "should require user to be authenticated before accessing edit form" do
      workday1 = FactoryGirl.create(:workday)
      get :edit, params: { id: workday1.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should prevent user who did not create workday from accessing edit form" do
      workday1 = FactoryGirl.create(:workday)
      user = FactoryGirl.create(:user)
      sign_in user

      get :edit, params: { id: workday1.id }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "workdays#update" do
    it "should successfully update workday" do
      workday1 = FactoryGirl.create(:workday, job_title: 'Job')
      sign_in workday1.user

      patch :update, params: { id: workday1.id, workday: { job_title: 'Changed' } }
      expect(response).to redirect_to workdays_path

      workday1.reload
      expect(workday1.job_title).to eq 'Changed'
    end

    it "should return HTTP status code 404 if workday not found" do
      user = FactoryGirl.create(:user)
      sign_in user

      patch :update, params: { id: 'fake_id', workday: { job_title: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "should require user to be authenticated before updating workday" do
      workday1 = FactoryGirl.create(:workday)

      patch :update, params: { id: workday1.id, workday: { job_title: 'Changed' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should prevent users who did not create workday from updating workday" do
      workday1 = FactoryGirl.create(:workday)
      user = FactoryGirl.create(:user)
      sign_in user

      patch :update, params: { id: workday1.id, workday: { job_title: 'Changed' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "should properly address validation errors" do
      workday1 = FactoryGirl.create(:workday, job_title: 'Initial', industry: 'Initial', description: 'Initial')
      sign_in workday1.user

      patch :update, params: { id: workday1.id, workday: { job_title: '', industry: '', description: '' } }

      expect(response).to have_http_status(:unprocessable_entity)

      workday1.reload
      expect(workday1.job_title).to eq 'Initial'
      expect(workday1.industry).to eq 'Initial'
      expect(workday1.description).to eq 'Initial'
    end
  end

  describe "workdays#destroy" do
    it "should allow user to successfully destroy workday" do
      workday1 = FactoryGirl.create(:workday)
      sign_in workday1.user

      delete :destroy, params: { id: workday1.id }
      expect(response).to redirect_to root_path

      workday1 = Workday.find_by_id(workday1.id)
      expect(workday1).to eq nil
    end

    it "should return HTTP status 404 if workday not found" do
      user = FactoryGirl.create(:user)
      sign_in user

      delete :destroy, params: { id: 'fake_id' }
      expect(response).to have_http_status(:not_found)
    end

    it "should require user to be authenticated before destroying workday" do
      workday1 = FactoryGirl.create(:workday)

      delete :destroy, params: { id: workday1.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should prevent user who did not create workday from destroying it" do
      workday1 = FactoryGirl.create(:workday)
      user = FactoryGirl.create(:user)
      sign_in user

      delete :destroy, params: { id: workday1.id }
      expect(response).to have_http_status(:forbidden)
    end
  end
end
