class Contact < ActiveRecord::Base
  belongs_to :user
  
  
  def self.import(file_name)
    # "Username","Name","Email","Country","Role","Posts","Additional"
    require 'csv'
    csv_array = CSV.read(file_name)
    headers = csv_array.delete_at(0)

    csv_array.each do |row|
      contact = Contact.new
      contact.name    = row[1] unless row[1].to_s.empty?
      contact.email   = row[2] unless row[2].to_s.empty?
      contact.country = row[3] unless row[3].to_s.empty?
      contact.notes   = ""
      contact.notes   += "Username: #{row[0]}\n" unless row[0].to_s.empty?
      contact.notes   += "Role: #{row[4]}\n" unless row[4].to_s.empty?
      contact.notes   += "Posts: #{row[5]}\n" unless row[5].to_s.empty?
      contact.notes   += "Additional: #{row[6]}\n" unless row[6].to_s.empty?
      contact.save
    end
    
  end
end
