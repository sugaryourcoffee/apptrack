def user_attributes(override = {})
  {
    name: "Pierre",
    email: "pierre@sugaryourcoffee.de",
    password: "pa55w0rd",
    password_confirmation: "pa55w0rd"
  }.merge(override)
end
