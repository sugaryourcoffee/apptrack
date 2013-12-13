module StaticPagesHelper

  def humanize_email(array)
    unless array.nil?
      array.join(', ')
    end
  end

end
