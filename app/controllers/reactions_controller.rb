class ReactionsController < ApplicationController
  def create
    @post = Post.find(params[:id])
    reaction = @post.reactions.find_or_initialize_by(user_id: current_user.id)

    respond_to do |format|
      if reaction.persisted? && reaction.destroy
        format.turbo_stream
      elsif reaction.save
        format.turbo_stream
      else
        format.html { render user_path(@post.user) }
      end
    end
  end
end
