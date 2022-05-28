class CapybaraPage
  include RSpec::Matchers
  include Capybara::DSL

  def assert_correct_page
    raise NotImplementedError, "you must define #assert_correct_page in #{self.class.name}"
  end

  def initialize(&block)
    begin
      assert_correct_page
      yield self if block_given?
    rescue StandardError => e
      # Enable the following method to open the page when an error occurs.
      save_and_open_page
      raise e
    end
  end
end
