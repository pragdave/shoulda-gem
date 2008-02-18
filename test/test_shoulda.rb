require 'test/unit'
require 'shoulda'

class ShouldaTest < Test::Unit::TestCase # :nodoc:

  def test_should_be_compatible_with_regular_tests
    assert true
  end
  
  context "context with setup block" do
    setup do
      @blah = "blah"
    end
    
    should "have @blah == 'blah'" do
      assert_equal "blah", @blah
    end
    
    should "have name set right" do
      assert_match(/^test: context with setup block/, self.to_s)
    end

    context "and a subcontext" do
      setup do
        @blah = "#{@blah} twice"
      end
      
      should "be named correctly" do
        assert_match(/^test: context with setup block and a subcontext should be named correctly/, self.to_s)
      end
      
      should "run the setup methods in order" do
        assert_equal @blah, "blah twice"
      end
    end
  end

  context "another context with setup block" do
    setup do
      @blah = "foo"
    end
    
    should "have @blah == 'foo'" do
      assert_equal "foo", @blah
    end

    should "have name set right" do
      assert_match(/^test: another context with setup block/, self.to_s)
    end
  end
  
  context "context with method definition" do
    setup do
      def hello; "hi"; end
    end
    
    should "be able to read that method" do
      assert_equal "hi", hello
    end

    should "have name set right" do
      assert_match(/^test: context with method definition/, self.to_s)
    end
  end
  
  context "another context" do
    should "not define @blah" do
      assert ! self.instance_variables.include?("@blah")
    end
  end
  
  should_eventually "that fails should actually pass, since it's unimplemented" do
    flunk "what?"
  end

end
