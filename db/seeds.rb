# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
unless User.find_by(username: 'admin')
  admin = User.create(
    name: 'Админ Админыч',
    username: 'admin',
    email: 'admin@example.com',
    password: 'your_password',
    role: :admin
  )

  puts "Admin user created with email: #{admin.email} and password: #{admin.password}"
end