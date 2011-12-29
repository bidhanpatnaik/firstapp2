require 'spec_helper'

describe "FriendlyForwardings" do
  
  it "Should forward to the reqeusted page after signin" do
    user = Factory(:user)
    visit edit_user_path(user);
    response.should render_template('sessions/new')
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
    response.should render_template('user/edit')   
  end
end
