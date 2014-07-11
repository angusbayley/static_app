require 'spec_helper'

describe "Static pages" do
  let(:base) {'Ruby on Rails Tutorial Sample App '}

  describe "Home page" do
    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end
    it "Should have the base title" do
      visit '/static_pages/home'
      expect(page).to have_title(base)
    end
    it "Should not have a custom page title" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| Home')
    end
  end
  describe "Help page" do
  	it "should have the content 'Help'" do
  		visit '/static_pages/help'
  		expect(page).to have_content('Help')
  	end
    it "Should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title(base + '| Help')
    end
  end
  describe "About page" do
  	it "should have the content 'About Us'" do
  		visit '/static_pages/about'
  		expect(page).to have_content('About Us')
  	end
    it "Should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title(base + '| About')
    end
  end
  describe "Content page" do
    it "should have the content 'to contact us'" do
      visit '/static_pages/contact'
      expect(page).to have_content('To contact us')
    end
    it "should have the right title" do
      visit '/static_pages/contact'
      expect(page).to have_title('Contact')
    end
  end
end