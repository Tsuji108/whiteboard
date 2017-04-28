# 承認パス
AcceptPass.create!(accept_pass: 'test')

# 管理者
User.create!(name:  'ito',
             email: 'mito@example.com',
             password:              'foobar',
             password_confirmation: 'foobar',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
             
User.create!(name:  'soneda',
             email: 'soneda@example.com',
             password:              'foobar',
             password_confirmation: 'foobar',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  'sajima',
             email: 'sajima@example.com',
             password:              'foobar',
             password_confirmation: 'foobar',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  'test',
             email: 'test@example.com',
             password:              'foobar',
             password_confirmation: 'foobar',
             admin: true,
             activated: false)

# # その他
# 299.times do |n|
#   name  = Faker::Name.name
#   email = "example-#{n + 1}@example.com"
#   password = 'password'
#   User.create!(name:  name,
#                email: email,
#                password:              password,
#                password_confirmation: password,
#                activated: true,
#                activated_at: Time.zone.now)
# end
