class String
  def camelize
    self.split(/[^a-z0-9]/i).map{ |w| w[0, 1].upcase + w[1..-1] }.join
  end
  
  def uncapitalize
    self.sub(/^(.)/) { |m| m.downcase }
  end
end