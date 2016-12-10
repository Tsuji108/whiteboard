# 100人のテスト用ユーザを作成

# 管理者
User.create!(name:  "Ito Masa",
             email: "mito@example.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

# 雑魚
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@example.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end