class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build 
      @feed_items = current_user.feed.page(params[:feed_page]).search(params[:search])
      @talks = current_user.talks.page(params[:talks_page])
    end 
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
