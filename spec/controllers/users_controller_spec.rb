require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, params: { user: @user_attributes }
      end

      it "renders the json representation for the user record just created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:nickname]).to eql @user_attributes[:nickname]
      end

      it { should respond_with 201 }
    end

    context "when nickname already exists" do
      before(:each) do
        user = FactoryGirl.create :user
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, params: { user: @user_attributes }
        @user_response = JSON.parse(response.body, symbolize_names: true)
      end

      it "renders an errors json" do
        expect(@user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        expect(@user_response[:errors][:nickname])
      end

      it { should respond_with 409 }
    end
  end

  describe "GET #get_leaderboard" do
    before(:each) do
      best_user = FactoryGirl.create :scorer1000
      mid_user = FactoryGirl.create :scorer100
      worst_user = FactoryGirl.create :scorer10
      get :get_leaderboard
      @user_response = JSON.parse(response.body, symbolize_names: true)
    end

    it "renders all users" do
      expect(@user_response.length).to eq(3)
    end

    it "renders users in correct order" do
      expect(@user_response[0][:nickname]).to eq("scorer1000")
    end

    it { should respond_with 200 }
  end

  describe "POST #update_place" do
    before(:each) do
      best_user = FactoryGirl.create :scorer1000
      mid_user = FactoryGirl.create :scorer100
      worst_user = FactoryGirl.create :scorer10
      request.headers['Authorization'] =  worst_user.auth_token
      post :update_place, params: { user: { score: 101 }}
      @user_response = JSON.parse(response.body, symbolize_names: true)
    end

    it "renders the updated user info" do
      expect(@user_response[:place]).to eq(2)
    end

    it { should respond_with 200 }
  end
end
