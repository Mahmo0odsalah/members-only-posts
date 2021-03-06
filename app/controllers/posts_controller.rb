class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_member!, except: [:show, :index]
  before_action :authorize_author, only: [:edit, :update, :destroy]

  helper_method :is_author?
  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post = Post.find(params[:id])
    @is_author = is_author?
  end

  # GET /posts/new
  def new
    @post = current_member.posts.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_member.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:text)
    end
    
    def is_author? (post = @post)
      member_signed_in? && current_member.id == post.member_id
    end

    def authorize_author
      unless is_author?
        flash[:notice] = "You can only edit/ delete your own posts"
        redirect_to @post
      end
    end

    
end
