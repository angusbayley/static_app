require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before do
  	@micropost = user.micropost.build(content: 'Lorem Ipsum')
  end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when the user id is not set" do
  	before { @micropost.user_id = nil }
  	it { should_not be_valid }
  end
end
