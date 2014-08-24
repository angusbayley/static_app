require 'spec_helper'

describe "AuthenticationPages" do

  subject { page }

  describe "signin page" do
		before { visit signin_path }
		it { should have_title("Sign in") }
		it { should have_content("Sign in") }
	end

	describe "before sign-in" do
		before { visit root_url }
		it { should_not have_link('Profile') }
		it { should_not have_link('Settings') }
	end

	describe "Sign in" do
		before { visit signin_path }
		describe "with invalid information" do
			before { click_button "Sign in" }
			it { should have_title("Sign in") }
			it { should have_selector("div.alert.alert-error") }
			describe "after visiting another page" do
				before { click_link("Home") }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in(user) }
			it { should have_title(user.name) }
			it { should have_link("Users", href: users_path) }
			it { should have_link("Profile", href: user_path(user)) }
			it { should have_link("Settings", href: edit_user_path(user)) }
			it { should have_link("Sign out", href: signout_path) }
			it { should_not have_link("Sign in", href: signin_path) }
		end
	end

	describe "authorization" do
		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user, email: "gossey@testual.com") }

			describe "in the Users controller" do
				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_title("Sign in") }
				end
				describe "submitting to the update action" do
					before { patch user_path(user) }
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "when attempting to visit a protected page" do
					before do
						visit edit_user_path(user)
						fill_in "Email", 		with: "gossey@testual.com"
						fill_in "Password", with: "foobar"
						click_button "Sign in"
					end
					describe "after signing in it should render settings page" do
						it { should have_content("Edit your profile") }
					end
				end
				describe "all users page" do
			    describe "for un-signed-in visitors" do
			      before { visit users_path }
			      it { should have_title("Sign in") }
			    end
			  end
			end
		end

		describe "as the wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email:'wronguser@foo.com') }
			before { sign_in(user, no_capybara: true) }
			describe "by visiting another user's edit page" do
				before { get edit_user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_url) }
			end
			describe "by submitting patch request to users#update action" do
				before { patch user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end

		describe "as not admin" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before { sign_in non_admin, no_capybara: true }

			describe "submitting a DELETE request to users#destroy" do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end

		describe "ensuring the admin property can't be set" do
			let(:non_admin) { FactoryGirl.create(:user) }
			let(:params) do
				{ user: { admin: true, password: non_admin.password, password_confirmation: non_admin.password } }
			end
			before do 
				sign_in(non_admin)
				patch user_path(:non_admin), params
			end
			specify { expect(non_admin.reload).not_to be_admin }
		end

	end

end
