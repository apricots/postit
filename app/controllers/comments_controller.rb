class CommentsController < ApplicationController

  before_action :require_user

  def create
    @post = Post.find_by slug: (params[:post_id])
    @comment = Comment.new(comment_params)
    @comment.creator = current_user
    @comment.post = @post
    @comments = Comment.where("post_id = #{params[:post_id]}")

    if @comment.save
      flash[:notice] = "Comment submitted."
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end

  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.create(voteable: @comment, creator: current_user, vote:params[:vote])
  
    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote was counted."
        else
          flash[:error] = "You can only vote once."
        end
        redirect_to :back
      end
      format.js
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end