require './spec/spec_helper'

class AbstractMethodsSpec < StsProxySpec
  describe AbstractMethods do
    class Parent
      extend AbstractMethods

      abstract_methods :do_magic
    end

    class ChildBroken < Parent
    end

    class Child < Parent
      def do_magic
        'work'
      end
    end

    it 'runs a method on a child without errors' do
      child_instance = Child.new
      assert_equal child_instance.do_magic, 'work'
    end

    it 'raises an error on a class without implemented method' do
      broken_child_instance = ChildBroken.new
      -> { broken_child_instance.do_magic }.must_raise NotImplementedError
    end
  end
end
