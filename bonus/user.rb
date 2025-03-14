#!/usr/bin/env ruby

project_name = 'iot-thrio'
username = 'qbornet'

user = User.new(username: username, email: 'qbornet@example.com', name: 'Quentin Bornet', password: 'kappa1234', password_confirmation: 'kappa1234', admin: true)
user.assign_personal_namespace(Organizations::Organization.default_organization)
user.skip_confirmation!
user.save!

#puts "namespace: #{namespace}"
#puts "user: #{user}"

params = {
  name: project_name,
  visibility_level: Gitlab::VisibilityLevel::PUBLIC,
  initialize_with_readme: true
}

svc = Projects::CreateService.new(user, params)
svc.execute

project = Project.find_by(name: project_name)
key_content = File.read('/home/thrio/.ssh/id_ed25519.pub').strip
puts "key: #{key_content}"

key = Key.new(
  title: 'Main key',
  key: key_content,
  user: user
)

puts "key: #{key}"
puts "Project URL: git@localhost:qbornet/iot-thrio.git"
if key.save
  puts "SSH key saved"
else
  puts "Error adding SSH: #{key.errors.full_messages.join(', ')}"
end
