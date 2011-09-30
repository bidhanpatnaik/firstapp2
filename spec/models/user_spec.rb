require 'spec_helper'

describe User do
  before (:each) do
    @attr = {:name => "Example User", 
            :email =>"user@example.com",
            :password => "foobar",
            :password_confirmation => "foobar"}
  end
  
  it "should create a new instance given alid attributes" do
    User.create!(@attr)
  end
  
  it"should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it"should require a emai" do
    no_name_user = User.new(@attr.merge(:email => ""))
    no_name_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 50;
    long_name_user =  User.new(@attr.merge(:name => long_name))
  end
  
  it "should accept valid email address" do
    addresses = %w[user@foo.com example.user@foo.in]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email address" do
    addresses = %w[user@foo foo.in]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should_not be_valid
    end
  end
  
  it "should accept duplicate email address" do
     User.create(@attr)
     user_with_duplicate_email = User.new(@attr);
     user_with_duplicate_email.should_not be_valid
  end  
  
  #------------------------------------------
  #  
  describe "password validation" do
    it "should require password" do
      User.new(@attr.merge(:password => "", :password_confirmation => ""))
      should_not be_valid
    end
    it "should require matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid"))
      should_not be_valid
    end    
    
    it "should reject short  password" do
      short = "a" * 5
      User.new(@attr.merge(:password => short, :password_confirmation => short))
      should_not be_valid
    end
  
    it "should reject short  password" do
      long = "a" * 41
      User.new(@attr.merge(:password => long, :password_confirmation => long))
      should_not be_valid
    end  
  end #describe "Password validation"
  
  #------------------------------------------
  #
   describe "password encryption" do
     before(:each) do
       @user = User.create!(@attr)
     end

     it "should have an encrypted password attribute" do
       @user.should respond_to(:encrypted_password)
     end

     it "should set the encrypted" do
       @user.encrypted_password.should_not be_blank
     end
     #------------------------------------------
     #
      describe "Has_password? method"  do
        it "shoud be true if the passwords match" do
          @user.has_password?(@attr[:password]).should be_true
        end

        it "shoud be false if the passwords do not match" do
          @user.has_password?("invalide").should be_false
        end        
      end #"Has_password? method"

      #------------------------------------------
      #      
      describe "authenticate method"  do
        it "should return nil on email/password mismatch" do
          wrong_password_user = user.authenticate(@attr[:email], "wrongpass")
          wrong_password_user.should be_nil
        end

        it "should return nil for an email address with no user" do
          nonexistent_user = user.authenticate("foo@bar.com", @attr[:password])
          nonexistent_user.should be_nil
        end
        
        it "should return the user email/password match" do
          matching_user = user.authenticate(@attr[:email], @attr[:password])
          matching_user.should == @user
        end
      end #"authenticate method"      
   end #"password encryption"
end
