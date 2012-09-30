class Contract::Param
  attr_accessor :name, :type, :attributes

  def initialize values={}
    values.each do |k, v|
      self.send("#{key}=", v) if self.respond_to?(k.to_sym)
    end
  end
end