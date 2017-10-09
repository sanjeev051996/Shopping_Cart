require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  #render_views
  describe "GET new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
      response.body.should eq ""
    end
  end

  describe "post create" do
    context "with valid attributes in params" do
      it "redirects to the profile page upon successfull creation" do
        post :create, params: { user: FactoryGirl.attributes_for(:user) }
        response.should redirect_to profile_users_url
      end

      it "saves the new contact" do
        expect{
          post :create, params: { user: FactoryGirl.attributes_for(:user) }
        }.to change(User,:count).by(1)
      end
    end

    context "without valid attributes in params" do
      it "render new template if not created" do
        post :create, params: { user: FactoryGirl.attributes_for(:invalid_user) }
        expect(response).to render_template("new")
      end

      it "does not save the new contact" do
        expect{
          post :create, params: { user: FactoryGirl.attributes_for(:invalid_user) }
        }.to_not change(User,:count)
      end
    end
  end

  describe "patch update" do
    before :each do
      post :create, params: { user: FactoryGirl.attributes_for(:user) }
    end
    context "with valid attributes in params" do
      it "redirects to the profile page upon successfull update" do
        get :update, params: { user: FactoryGirl.attributes_for(:user), id: User.last.id }
        response.should redirect_to profile_users_path
      end

      it "located the requested user" do
        put :update, params: { id: User.last.id, user: FactoryGirl.attributes_for(:user) }
        assigns(:user).should eq(User.last)      
      end

      it "updated the requested user" do
        user_name = User.last.name
        put :update, params: { id: User.last.id, user: FactoryGirl.attributes_for(:user, name: "sanjeev") }
        User.last.reload
        User.last.name.should eq("sanjeev")
        User.last.name.should_not eq(user_name)     
      end
    end

    context "without valid attributes in params" do
      it "render edit template if not updated" do
        patch :update, params: { user: FactoryGirl.attributes_for(:invalid_user), id: User.last.id }
        expect(response).to render_template("edit")
      end

      it "locates the requested user" do
        put :update, params: { user: FactoryGirl.attributes_for(:invalid_user), id: User.last.id }
        assigns(:user).should eq(User.last)      
      end

      it "does not update the requested user" do
        user_name = User.last.name
        put :update, params: { id: User.last.id, user: FactoryGirl.attributes_for(:invalid_user, name: "sanjeev") }
        User.last.reload
        User.last.name.should_not eq("sanjeev")
        User.last.name.should eq(user_name)     
      end

    end
  end

  describe "GET edit" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      session[:user_id] = @user.id
    end
    context "with valid attributes in params" do
      it "renders the edit template if user is admin" do
        get :edit, params: {id: @user.id}
        expect(response).to render_template("edit")
        response.body.should eq ""
      end
    end

    context "without valid attributes in params" do
      it "redirects to users profile page if user is not admin" do
        User.last.toggle!(:admin)
        get :edit, params: {id: @user.id}
        expect(response).to redirect_to profile_users_path
      end
    end
  end

  describe "GET user profile" do
    before :each do
      post :create, params: { user: FactoryGirl.attributes_for(:user) }
    end

    it "renders the show template" do
      get :profile
      expect(response).to render_template("show")
      response.body.should eq ""
    end
  end

  describe "GET edit After post create" do
    before :each do
      post :create, params: { user: FactoryGirl.attributes_for(:user) }
    end
    context "with valid attributes in params" do
      it "renders the edit template" do
        User.last.toggle!(:admin)
        get :edit, params: {id: User.first.id}
        expect(response).to render_template("edit")
        response.body.should eq ""
      end
    end

    context "without valid attributes in params" do
      it "redirects to users profile page if user is not admin" do
        get :edit, params: {id: User.first.id}
        expect(response).to redirect_to profile_users_path
      end
    end
  end

  describe "GET index" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      session[:user_id] = @user.id
    end
    context "with admin as current user" do
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
        response.body.should eq ""
      end
    end

    context "without admin as current user" do
      it "redirects to profile users path" do
        User.last.toggle!(:admin)
        get :index
        expect(response).to redirect_to profile_users_path
      end
    end
  end

  describe "GET profile_settings" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      session[:user_id] = @user.id
    end

    it "renders the edit template" do
      get :profile_settings
      expect(response).to render_template("edit")
      response.body.should eq ""
    end
  end

  describe "Delete destroy" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      session[:user_id] = @user.id
    end

    context "with valid attributes in params" do
      it "redirect to users path after successful delete" do
        delete :destroy, params: { id: @user.id }
        expect(response).to redirect_to users_path
      end

      it "deletes the user" do
        expect{
          delete :destroy, params: { id: @user }        
        }.to change(User,:count).by(-1)
      end
    end

    context "without valid attributes in params" do
      it "redirect to profile users path after unsuccessful delete" do
        delete :destroy, params: { id: 0 }
        expect(response).to redirect_to profile_users_path
      end
    end
  end

  describe "GET show" do
    before :each do
      @user = FactoryGirl.create(:admin_user)
      session[:user_id] = @user.id
    end

    context "with valid attributes in params" do
      it "renders the show template" do
        get :show, params: { id: @user.id }
        expect(response).to render_template("show")
        response.body.should eq ""
      end
    end

    context "without valid attributes in params" do
      it "redirect to profile users path" do
        get :show, params: { id: 0 }
        expect(response).to redirect_to profile_users_path
      end
    end
  end
end
