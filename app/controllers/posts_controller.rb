class PostsController < ApplicationController

	before_action :authenticate_user!
	
	def new
		@post = Post.new
	end

	def index
		@posts = Post.all
	end

	def show
		@post = Post.find(params[:id])
	end

	def create
		 @post = Post.new(post_params)
    	@post.user_id = current_user.id
  	if @post.save
    	flash[:notice] = "Book was successfully created."
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

	def post_params
		params.require(:post).permit(:body, :event, :category, :status)
	end
end
