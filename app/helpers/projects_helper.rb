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

  def selected_values(contributors)
    contributors.collect! {|c| c.id }
  end

  def sequence_numbers(tracks)
    (tracks.collect { |t| t.sequence }).compact.uniq
  end

  def status_types(tracks)
    (tracks.collect { |t| t.status }).compact.uniq
  end

  def category_types(tracks)
    (tracks.collect { |t| t.category }).compact.uniq
  end

  def tracks_status_headline(project)
    headline = ""
    first = true
    Track.status_stats(project.id).count.each do |k,v|
      if first
        first = false
      else
        headline << ", "
      end

      headline << "#{v} #{k}"

    end

    headline.html_safe
  end
end
