# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def add_meta_tags
		content_for :head, "<meta name=\"keywords\" content=\"#{@page.meta_keywords}\" />" unless @page.meta_keywords.blank?
		content_for :head, "<meta name=\"description\" content=\"#{@page.meta_description}\" />" unless @page.meta_description.blank?
  end
  
  def add_page_title
		content_for :title, 
		if @page.browser_title.blank?
    	@page.path
    else
    	@page.browser_title
    end
  end
  
  def setup
    add_meta_tags
    add_page_title
  end
  
  def page_title
    case @page.custom_title_type
      when "none"
        @page.title
      when "text"
        @page.custom_title
      when "image"
        image_fu @page.custom_title_image, nil, {:alt => @page.title} rescue @page.title
    end
  end
  
  def descendant_page_selected?(page)
		not page.descendants.reject {|descendant| not selected_page?(descendant) }.empty?
  end
  
  def selected_page?(page)
    selected = current_page?(page) or (request.path =~ Regexp.new(page.menu_match) unless page.menu_match.blank?) or (request.path == page.link_url)
  end	

	def image_fu(image, thumbnail, options={})
		begin
			image_thumbnail = image.thumbnails.collect {|t| t if t.thumbnail == thumbnail.to_s}.compact.first unless thumbnail.nil?
			image_tag image_thumbnail.public_filename, {:width => image_thumbnail.width, :height => image_thumbnail.height}.merge!(options)
		rescue
			image_tag image.public_filename(thumbnail), options
		end
	end
	
end