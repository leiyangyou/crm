class Contract::Params

  attr_reader :errors

  def initialize
    @params = {}
    @errors = ActiveModel::Errors.new(self)
  end

  def []= name, value
    @params[name.to_s] = value
  end

  def [] name
    @params[name.to_s]
  end

  def each &block
    @params.each block
  end

  def merge params
    @params.merge params
  end

  def method_missing(method, *args, &block)
    if method =~ /=$/
      name = method[0..-2]
      self[name]= args.first
    else
      @params[method]
    end
  end
end