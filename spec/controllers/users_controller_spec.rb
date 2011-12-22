require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'show" do
    
    before (:each) do
      @user = Factory(:user)
    end
    it "should be successful" do
      get :show, :id => @user.id
      response.should_be_success
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
	    @user = Factory(user)
		test_sign_in(user)
	  end	
	  
	  it "shoud be successful" do
	    get :edit :id => @user
		response should_be_success
	  end
	  
	  
	end

end
