atom_feed do |feed|
  feed.title "Latest Comment Updates"

  @comments.each do |comment|
    track = comment.track
    project = track.project
    feed.entry(comment) do |entry|
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
            xhtml.td link_to project.title project_url project
          end
          xhtml.tr do
            xhtml.th 'Track'
            xhtml.td link_to track.title project_track_url track
          end
        end
      end
    end
  end

end

