def invitation_attributes(override = {})
  {
    sender: "example@user.com",
    recipients: "guest@user.com, invitee@user.com",
    subject: "Subject of invitation",
    message: "Message of invitation"
  }.merge(override)
end

