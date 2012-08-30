require './config/environment.rb'
require 'minitest/autorun'
require 'minitest/spec'

class TestLocale < MiniTest::Unit::TestCase

  describe "Locale" do

    before do
      @test_case = {
        en: [
          ["Testing", "Testing"]
        ],
        nl: [
          ["Testing", "Testung"]
        ],
        pt: [
          ["Testing", "Testando"]
        ]
      }
    end

    describe "Testing locales" do
      it "Should correctly translate" do
        @test_case.each do |t|
          puts "should correctly translate #{t[0]}"
          t[1].each do |l|
            assert_equal l[0], l[1]
          end
        end
      end
    end
  end
end

