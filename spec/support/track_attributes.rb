def track_attributes(overrides = {})
  { title: "My Track",
    description: "Description of my track",
    category: "Feature",
    status: "Open",
    version: "1.2.3"
  }.merge(overrides)
end
