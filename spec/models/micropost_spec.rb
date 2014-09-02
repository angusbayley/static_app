require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user) }
  before do
  	@micropost = user.microposts.build(content: 'Lorem Ipsum')
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

  describe "when the micropost is blank" do
  	before { @micropost.content = " " }
  	it { should_not be_valid }
  end

  describe "when the micropost is too long" do
  	before { @micropost.content = "a"*141 }
  	it { should_not be_valid }
  end

  # describe "saving a valid post" do
  # 	expect do
  # 		Micropost.create(user_id: user, content: "Lorem Ipsum")
  # 	end.to increase(Micropost).by(1)
  # 	it { should be_valid }
  # end
end
