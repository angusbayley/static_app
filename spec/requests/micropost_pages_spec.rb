require 'spec_helper'

describe "MicropostPages" do
	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	before { sign_in(user) }

	describe "create micropost" do
		before { visit root_path }

		describe "with invalid content" do

			it "should not create a micropost" do
				expect { click_button("Share") }.not_to change(Micropost, :count)
			end

			describe "error messages" do
				before { click_button("Share") }
				it { should have_content('error') }
			end
		end

		describe "with valid content" do
			before { fill_in 'micropost_content', with: 'Lorem ipsum' }
			it "should create a micropost" do
				expect { click_button("Share").to change(Micropost, :count).by(1) }
			end
		end
  end

  describe "micropost destruction" do
  	before { FactoryGirl.create(:micropost, user: user) }

  	describe "as the correct user" do
  		before { visit root_path }

  		it "should delete the micropost" do
  			expect { click_link "delete" }.to change(Micropost, :count).by(-1)
  		end
  	end
  end
end
