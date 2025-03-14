#!/usr/bin/env ruby

project_name = 'iot-thrio'
username = 'qbornet'

user = User.find_by_username(username)
namespace = Group.find_by_path(project_name) || User.find_by_username(username)
puts "namespace: #{namespace}"
puts "user: #{user}"

unless defined? user
  user = User.new(username: username, email: 'qbornet@example.com', name: 'Quentin Bornet', password: 'kappa1234', password_confirmation: 'kappa1234', admin: true)
  user.assign_personal_namespace(Organizations::Organization.default_organization)
  user.skip_confirmation!
  user.save!
end

params = {
  name: project_name,
  visibility_level: Gitlab::VisibilityLevel::PUBLIC,
  initialize_with_readme: true
}

svc = Projects::CreateService.new(user, params)
svc.execute

project = Project.find_by(name: project_name)
key_content = File.read('/vagrant/id_rsa.pub').strip

key = Key.new(
  title: 'Main key',
  key: key_content,
  user: user
)

puts "Project URL: #{Gitlab.config.gitlab.url}/#{project.full_path}"
if key.save
  puts "SSH key saved"
else
  puts "Error adding SSH: #{key.errors.full_messages.join(', ')}"
end
