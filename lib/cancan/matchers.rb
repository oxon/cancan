rspec_module = defined?(RSpec::Core) ? 'RSpec' : 'Spec'  # for RSpec 1 compatability
Kernel.const_get(rspec_module)::Matchers.define :be_able_to do |*args|
  match do |ability|
    ability.can?(*args)
  end

  # Check that RSpec is < 2.99
  # see https://github.com/CanCanCommunity/cancancan/blob/86c468639b385e2f4c1175f94afded8726a831fc/lib/cancan/matchers.rb
  if !respond_to?(:failure_message) && respond_to?(:failure_message_for_should)
    alias :failure_message :failure_message_for_should
  end

  if !respond_to?(:failure_message_when_negated) && respond_to?(:failure_message_for_should_not)
    alias :failure_message_when_negated :failure_message_for_should_not
  end

  failure_message do
    resource = args[1]
    if resource.instance_of?(Class)
      "expected to be able to #{args.map(&:to_s).join(' ')}"
    else
      "expected to be able to #{args.map(&:inspect).join(' ')}"
    end
  end

  failure_message_when_negated do
    resource = args[1]
    if resource.instance_of?(Class)
      "expected not to be able to #{args.map(&:to_s).join(' ')}"
    else
      "expected not to be able to #{args.map(&:inspect).join(' ')}"
    end
  end

  description do
    "be able to #{args.map(&:to_s).join(' ')}"
  end
end
