# require 'spec_helper'

# describe "application/opensearch" do
#   before do
#     render
#     @xml_element = Nokogiri.XML rendered
#   end
#   context 'short name' do
#     subject { @xml_element.search('ShortName').text }
#     it { should == I18n.translate('default_title') }
#   end

#   context 'search description' do
#     subject { @xml_element.search('Description').text }
#     it { should == I18n.translate('opensearch_description') }
#   end

#   context 'input encoding ' do
#     subject { @xml_element.search('InputEncoding').text }
#     it { should == 'UTF-8' }
#   end
  
#   context 'contact email' do
#     subject { @xml_element.search('Contact').text }
#     it { should == I18n.translate('contact_email') }
#   end

#   context 'image' do
#     subject { @xml_element.search('Image').text }
#     it { should == 'http://test.host/assets/icon.png' }
#   end

#   context 'search terms' do
#     subject { @xml_element.search('Url').attr('template').value }
#     it { should == CGI.unescape(search_url(:q => '{searchTerms}')) }
#   end

# end