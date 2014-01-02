class ActivitiesController < ApplicationController
	require 'json'

	def index
		@activities = Activity.all
	end

	def show
		@activity = Activity.find params[:id]
		@json = @activity.positions.to_gmaps4rails
	end

	def new
		@activity = Activity.new
	end

	def create
		contents = params["iati_xml"]
		@activities = JSON.parse params["activities_with_geocode"]

		@activities.delete(@activities.last)

		@activities.each do |activity|
			activity_obj = Activity.find_by_identifier activity["uid"]
			if activity_obj.nil?
				activity_obj = Activity.create(identifier: activity["uid"], precision: activity["precision"])

				activity["positions"].each do |position|
					activity_obj.positions << Position.create(lat: position["latitude"].to_f, long: position["longitude"].to_f, address: position["address"])
				end

			end
		end

		response = Nokogiri::XML(contents)

		# loop each activity
		response.xpath("//iati-activity").each do |activity|

			# get iati-identifier
			iati_id = activity.at("iati-identifier").text

			# store recipient country 
			rcpt_country = activity.at("recipient-country")
			
			# eliminate records with multi country data
			if rcpt_country and rcpt_country.attr("percentage") == "100"

				# find country name
				country = IsoCountryCodes.find(rcpt_country.attr("code")).name

				# loop each description in activities
				Nokogiri::XML(activity.to_s).xpath("//description").each do |desc|

					# find the correct and English description 
					if desc.attr("type") and desc.attr("xml:lang") == "en"

						activity_obj = Activity.find_by_identifier iati_id

						if activity_obj
							activity_obj.update_attributes(description: desc.text, country: country)
							activity_obj.save
						end
					end
				end
			end
		end # end of loop

		redirect_to :root

	end
end
