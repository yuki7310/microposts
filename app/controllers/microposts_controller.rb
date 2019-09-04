class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    re = /@([a-z0-9_]{6,})/i
    @micropost.content.match(re)
    if $1
      reply_user = User.find_by(unique_name: $1.downcase)
      @micropost.in_reply_to = reply_user.id if reply_user
    end
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      @talks = []
      render "static_pages/home"
    end
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted."
    redirect_back(fallback_location: root_url)
  end
  
  private
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end