class PostCommentsController < ApplicationController

	def create
			@post = Post.find(params[:post_id])
    		@post_new = Post.new
    		@post_comment = @post.post_comments.new(post_comment_params)
    		@post_comment.user_id = current_user.id
    		if @post_comment.save
    		flash[:success] = "Comment was successfully created."
    		redirect_to post_path(@post)
    		@post.create_notification_post_comment!(current_user, @post_comment.id)
		else
			post_comments = PostComment.where(post_id: @post)
    	end
	end

	def destroy
		PostComment.find_by(id: params[:id], post_id: params[:post_id]).destroy
    	redirect_to post_path(params[:post_id])
	end

	private

	def post_comment_params
		params.require(:post_comment).permit(:comment)
	end

end
