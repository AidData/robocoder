class TextGeocoderController < ApplicationController
	require 'open-uri'
	require 'text_geocoder'

	def geocode
		
		# get params
		# call gem with text

		@activities_with_geocode = TextGeocoder::geocode(params["contents"])

		respond_to do |format|
			format.html
			format.json { render json: @activities_with_geocode }
		end

	end

	def test
	end

end
