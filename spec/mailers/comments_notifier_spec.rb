require "spec_helper"

describe CommentsNotifier do

  describe "Notifying Admin" do
    let(:comment) { 
      FactoryGirl.create(:comment)
    }
    let(:mail) { CommentsNotifier.to_admin(comment) }
    describe "the actual email" do
      it "should have correct subject" do
        expect(mail.subject).to eq("[New Comment] by #{comment.display_name}")
      end
      it "should send email to inbox" do
        expect(mail.to).to eq(["inbox@worldmathaba.net"])
      end
      it "should have correct from address" do
        expect(mail.from).to eq(["inbox@worldmathaba.net"])
      end
      it "should have correct reply-to address" do
        expect(mail.reply_to).to eq(["inbox@worldmathaba.net"])
      end
    end
  end

end
