class PostsController < ApplicationController
  before_action :set_user, only: %i[index create edit show update]
  before_action :set_post, only: %i[edit show update]

  def index
    @user = User.find(params[:user_id])
    @page_size = 10
    @pagy, @posts = pagy_countless(@user.posts.order(created_at: :desc), items: @page_size)
    @post = @user.posts.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show; end

  def create
    @post = @user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.turbo_stream
      else
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to user_post_path(@user, @post) }
      else
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
