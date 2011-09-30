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
  
end
