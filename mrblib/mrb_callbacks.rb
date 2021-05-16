module Callbacks
  class Error < StandardError; end

  # @api private
  def self.included(base)
    base.extend ClassMethods
  end

  # Class methods
  module ClassMethods
    # Define callback with kind and target method
    #
    # @param [Symbol, String] kind the kind of the callback, possible values are: :before, :after and :around
    # @param [Symbol, String] target the name of the targeted method
    def define_callback(kind, target, **options, &block)
      raise ArgumentError, 'You must provide a block' unless block

      original_method = instance_method(target)
      undef_method(target)
      define_method(target, &method_body(kind, original_method, options[:if], &block))
    end

    private

    def method_body(kind, original_method, if_proc, &block) case kind.to_sym
      when :before then _before(original_method, if_proc: if_proc, &block)
      when :after  then _after(original_method, if_proc: if_proc, &block)
      when :around then _around(original_method, if_proc: if_proc, &block)
      else
        raise Error, "#{kind} is not supported."
      end
    end

    def _before(original_method, if_proc:, &block)
      Proc.new do |*args, &blk|
        if if_proc.nil? || instance_eval(&if_proc) != false
          hook_result = instance_eval(*args, &block)
          return if hook_result == false
        end

        original_method.bind(self).call(*args, &blk)
      end
    end

    def _after(original_method, if_proc:, &block)
      Proc.new do |*args, &blk|
        original_method.bind(self).call(*args, &blk)
        instance_eval(*args, &block) if if_proc.nil? || instance_eval(&if_proc) != false
      end
    end

    def _around(original_method, if_proc:, &block)
      Proc.new do |*args, &blk|
        wrapper = -> { original_method.bind(self).call(*args, &blk) }
        block.call(wrapper) if if_proc.nil? || instance_eval(&if_proc) != false
      end
    end
  end
end
