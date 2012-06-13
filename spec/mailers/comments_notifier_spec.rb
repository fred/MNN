require "spec_helper"

describe CommentsNotifier do

  describe "From a logged in user" do

    let(:comment) { 
      FactoryGirl.create(:comment)
    }
    let(:mail) { CommentsNotifier.new_comment(comment) }

    describe "the actual email" do
      it "should have correct subject" do
        mail.subject.should eq("[New Comment] by #{comment.display_name}")
      end
      it "should send email to inbox" do
        mail.to.should eq(["inbox@worldmathaba.net"])
      end
      it "should have correct from address" do
        mail.from.should eq(["inbox@worldmathaba.net"])
      end
      it "should have correct reply-to address" do
        mail.reply_to.should eq(["inbox@worldmathaba.net"])
      end
    end

  end

end
