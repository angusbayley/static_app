require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "exampleuser@email.com", password: "foobar", password_confirmation: "foobar") }
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:remember_token) }

  it { should be_valid }
  it { should_not be_admin }

  describe "when name is not present" do
  	before { @user.name = " " }
  	it { should_not be_valid }
  end

  describe "when email is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "if name is too long" do
  	before { @user.name = "a" * 51 }
  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
  	it "should be invalid" do
  		addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |address|
        	@user.email = address
        	expect(@user).to_not be_valid
        end
    end
  end

  describe "when email format is valid" do
  	it "should be valid" do
  		addresses = %w[example@user.com user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
  		addresses.each do |address|
  			@user.email = address
  			expect(@user).to be_valid
  		end
  	end
  end

  describe "when the email address is already taken" do
  	before do
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	end
  	it { should_not be_valid }
  end

  describe "when the password is not present" do
  	before do 
  		@user = User.new( name: "Example User", email: "user@example.com", password: " ", password_confirmation: " ")
  	end
  	it { should_not be_valid }
  end

  describe "when the passwords don't match" do
  	before { @user.password_confirmation = "mismatch" }
  	it { should_not be_valid }
  end

  describe "return value of authenticate method" do
  	before { @user.save }
  	let(:found_user) { User.find_by(email: @user.email) }

  	describe "with invalid password" do
  		let(:user_with_invalid_password) { found_user.authenticate("invalid") }
  		it { should_not eq user_with_invalid_password }
  		specify { expect(user_with_invalid_password).to be_false }
  	end

  	describe "with valid password" do
  		it { should eq found_user.authenticate(@user.password) }
  	end

  	describe "with a password that's too short" do
  		before { @user.password = @user.password_confirmation = "a"*5 }
  		it { should be_invalid }
  	end
  end

  describe "when the email address contains capitals" do
    let(:mixcase_email) { "ExAmPlE@fOo.com" }
    it "should be saved as lower case" do
      @user.email = mixcase_email
      @user.save
      expect(@user.reload.email).to eq mixcase_email.downcase
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "with 'admin' set to true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:old_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago) }
    let!(:new_micropost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago) }
    it "should order microposts in reverse chronological order" do
      expect(@user.microposts.to_a).to eq [new_micropost, old_micropost]
    end
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
       expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end
    describe "status" do    
      let(:unfollowed_micropost) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }
      let(:followed_micropost) { FactoryGirl.create(:micropost, user: followed_user) }
      before { @user.follow!(followed_user) }
    
      its(:feed) { should include(old_micropost) }
      its(:feed) { should include(new_micropost) }
      its(:feed) { should_not include(:unfollowed_micropost) }
      its(:feed) { should include(followed_micropost) }
    end
  end

  describe "following" do
    let(:followed_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(followed_user)
    end
    it "should be following the followed_user" do
      expect(@user.followed_users).to include(followed_user)
    end

    describe "unfollowing" do
      before { @user.unfollow!(followed_user) }
      it { should_not be_following(followed_user) }
    end
  end

  describe "followed by" do
    let(:follower) { FactoryGirl.create(:user) }
    before do
      @user.save
      follower.follow!(@user)
    end
    it "should be followed by the follower" do
      expect(@user.followers).to include(follower)
    end
  end
end
