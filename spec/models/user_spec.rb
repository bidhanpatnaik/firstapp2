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
          wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
          wrong_password_user.should be_nil
        end

        it "should return nil for an email address with no user" do
          nonexistent_user = User.authenticate("foo@bar.com", @attr[:password])
          nonexistent_user.should be_nil
        end
        
        it "should return the user email/password match" do
          matching_user = User.authenticate(@attr[:email], @attr[:password])
          matching_user.should == @user
        end
      end #"authenticate method"      
   end #"password encryption"
   describe "micropost associations" do

        before(:each) do
          @user = User.create(@attr)
          @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
          @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
        end
    
        it "should have a microposts attribute" do
          @user.should respond_to(:microposts)
        end
    
        it "should have the right microposts in the right order" do
          @user.microposts.should == [@mp2, @mp1]
        end
    
        it "should destroy associated microposts" do
          @user.destroy
          [@mp1, @mp2].each do |micropost|
            Micropost.find_by_id(micropost.id).should be_nil
          end
         end
    
          describe "status feed" do
      
            it "should have a feed" do
              @user.should respond_to(:feed)
            end
      
            it "should include the user's microposts" do
              @user.feed.include?(@mp1).should be_true
              @user.feed.include?(@mp2).should be_true
            end
      
            it "should not include a different user's microposts" do
              mp3 = Factory(:micropost,
                            :user => Factory(:user, :email => Factory.next(:email)))
              @user.feed.include?(mp3).should be_false
            end
          end   #"status feed" do
          
          describe "relationships" do
            before(:each) do
              @user = User.create!(@attr)
              @followed = Factory(:user)
            end
      
            it "should have a relationships method" do
              @user.should respond_to(:relationships)
            end
            
              it "should have a following method" do
                @user.should respond_to(:following)
              end
              it "should include the followed user in the following array" do
                @user.follow!(@followed)
                @user.following.should include(@followed)
              end
              it "should unfollow a user" do
                @user.follow!(@followed)
                @user.unfollow!(@followed)
                @user.should_not be_following(@followed)
              end
          end  # "relationships" do
           describe "status feed" do
          
                it "should have a feed" do
                  @user.should respond_to(:feed)
                end
          
                it "should include the user's microposts" do
                  @user.feed.should include(@mp1)
                  @user.feed.should include(@mp2)
                end
                
                it "should not include a different user's microposts" do
                  mp3 = Factory(:micropost,
                                :user => Factory(:user, :email => Factory.next(:email)))
                  @user.feed.should_not include(mp3)
                end
          
                it "should include the microposts of followed users" do
                  followed = Factory(:user, :email => Factory.next(:email))
                  mp3 = Factory(:micropost, :user => followed)
                  @user.follow!(followed)
                  @user.feed.should include(mp3)
                end
              end
    end # Association
end
