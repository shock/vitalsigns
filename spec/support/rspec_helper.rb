class Object
  def self.instance_stub method
    new_method = self.method(:new)

    self.stub!(:new).and_return do |*args, &block|
      instance = new_method.call(*args, &block)
      instance.stub(method)
      instance
    end
  end
end
