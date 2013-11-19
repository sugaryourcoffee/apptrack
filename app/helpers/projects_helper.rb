module ProjectsHelper

  def breadcrumbs(links)
    content = "<nav id=\"breadcrumbs\" itemtype=\"http://schema.org/WebPage\" 
                                     itemprop=\"breadcrumb\"><ul>"
    links.each { |link| content << content_tag(:li, link) }
    content << "</ul></nav>"
    content.html_safe
  end

  def row_status_color(status)
    if status == "Done"
      "done"
    elsif status == "Processing"
      "processing #{cycle('list_line_odd', 'list_line_even')}"
    else
      cycle('list_line_odd', 'list_line_even')
    end
  end

end
