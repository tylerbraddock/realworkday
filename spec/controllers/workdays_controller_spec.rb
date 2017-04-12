require 'rails_helper'

RSpec.describe WorkdaysController, type: :controller do
  describe "workdays#index" do
    it "should successfully show page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "workdays#new" do
    it "should successfully show new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "workday#create" do
    it "should create new workday in database" do
      workday1 = FactoryGirl.attributes_for(:workday)
      post :create, params: { workday: workday1 }

      expect(response).to redirect_to workdays_path

      work = Workday.last
      expect(work.job_title).to eq(workday1[:job_title])
      expect(work.industry).to eq(workday1[:industry])
      expect(work.description).to eq(workday1[:description])
    end
  end

end
