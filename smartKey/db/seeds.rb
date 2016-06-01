# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


users = User.create([
                     {
                       phone_num: '13564177740',
                       password: '123456',
                     },
                     {
                       phone_num: '13564177741',
                       password: '112233',
                     }
                    ])
