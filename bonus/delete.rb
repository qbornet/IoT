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

key_content = File.read('/home/thrio/.ssh/id_ed25519.pub').strip
puts "key: #{key_content}"

k = Key.find_by(key: key_content)

if k
  k.delete
end

puts "del finished"
