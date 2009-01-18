require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Password do
  fixtures :users
  before(:each) do
    @user = users(:quentin)
  end

  describe "with valid attributes" do
    before(:each) do
      @pass = Password.create(:email => @user.email, :user_id => @user.id)
      @pass.should be_valid
    end
    it "should populate a reset_code" do
      @pass.reset_code.should_not be_nil
    end
  
    it "should set expiration date 2 weeks from today" do
      @pass.expiration_date.to_s.should eql(2.weeks.from_now.to_s)
    end
  end
end
