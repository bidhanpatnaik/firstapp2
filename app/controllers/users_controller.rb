class UsersController < ApplicationController
  
  #before_filter :authenticate, :only => [:index, :edit, :update];
  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :authorized_user, :only => [:edit, :update];
  before_filter :authenticate, :except => [:show, :new, :create]
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcom to the sample app"
      redirect_to @user
    else
      @title="Sign up"
      render 'new'
    end 
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] =  "Profile updated."
      redirect_to @user
    else
      @Ttile = 'Edit User'
      render :action => "edit"
    end
  end
  
  def edit
    @title="Edit user"
    @user = User.find(params[:id])
    render :action => "edit", :id => @user.id
  end
  
  def index
    @title="All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
  
private


end
