module ApplicationHelper

  def recent_user(user)
    message = "'#{link_to(user.name, user_path(user))}'"
    if user.updated_at == user.created_at
      message << " has signed up for apptrack"
    else
      message << " has updated the profile"
    end
    message << " <em>#{time_ago_in_words(user.updated_at)} ago</em>"
    message.html_safe 
  end

  def recent_project(project)
    user = project.user
    message = "'#{link_to(user.name, user_path(user))}'"
    if project.updated_at == project.created_at
      message << " created"
    else
      message << " updated"
    end
    message << " the project"+ 
               " '#{link_to(project.title, project_path(project))}'"+
               " <em>#{time_ago_in_words(project.updated_at)} ago</em>"
    message.html_safe
  end

  def recent_track(track)
    user = track.user
    project = track.project
    message = "'#{link_to(user.name, user_path(user))}'"
    if track.updated_at == track.created_at
      message << " created"
    else
      message << " updated"
    end
    message << " the track"+
               " '#{link_to(track.title, 
                           project_track_path(project, track))}'"+
               " in the project '#{link_to(project.title, 
                                          project_path(project))}'"+
               " <em>#{time_ago_in_words(track.updated_at)} ago</em>"
    message.html_safe
  end

  def recent_comment(comment)
    user = comment.user
    track = comment.track
    project = track.project
    message = "'#{link_to(user.name, user_path(user))}'"
    if comment.updated_at == comment.created_at
      message << " commented '#{truncate(comment.title)}' on"
    else
      message << " updated the comment '#{truncate(comment.title)}' on"
    end
    message << " the track"+
               " '#{link_to(track.title, 
                           project_track_path(project, track))}'"+
               " in the project '#{link_to(project.title, 
                                          project_path(project))}'"+
               " <em>#{time_ago_in_words(comment.updated_at)} ago</em>"
    message.html_safe
  end

  def markdown(text)
    render_options = {
      filter_html: true,
      hard_wrap:   true,
      prettify:    true
    }

    renderer = Redcarpet::Render::HTML.new(render_options)

    extensions = {
      autolinks:          true,
      no_intra_empasis:   true,
      tables:             true,
      fenced_code_blocks: true,
      superscript:        true,
      highlight:          true,
      underline:          true,
      quote:              true
    }

    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end

end
