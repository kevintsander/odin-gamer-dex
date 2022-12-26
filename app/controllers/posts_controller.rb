class PostsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @pagy, @posts = pagy_countless(@user.posts.order(created_at: :desc), items: 10)
    @post = @user.posts.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
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
