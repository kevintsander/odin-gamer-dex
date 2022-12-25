# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

kevin = User.create(email: 'kevin@kevin.com', password: 'kevin1')
ivy = User.create(email: 'ivy@ivy.com', password: 'ivy123')

kevin.posts.create(body: 'the new call of duty is awesome!')
kevin.posts.create(body: 'this call of duty has no content!')
kevin.posts.create(body: 'when will more content be added? these devs are horrible!')
ivy.posts.create(body: 'call of duty is too mainstream')
ivy.posts.create(body: 'i prefer a more intelligent game like SOMA')
