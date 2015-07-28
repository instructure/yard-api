# @API Shirts
class ShirtsController < ApplicationController
	def index
	end

	# @API Create a new shirt
	# 
	# @argument [String] shirts[color]
	#  The color of the shirt.
	#  
	# @argument [String, ["S","M","L","XL"]] shirts[size]
	#  The size of shirts you wear.
	def create
	end

	# @API Return a shirt
	# @beta 
	# 
	# Return a shirt, probably 'cause you don't like it.
	# 
	# @argument [Integer] shirt_id
	#  ID of the shirt you want to return.
	def return
	end
end