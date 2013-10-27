module ProjectsHelper

  def breadcrumbs(links)
    content = "<nav id=\"breadcrumbs\" itemtype=\"http://schema.org/WebPage\" 
                                     itemprop=\"breadcrumb\"><ul>"
    links.each { |link| content << content_tag(:li, link) }
    content << "</ul></nav>"
    content.html_safe
  end

end
