# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# See http://www.zonalatina.com/Zldata29.htm for categories found here:

Category.create([
  { :title => 'Main News', :description => "Main News and Highlights" },
  { :title => 'Opinion', :description => "Opinion, Interviews and Editorial" },
  { :title => 'Economy', :description => "Economy and business" },
  { :title => 'Politics', :description => "Politics" },
  { :title => 'Culture', :description => "Culture, Entertainment, Television, Radio, Music, Movies and Sports" },
  { :title => 'Science', :description => "Medicine, Health, Disease, Drugs and General Science" },
  { :title => 'Technology', :description => "Youth, Computers, Mobiles, Internet, Security and General Technology" },
  { :title => 'Life Style', :description => "Life Style, Family, Cooking, Health, Weather, Climate, Green Energy" }
])

tags = %w{International Economy Business Politics Science Comics 
  Sports Travel Education Culture Media Entertainment Society Interview
  Life Cooking Weather Climate Green Health Medicine Health Issues 
  Crime Violence Technology Computers Mobile Security War Privacy 
  Analysis Opinion Editorial Police General Military Youth Videos
}
tags.each do |t|
  Tag.create(:title => t)
end

region_tags = %w{America Brazil Russia India China
  Asia Libya Middle-East Africa Europe Australia
}
region_tags.each do |t|
  RegionTag.create(:title => t)
end

unless Role.count > 0
  Role.create!(:name => "Admin", :description => "Only For Administration Purposes")
  Role.create!(:name => "Publisher", :description => "Publish Articles to Main Site")
  Role.create!(:name => "Destroyer", :description => "Delete Others Articles")
  Role.create!(:name => "Editor", :description => "Edit Others Articles")
  Role.create!(:name => "Writer", :description => "Create New Articles")
  Role.create!(:name => "Reader", :description => "Can Read all Articles")
  Role.create!(:name => "User", :description => "Can Read, Edit and Delete own Articles")
end


