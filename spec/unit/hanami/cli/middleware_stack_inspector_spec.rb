# frozen_string_literal: true

require "hanami/cli/middleware_stack_inspector"
require "hanami/slice/routing/middleware/stack"

RSpec.describe Hanami::CLI::MiddlewareStackInspector do
  let(:stack) { Hanami::Slice::Routing::Middleware::Stack.new }

  describe "#inspect" do
    it "indents from the longest path" do
      stack.use(Object)
      stack.with("/a/really/really/long/path") { stack.use(Object) }

      inspected = described_class.new(stack: stack).inspect

      expect(inspected).to eq <<~RESULT
        /                             Object
        /a/really/really/long/path    Object
      RESULT
    end

    it "can include inspected arguments" do
      stack.use(Object, "foo")

      inspected = described_class.new(stack: stack).inspect(include_arguments: true)

      expect(inspected).to eq <<~RESULT
        /    Object args: ["foo"]
      RESULT
    end

    context "when middleware is a class" do
      it "includes its name when it's named" do
        stack.use(Object)

        expect(described_class.new(stack: stack).inspect).to include("Object")
      end

      it "includes (class) when is anonymous" do
        stack.use(Class.new)

        expect(described_class.new(stack: stack).inspect).to include("(class)")
      end
    end

    context "when middleware is a module" do
      it "includes its name when it's named" do
        Foo = Module.new
        stack.use(Foo)

        expect(described_class.new(stack: stack).inspect).to include("Foo")
      ensure
        Object.send(:remove_const, :Foo)
      end

      it "includes (module) when is anonymous" do
        stack.use(Module.new)

        expect(described_class.new(stack: stack).inspect).to include("(module)")
      end
    end

    context "when middleware is an instance" do
      it "includes its class name" do
        stack.use(Object.new)

        expect(described_class.new(stack: stack).inspect).to include("Object")
      end

      it "includes (instance)" do
        stack.use(Object.new)

        expect(described_class.new(stack: stack).inspect).to include("(instance)")
      end
    end
  end
end
