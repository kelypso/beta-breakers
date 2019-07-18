class SessionsController < ApplicationController
  def home
    render :home
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: params[:user][:username]) # form_for creates nested hash!
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id 
      redirect_to user_path(@user)
    else 
      render :new
    end
  end

  def oauth_create
    @user = User.find_or_create_by(uid: auth['uid']) do |u|
      u.name = oauth['info']['name']
      u.email = oauth['info']['email']
      u.password = SecureRandom.hex
    end 
    session[:user_id] = @user.id
    redirect_to user_path(@user)
  end

  def logout
    session.clear
    redirect_to '/'
  end

  private 

  def oauth 
    request.env['omniauth.auth']
  end
end
