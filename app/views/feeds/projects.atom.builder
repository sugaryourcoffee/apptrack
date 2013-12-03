atom_feed do |feed|
  feed.title "Latest Project Updates"

  @projects.each do |project|
    feed.entry(project) do |entry|
      entry.title project.title
      entry.summary type: 'xhtml' do |xhtml|
        xhtml.p project.description
        xhtml.table do
          xhtml.tr do
            xhtml.th 'Owner'
            xhtml.td project.user.name
          end
          xhtml.tr do
            xhtml.th 'Active'
            xhtml.td project.active
          end
          xhtml.tr do
            xhtml.th 'Contributors'
            xhtml.td project.contributors.map { |c| c.name }.join(', ')
          end
        end
      end
    end
  end

end
