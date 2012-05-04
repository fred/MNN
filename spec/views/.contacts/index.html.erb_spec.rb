require 'spec_helper'

describe "contacts/index" do
  before(:each) do
    assign(:contacts, [
      stub_model(Contact,
        name: "Name",
        email: "Email",
        website: "Website",
        phone_number: "Phone Number",
        mobile_number: "Mobile Number",
        country: "Country",
        notes: "MyText",
        user_id: 1
      ),
      stub_model(Contact,
        name: "Name",
        email: "Email",
        website: "Website",
        phone_number: "Phone Number",
        mobile_number: "Mobile Number",
        country: "Country",
        notes: "MyText",
        user_id: 1
      )
    ])
  end

  it "renders a list of contacts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: "Name".to_s, count: 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: "Email".to_s, count: 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: "Website".to_s, count: 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: "Phone Number".to_s, count: 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: "Mobile Number".to_s, count: 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: "Country".to_s, count: 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: "MyText".to_s, count: 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: 1.to_s, count: 2
  end
end
