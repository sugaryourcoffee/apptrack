atom_feed do |feed|
  feed.title "Latest Track Updates"

  @tracks.each do |track|
    project = track.project
    feed.entry(track, url: project_track_url(project, track)) do |entry|
      entry.title track.title
      entry.summary type: 'xhtml' do |xhtml|
        xhtml.p track.description
        xhtml.table do
          xhtml.tr do
            xhtml.th 'Owner'
            xhtml.td track.user.name
          end
          xhtml.tr do
            xhtml.th 'Project'
            xhtml.td project.title
          end
          xhtml.tr do
            xhtml.th 'Status'
            xhtml.td track.status
          end
          xhtml.tr do
            xhtml.th 'Category'
            xhtml.td track.category
          end
        end
      end
    end
  end

end
