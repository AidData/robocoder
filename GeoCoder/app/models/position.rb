class Position < ActiveRecord::Base
	belongs_to :activity
	attr_accessible :lat, :long, :keyword, :address

	acts_as_gmappable lat: "lat", lng: "long", process_geocoding: false

	def gmaps4rails_infowindow
		"""#{activity.identifier} <br>
		#{activity.description} <br>
		#{keyword} <br>
		#{address} <br>
		<a href='/activities/#{activity.id}'>Details</a>
		""".html_safe
	end

	def gmaps4rails_marker_picture
		{
			:picture => "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|#{activity.marker_color}",
			:shadow_picture => "http://chart.apis.google.com/chart?chst=d_map_pin_shadow",
			:width   => 21,
			:height  => 43,
			:marker_anchor => [10, 34],
			:shadow_width => "40",
			:shadow_height => "37",
			:shadow_anchor => [12, 35]
		}
	end

end
