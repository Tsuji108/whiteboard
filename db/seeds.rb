# frozen_string_literal: true
# 100人のテスト用ユーザを作成

# 管理者
User.create!(name:  'Ito Masafumi',
             email: 'mito@example.com',
             password:              'foobar',
             password_confirmation: 'foobar',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(name:  '田中さん',
             email: 'tanaka@example.com',
             password:              'foobar',
             password_confirmation: 'foobar',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

# その他
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@example.com"
  password = 'password'
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end
