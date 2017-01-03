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

end
