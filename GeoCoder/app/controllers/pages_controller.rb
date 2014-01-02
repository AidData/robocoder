class PagesController < ApplicationController
	def index
		@json = Position.all.to_gmaps4rails
	end
end
