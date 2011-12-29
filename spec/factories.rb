Factory.define :user do |user|
  user.name                   "Bidhan Patnaik"
  user.email                  "bidhan@patnaiks.com"
  user.password               "hanuman"
  user.password_confirmation  "hanuman"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content "Foo bar"
  micropost.association :user
end