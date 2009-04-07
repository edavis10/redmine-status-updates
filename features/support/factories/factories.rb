# Redmine specific Factories
Factory.define :user do |u|
  u.mail { Faker::Internet.email }
  u.firstname { Faker::Name.first_name }
  u.lastname  { Faker::Name.last_name }
  u.login { Faker::Internet.user_name }
end

Factory.define :project do |p|
  p.name { Faker::Name.name }
  p.identifier { Faker::Internet.domain_word.downcase }
  p.enabled_modules {|modules|
    mod = []
    ['issue_tracking', 'statuses'].each do |name|
      mod << modules.association(:enabled_module, :name => name)
    end
    mod
  }
end

Factory.define :enabled_module do |em|
  em.name { 'issue_tracking' }
end

Factory.define :member do |m|
  m.project {|project| project.association(:project) }
  m.user {|user| user.association(:user) }
  m.role {|role| role.association(:role) }
end

Factory.sequence :role_position do |n|
  n
end

Factory.define :role do |r|
  r.name { Faker::Name.name }
  r.position { Factory.next :role_position }
  r.permissions { [ :view_statuses ] }
end

# Plugin specific Factories
Factory.define :status do |s|
  s.user {|user| user.association(:user)}
  s.project {|project| project.association(:project)}
  s.message { Faker::Company.bs }
end
