require 'rails_helper'

RSpec.describe User, type: :model do
  describe "user model" do
    it "has a valid factory" do 
      FactoryGirl.create(:user).should be_valid
    end

    context "without valid attributes" do
      it "invalid without a name" do 
        FactoryGirl.build(:invalid_name).should_not be_valid
      end

      it "invalid without a password" do 
        FactoryGirl.build(:invalid_user).should_not be_valid
      end

      it "invalid with email other than valid format" do 
        FactoryGirl.build(:invalid_email).should_not be_valid
      end

      it "does not allow email duplication with case sesitivity" do 
      	user = FactoryGirl.create(:user, email: "sanjeev0517@gmail.com")
      	FactoryGirl.build(:user, email: "sanjeev0517@gmail.com").should_not be_valid
        FactoryGirl.build(:user, email: "Sanjeev0517@gmail.com").should be_valid
      end
    end

    context "instance methods" do 
    	before :each do 
        @user = FactoryGirl.create(:user, name: "SANJEEV", password: "123456")
      end

      it "returns the name of user" do 
        @user.name.should == "SANJEEV"
      end

      it "returns password and checks that it is saved as a secured hash" do  
        @user.password.should == "123456"
        @user.password_digest.should_not == "123456"
      end
    end

    context "class methods" do
      before :each do 
        @smith = FactoryGirl.create(:user, name: "Smith")
        @jones = FactoryGirl.create(:user, name: "Jones", email: "jones@gmail.com")
        @johnson = FactoryGirl.create(:user, name: "Johnson", email: "johnson@gmail.com")
      end

      it "returns a array of all users sorted by id" do
        User.all.should == [ @smith, @jones, @johnson ].sort_by!{ |user| user[:id] }
      end


      it "returns a users with given name as parameter if it exists else nil" do
        User.find_by(name: "Jones").should == @jones
        User.find_by(name: "rocks").should == nil
      end
    end

    context "associations with other models" do
      it "have many orders" do
        t = User.reflect_on_association(:orders)
        expect(t.macro).to eq(:has_many)
      end

      it "have one cart" do
        t = User.reflect_on_association(:cart)
        expect(t.macro).to eq(:has_one)
      end
    end
  end
end
