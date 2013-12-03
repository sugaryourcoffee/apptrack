atom_feed do |feed|
  feed.title "Latest Comment Updates"

  @comments.each do |comment|
    track = comment.track
    project = track.project
    feed.entry(comment, url: project_track_url(project, track)) do |entry|
      entry.title comment.title
      entry.summary type: 'xhtml' do |xhtml|
        xhtml.p comment.comment
        xhtml.table do
          xhtml.tr do
            xhtml.th 'Author'
            xhtml.td comment.user.name
          end
          xhtml.tr do
            xhtml.th 'Project'
            xhtml.td project.title
          end
          xhtml.tr do
            xhtml.th 'Track'
            xhtml.td track.title
          end
        end
      end
    end
  end

end

