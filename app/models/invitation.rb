class Invitation < Message

  validate :validate_recipients

  def initialize(attributes = {})
    if not attributes.nil? and attributes[:recipients]
      attributes[:recipients] = attributes[:recipients].split(/ ?[ |,|;] ?/)
    end
    super(attributes)
  end

  def validate_recipients
    if recipients.nil? or recipients.empty?
      errors.add(:recipients, "must not be empty")
    else
      valid_emails = recipients.map { 
                       |email| email.match(Message::EMAIL_PATTERN) 
                     }.compact.map { |valid| valid.string }

      (recipients - valid_emails).each do |email|
        errors.add(:recipient, "#{email} is not valid")
      end
    end
  end

end
