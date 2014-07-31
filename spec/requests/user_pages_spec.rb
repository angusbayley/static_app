require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "Signup page" do
  	before { visit signup_path }
  	it { should have_content('sign up') }
  	it { should have_content('disciple') }
  	it { should_not have_content('desciple') }
  end

  describe "Profile Page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user) }
  	it { should have_content(user.name) }
  	it { should have_title(user.name) }
  end

  describe "signup" do
    before { visit signup_path }
    
    describe "with invalid details" do
      it "should not create a user" do
        expect { click_button "Create account" }.not_to change(User, :count)
      end
    end

    describe "with valid details" do
      before do
        fill_in "Name",               with: "Example User"
        fill_in "Email",              with: "example@foobar.com"
        fill_in "Password",           with: "foobar"
        fill_in "Confirmation",  with: "foobar"
      end
      it "should create a user" do
        expect { click_button "Create account" }.to change(User, :count).by(1)
      end
    end

  end

end
