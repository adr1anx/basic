require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordsController do
  fixtures :users
  
  before(:each) do
    @user = users(:quentin)
  end
  
  it "should use PasswordsController" do
    controller.should be_an_instance_of(PasswordsController)
  end
  
  describe "creating a password with a valid email" do
    before(:each) do
      @pass = mock "Password"
      Password.stub!(:new).and_return(@pass)
      User.stub!(:find_by_email).with(@user.email).and_return(@user)
      @pass.stub!(:save).and_return(true)
      @pass.stub!(:email).and_return(@user.email)
      @pass.stub!(:user=).and_return(@user)
      @pass.stub!(:reset_code).and_return("valid_reset_code")
    end
    it "should create a new password and send an email" do
      PasswordMailer.should_receive(:deliver_forgot_password).with(@pass)
      post :create, :password => {:email => @user.email}
      flash[:notice].should_not be_nil
      response.should be_redirect
    end
  end
  describe "creating a password with an invalid email" do
    before(:each) do
      @pass = mock "Password"
      Password.stub!(:new).and_return(@pass)
      @pass.stub!(:save).and_return(false)
      @pass.stub!(:email).and_return("wrong@email.com")
      @pass.stub!(:user=).and_return(nil)
    end
    it "should not create a new password with the wrong email" do
      post :create, :password => {:email => "wrong@email.com"}
      flash[:notce].should be_nil
      response.should render_template("new")
    end
  end
  
  describe "resetting a password" do
    before(:each) do
      @pass = mock "Password"
      @pass.stub!(:reset_code).and_return("valid_reset_code")
      @pass.stub!(:user).and_return(@user)
      time_now = Time.now
      Time.stub!(:now).and_return(time_now)
    end
    
    it "with a valid reset_code should render the reset password form" do
      Password.should_receive(:find).with(:first, :conditions => ['reset_code = ? and expiration_date > ?', @pass.reset_code, Time.now]).and_return(@pass)
      get :reset, :reset_code => @pass.reset_code
      response.should_not be_redirect
    end
    
    it "with an invalid reset_code should redirect to new password" do
      Password.should_receive(:find).with(:first, :conditions => ['reset_code = ? and expiration_date > ?', "invalid", Time.now]).and_return([])
      get :reset, :reset_code => "invalid"
      flash[:notice].should_not be_nil
      response.should redirect_to(new_password_path)
    end
    
    it "with valid parameters should update the users password and redirect to the login form" do
      Password.should_receive(:find_by_reset_code).with(@pass.reset_code).and_return(@pass)
      @user.should_receive(:update_attributes).with({"password" => "new_password", "password_confirmation"=>"new_password"}).and_return(true)
      post :update_after_forgetting, {:reset_code => @pass.reset_code, :user => {:password => "new_password", :password_confirmation=>"new_password" } }
      response.should redirect_to(login_path)
    end
    
    it "with invalid parameters should update the users password and redirect to the login form" do
      Password.should_receive(:find_by_reset_code).with(@pass.reset_code).and_return(@pass)
      @user.should_receive(:update_attributes).with({"password" => "new_password2", "password_confirmation"=>"new_password"}).and_return(false)
      post :update_after_forgetting, {:reset_code => @pass.reset_code, :user => {:password => "new_password2", :password_confirmation=>"new_password" } }
      flash[:notice].should eql("Password could not be updated.")
      response.should redirect_to(:action => "reset", :reset_code => @pass.reset_code)
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end


end
