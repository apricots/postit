class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:show, :index, :archive]

  def index
    @posts = Post.all.sort_by{|x| x.total_votes}.reverse
  end

  def show
    @comment = Comment.new
    post = Post.find_by(slug: params[:id])
    @comments = Comment.where("post_id = #{post.id}").sort_by { |x| x.total_votes}.reverse
    # parse post object and return json for api
    respond_to do |format|
      format.html
      format.json do
        render json: post
      end
    end

  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user
    if @post.save
      flash[:notice]= "Your post was created."
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit 

  end

  def update

    if @post.update(post_params)
      flash[:notice] = "Your post was edited."
      redirect_to post_path(@post)
    else
      render :edit
    end

  end

  def set_post
    @post = Post.find_by slug: params[:id]
  end

  def vote

    @vote = Vote.create(voteable: @post, creator: current_user, vote:params[:vote])

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

  def archive
    @posts = Post.where(active:false).sort_by{|x| x.total_votes}.reverse
  end



  private
  def post_params
    params.require(:post).permit(:title, :url, :description, :active, category_ids: [])
  end


end
