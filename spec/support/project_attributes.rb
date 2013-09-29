def project_attributes(overrides = {})
  {
    title: "Cool application",
    description: "Description of a cool application",
    active: true
  }.merge(overrides)
end
