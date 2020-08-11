class PostsController < ApplicationController

	before_action :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy]
	
	def new
		@post = Post.new
	end

	def index
		@posts = Post.page(params[:page])
  		@search = Post.ransack(params[:q])
  		@q_posts = @search.result.page(params[:page])
	end

	def show
		@post = Post.find(params[:id])
		@post_comment = PostComment.new
    	@post_comments = @post.post_comments
	end

	# フォローユーザーのみの投稿一覧（タイムライン）（この書き方でフォローしているユーザーは持ってこれたっぽい）

	def following_posts
		@user = current_user
		@users = @user.following_user
	end

	def create
		 @post = Post.new(post_params)
    	@post.user_id = current_user.id
  	if @post.save
    	flash[:notice] = "successfully"
    	redirect_to post_path(@post.id)
  	else
    	@posts = Post.all
    
    	render action: :index 
  	end
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		@post = Post.find(params[:id])
    if @post.update(post_params)
        flash[:notice] = "Post was successfully updated."
       redirect_to post_path(@post.id)
  	else
      
      render action: :edit
  	end
	end

	def destroy
		 @post = Post.find(params[:id])
    	@post.destroy
    	redirect_to posts_url
	end

	def correct_user
  		@post = current_user.posts.find_by(id: params[:id])
    	unless @post
      		redirect_to posts_path
    	end
	end

	private
	def post_params
		params.require(:post).permit(:body, :event, :category, :status, :start_time)
	end
end
