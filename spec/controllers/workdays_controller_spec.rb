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

end
