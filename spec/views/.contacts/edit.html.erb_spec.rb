require 'spec_helper'

describe "contacts/edit" do
  before(:each) do
    @contact = assign(:contact, stub_model(Contact,
      :name => "MyString",
      :email => "MyString",
      :website => "MyString",
      :phone_number => "MyString",
      :mobile_number => "MyString",
      :country => "MyString",
      :notes => "MyText",
      :user_id => 1
    ))
  end

  it "renders the edit contact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => contacts_path(@contact), :method => "post" do
      assert_select "input#contact_name", :name => "contact[name]"
      assert_select "input#contact_email", :name => "contact[email]"
      assert_select "input#contact_website", :name => "contact[website]"
      assert_select "input#contact_phone_number", :name => "contact[phone_number]"
      assert_select "input#contact_mobile_number", :name => "contact[mobile_number]"
      assert_select "input#contact_country", :name => "contact[country]"
      assert_select "textarea#contact_notes", :name => "contact[notes]"
      assert_select "input#contact_user_id", :name => "contact[user_id]"
    end
  end
end
