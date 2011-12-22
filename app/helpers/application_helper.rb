module ApplicationHelper

	def title
		base_title = "Ruby on rail tutorial sample app"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end 
	end
	
	def logo
	  image_tag("logo.png", :alt => "Sample app", :class => "round")
	end
end
