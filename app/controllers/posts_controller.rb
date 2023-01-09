class PostsController < ApplicationController
  before_action :set_user, only: %i[index create edit show update]
  before_action :set_post, only: %i[edit show update destroy]

  def index
    @user = User.find(params[:user_id])
    @page_size = 10

    cookies.permanent[:feed] = params[:feed] if params[:feed] # user can set preference
    @feed = cookies[:feed] || 'true' # default to true if no preference has been set

    if current_user == @user && @feed == 'true'

      @pagy, @posts = pagy_countless(@user.posts.union(@user.friend_posts).includes(:user, reactions: :user).with_attached_images.order(created_at: :desc), items: @page_size,
                                                                                                                                                            overflow: :empty_page)
    else
      @pagy, @posts = pagy_countless(@user.posts.includes(:user, reactions: :user).with_attached_images.order(created_at: :desc), items: @page_size,
                                                                                                                                  overflow: :empty_page)

    end
    @post = @user.posts.new

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def show; end

  def create
    @post = @user.posts.build(post_params)

    flash.alert = @post.errors.full_messages unless @post.save

    respond_to do |format|
      format.turbo_stream
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

  def destroy
    respond_to do |format|
      if @post.destroy
        format.turbo_stream
      else
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, images: [])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
