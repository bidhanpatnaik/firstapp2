require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end
        
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign in")
    end
  end # describe "GET 'new'" do
  
  describe "POST 'create'" do
    describe "Invalid Sign in" do
      before (:each) do
        @attr = {:email => "invalid@example.com", :passowrd => "invalid"}
      end
      it "should re-render the new page" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Sign in")
      end
      it "should have the rigth title" do
        post :create, :session => @attr
        response.should render_template('new')
      end    
      it "should have the right flash messgae" do
        post :create, :session => @attr
        #flash.now[:error].should =~ /invlaid/i
      end  
    end #describe "Invalid Sign in" do
    
    describe "With valid email and password" do
      before (:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
 
      end    
       
      it "should sign the user" do
         post :create, :session => @attr
         controller.current_user.should == @user
         controller.should be_signed_in
      end
      
      it "should redirect the user the show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end  
    end #"With valid email and password" do
  end #describe "POST 'create'" do
  
  describe "Delete 'destroy'" do
    it "should sign a user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end
end
