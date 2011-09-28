require 'spec_helper'

describe "LayoutLinks" do

  it "Should have a Home page at '/'" do
      get '/'
	  response.should have_selector('title', :content => "Ruby on rail tutorial sample app | Home");
  end
  
  it "Should have a Contact page at '/contact'" do
      get '/contact'
	  response.should have_selector('title', :content => "Ruby on rail tutorial sample app | Contact");
  end
  
  it "Should have a About page at '/about'" do
      get '/about'
	  response.should have_selector('title', :content => "Ruby on rail tutorial sample app | About");
  end  

  it "Should have a Help page at '/help'" do
      get '/help'
	  response.should have_selector('title', :content => "Ruby on rail tutorial sample app | Help");
  end  
  it "Should have a Help page at '/signup'" do
      get '/signup'
	  response.should have_selector('title', :content => "Ruby on rail tutorial sample app | Sign up");
  end  
end
