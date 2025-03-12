#!/usr/bin/env ruby

project_name = 'iot-thrio'
username = 'thrio'

user = User.find_by_username(username)

unless user
  user = User.new(username: username, email: 'thrio@example.com', name: 'Thomas Rio', password: 'kappa1234', passowrd_confirmation: 'kappa1234')
  user.assign_personal_namespace(Organizations::Organization.default_organization)
  user.skip_confirmation!
  user.save!
end

params = {
  name: project_name,
  visibility_level: Gitlab::VisibilityLevel::PUBLIC
}

svc = Projects::CreateService.new(user, params)
svc.execute
