require 'spec_helper'



describe UsersController do
  render_views
  
  describe "Get 'index'" do
    describe "for non-signed in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end
     describe "for signed-in users" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :name => "Bob", :email => "another@example.com")
        third  = Factory(:user, :name => "Ben", :email => "another@example.net")
        
        @users = [@user, second, third]
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")
      end
      
      it "should have an element for each user" do
        get :index
        @users.each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end
    end
  end
    

  describe "GET" "show" do
    
    before (:each) do
      @user = Factory(:user)
    end
    it "should be successful" do
      get :show, :id => @user.id
      response.should be_success
    end
    
    it "should find the right  user" do
      get :show, :id => @user.id
      assigns(:user).should == @user 
    end
    
    it "should have the rigth title" do
      get :show, :id => @user.id
      response.should have_selector("title", :content => @user.name)
    end

    it "should have profile image" do
      get :show, :id => @user.id
      response.should have_selector("hi>img", :class => "gravatar")
    end


    it "should show the user's microposts" do
      mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
      mp2 = Factory(:micropost, :user => @user, :content => "Baz quux")
      get :show, :id => @user
      response.should have_selector("span.content", :content => mp1.content)
      response.should have_selector("span.content", :content => mp2.content)
    end
  end
  

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Ruby on rail tutorial sample app | Sign up")
    end
    
    
    describe "POST create" do
       describe "failure" do
         before (:each) do
           @attr = {:name => "", :email =>"", :password => "", :confirmation_password => ""}
         end
         
         it "should not create user" do
           lambda do
             post :create, :user => @attr
           end.should_not change(User, :count)
         end
         
         it "should have the right title" do
           post :create, :user => @attr
           response.should have_selector("title", :content => "Sign up")
         end
         it "should render the 'new' page" do
           post :create, :user => @attr
           response.should render_template("new")
         end
       end
    end
    
    describe "Success " do
      before (:each) do
        @attr = {:name => "K Mishara", :email =>"kmishra@examples.com", :password => "foobar", :confirmation_password => "foobar"}
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.current_user == @user
        controller.should be_signed_in
      end
      
    end #describe "Success " do
	
	describe "Get 'edit' " do	
	  before (:each) do
	    Auser = Factory(:user)
	    user = User.authenticate(Auser.email, Auser.password)
  	  test_sign_in(user)
	  end	
	  
    it "shoud be successful" do
     controller.should be_signed_in
     get :edit, :id => 2
  		response should_be_success
    end
	end
	
  describe "Authentication of Edit and Update page" do

    before (:each) do
      @user = Factory(:user)
    end
    
    describe "Non signed in users" do
      it "should deny access to edit" do
        get :edit, :id => @user
        response.should redirect_to (signin_path)
      end
      it "should deny access to update" do
         put :update, :id => @user
         response.should redirect_to (signin_path)
      end
    end
    
    describe "For signed in users" do
       before (:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
       end
       
      it "should require matching user edit" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
       it "should require matching user for update" do
        put :update, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    
     describe "For signed in users - postetive use case" do
       before (:each) do
         correct_user = Factory(:user, :email => "rightuser@gamil.com")
         test_sign_in(correct_user)
       end
       
      it "user should be able to edit and update his own info" do
        get :edit, :id => @correct_user
        response.should redirect_to(edit_path)
      end
       it "should require matching user for update" do
        put :update, :id => @correct_user
        response.should redirect_to(edit_path)
      end
    end
    
  end
end
