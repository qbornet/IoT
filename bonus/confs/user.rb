#!/usr/bin/env ruby

project_name = 'iot-thrio'
username = 'qbornet'

user = User.new(username: username, email: 'qbornet@example.com', name: 'Quentin Bornet', password: 'kappa1234', password_confirmation: 'kappa1234', admin: true)
user.assign_personal_namespace(Organizations::Organization.default_organization)
user.skip_confirmation!
user.save!

params = {
  name: project_name,
  visibility_level: Gitlab::VisibilityLevel::PUBLIC
}

svc = Projects::CreateService.new(user, params)
svc.execute

project = Project.find_by_full_path('qbornet/iot-thrio')
usr = User.find_by_username('qbornet')
token = usr.personal_access_tokens.create(
  name: 'push fix',
  scopes: ['api', 'read_repository', 'write_repository'],
  expires_at: 30.days.from_now
)

puts "Project URL: http://qbornet:#{token.token}@localhost:9999/qbornet/iot-thrio.git"
