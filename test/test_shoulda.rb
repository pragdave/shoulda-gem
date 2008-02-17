require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'shoulda')
require 'rubygems'
require 'mocha'

class TestShoulda < Test::Unit::TestCase # :nodoc:

  should "be able to define a should statement outside of a context" do
    assert true
  end
  
  context "Inside a context" do
    should "be able to define a should statement" do
      assert true
    end
  end
  
  context "Context with setup block" do
    setup do
      @blah = "blah"
    end
    
    should "have @blah == 'blah'" do
      assert_equal "blah", @blah
    end
    
    should "have name set right" do
      assert_match(/^test: Context with setup block/, self.to_s)
    end

    context "and a subcontext" do
      setup do
        @blah = "#{@blah} twice"
      end
      
      should "be named correctly" do
        assert_match(/^test: Context with setup block and a subcontext should be named correctly/, self.to_s)
      end
      
      should "run the setup methods in order" do
        assert_equal @blah, "blah twice"
      end
    end
  end

  context "Another context with setup block" do
    setup do
      @blah = "foo"
    end
    
    should "have @blah == 'foo'" do
      assert_equal "foo", @blah
    end

    should "have name set right" do
      assert_match(/^test: Another context with setup block/, self.to_s)
    end
  end
  
  #context "context with method definition" do
  #  def hello; "hi"; end
  #  
  #  should "be able to read that method" do
  #    assert_equal "hi", hello
  #  end
  #end
  
  context "Another context without setup" do
    should "not define @blah" do
      assert ! self.instance_variables.include?("@blah")
    end
  end
  
  should_eventually "pass, since it's a should_eventually" do
    flunk "what?"
  end

  # Context creation and naming

  def test_should_create_a_new_context
    assert_nothing_raised do
      Thoughtbot::Shoulda::Context.new("context name") do; end
    end
  end

  def test_should_create_a_nested_context
    assert_nothing_raised do
      parent = Thoughtbot::Shoulda::Context.new("Parent") do; end
      child  = Thoughtbot::Shoulda::Context.new("Child", parent) do; end
    end
  end

  def test_should_name_a_contexts_correctly
    parent     = Thoughtbot::Shoulda::Context.new("Parent") do; end
    child      = Thoughtbot::Shoulda::Context.new("Child", parent) do; end
    grandchild = Thoughtbot::Shoulda::Context.new("GrandChild", child) do; end

    assert_equal "Parent", parent.full_name
    assert_equal "Parent Child", child.full_name
    assert_equal "Parent Child GrandChild", grandchild.full_name
  end

  # Should statements

  def test_should_have_should_hashes_when_given_should_statements
    context = Thoughtbot::Shoulda::Context.new("name") do
      should "be good" do; end
      should "another" do; end
    end
    
    names = context.shoulds.map {|s| s[:name]}
    assert_equal ["another", "be good"], names.sort
  end

  # setup and teardown

  def test_should_capture_setup_and_teardown_blocks
    context = Thoughtbot::Shoulda::Context.new("name") do
      setup    do; "setup";    end
      teardown do; "teardown"; end
    end
    
    assert_equal "setup",    context.setup_block.call
    assert_equal "teardown", context.teardown_block.call
  end

  # building

  def test_should_create_shoulda_test_for_each_should_on_build
    context = Thoughtbot::Shoulda::Context.new("name") do
      should "one" do; end
      should "two" do; end
    end
    context.expects(:create_test_from_should_hash).with(has_entry(:name => "one"))
    context.expects(:create_test_from_should_hash).with(has_entry(:name => "two"))
    context.build
  end

  def test_should_create_test_methods_on_build
    tu_class = Test::Unit::TestCase
    context = Thoughtbot::Shoulda::Context.new("A Context", tu_class) do
      should "define the test" do; end
    end

    tu_class.expects(:define_method).with(:"test: A Context should define the test. ")
    context.build
  end

  def test_should_create_test_methods_on_build_when_subcontext
    tu_class = Test::Unit::TestCase
    context = Thoughtbot::Shoulda::Context.new("A Context", tu_class) do
      context "with a child" do
        should "define the test" do; end
      end
    end

    tu_class.expects(:define_method).with(:"test: A Context with a child should define the test. ")
    context.build
  end

  # Test::Unit integration

  def test_should_create_a_new_context_and_build_it_on_Test_Unit_context
    c = mock("context")
    c.expects(:build)
    Thoughtbot::Shoulda::Context.expects(:new).with("foo", kind_of(Class)).returns(c)
    self.class.context "foo" do; end
  end

  def test_should_create_a_one_off_context_and_build_it_on_Test_Unit_should
    s = mock("test")
    Thoughtbot::Shoulda::Context.any_instance.expects(:should).with("rock").returns(s)
    Thoughtbot::Shoulda::Context.any_instance.expects(:build)
    self.class.should "rock" do; end
  end

  def test_should_define_a_test_on_should
    s = mock("test")
    Thoughtbot::Shoulda::Context.any_instance.expects(:should).with("rock").returns(s)
    Thoughtbot::Shoulda::Context.any_instance.expects(:build)
    self.class.should "rock" do; end
  end

  def test_should_create_a_one_off_context_and_build_it_on_Test_Unit_should_eventually
    s = mock("test")
    Thoughtbot::Shoulda::Context.any_instance.expects(:should_eventually).with("rock").returns(s)
    Thoughtbot::Shoulda::Context.any_instance.expects(:build)
    self.class.should_eventually "rock" do; end
  end
end
