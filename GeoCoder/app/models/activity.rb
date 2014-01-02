class Activity < ActiveRecord::Base
	attr_accessible :country, :description, :identifier, :title, :marker_color, :precision

	has_many :positions

	after_create :generate_random_color

	def generate_random_color
		if precision == "country"
			self.marker_color = "000000"
		else
			self.marker_color = "%06x" % (rand * 0xffffff)
		end
		
		self.save
	end
end
