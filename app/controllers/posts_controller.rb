class PostsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts.order(created_at: :desc)
    @post = @user.posts.new
    p '8' * 1000
    p 'did i make it here?'
  end

  def create
    @user = User.find(params[:user_id])
    @post = @user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.turbo_stream
      else
        format.html { ender :index, status: :unprocessable_entity }
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
