#!/usr/bin/env ruby

project_name = 'iot-thrio'
username = 'qbornet'

u = User.where(username: username)
if u
  #puts "delete existing user"
  u.delete_all
end

all_ns = Namespace.where.not(id: 1)

puts "namespaces: found = #{all_ns}"
all_ns.reverse_each { |ns| puts "ns: #{ns}"; ns.delete }

email = Email.where.not(id: 1)
if email
  email.delete_all
end

puts "del finished"
