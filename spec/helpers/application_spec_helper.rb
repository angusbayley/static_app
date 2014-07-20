require spec_helper.rb

describe ApplicationHelper do

	describe "full_title" do
		it "should include the page title" do
			expect(full_title('About')).to match(/About/)
		end
		it "should include the base title" do
			expect(full_title('')).to match(/^Angus's Sample App/)
		end
		it "should not have a bar for the home page" do
			expect(full_title('')).to_not match(/\|/)
		end
	end
end
