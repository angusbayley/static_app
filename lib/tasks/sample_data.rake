namespace :db do
	desc "Fill db with sample data"
	task populate: :environment do
		create_users
		create_microposts
		create_relationships
	end
end

def create_users
	admin = User.create!(
		name: "Example User",
		email: "example@railstutorial.com",
		password: "foobar",
		password_confirmation: "foobar",
		admin: true
	)
	99.times do |n|
		name = Faker::Name.name
		email = "example-#{n+1}@railstutorial.com"
		password = "password"
		User.create!(
			name: name,
			email: email,
			password: password,
			password_confirmation: password
		)
	end
end

def create_microposts
	users = User.all(limit: 6)
	users.each do |user|
		50.times do
			content = Faker::Lorem.sentence(5)
			user.microposts.create(content: content)
		end
	end
end

def create_relationships
	users = User.all
	user = users.first
	followed_users = users[2..50]
	followers = users[3..40]
	followed_users.each do |followed_user|
		user.follow!(followed_user)
	end
	followers.each do |follower|
		follower.follow!(user)
	end
end