# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
Application.create!([
  {
    title: "Secondhand",
    description: "Accounting and analyzing sales at secondhand events",
    active: true
  },
  {
    title: "Secondhand Client",
    description: "Sellers can collect their items for the secondhand event",
    active: true
  },
  {
    title: "App Track",
    description: "Application tracking tool",
    active: true
  },
  {
    title: "Task",
    description: "Managing tasks",
    active: true
  }
])
