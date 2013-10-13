module ApplicationHelper

  def recent_project(project)
    message = ""
    if project.updated_at == project.created_at
      message = "created"
    else
      message = "updated"
    end
    message << " the project"+ 
               " '#{link_to(project.title, project_path(project))}'"+
               " <em>#{time_ago_in_words(project.updated_at)} ago</em>"
    message.html_safe
  end

  def recent_track(track)
    project = track.project
    message = ""
    if track.updated_at == track.created_at
      message = "created"
    else
      message = "updated"
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
    track = comment.track
    project = track.project
    message = ""
    if comment.updated_at == comment.created_at
      message = "commented '#{truncate(comment.title)}' on"
    else
      message = "updated the comment '#{truncate(comment.title)}' on"
    end
    message << " the track"+
               " '#{link_to(track.title, 
                           project_track_path(project, track))}'"+
               " in the project '#{link_to(project.title, 
                                          project_path(project))}'"+
               " <em>#{time_ago_in_words(comment.updated_at)} ago</em>"
    message.html_safe
  end

end
