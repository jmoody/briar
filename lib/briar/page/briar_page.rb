require 'calabash-cucumber/ibase'

# extends Calabash::IBase
class BriarPage < Calabash::IBase


  def initialize(world, transition_duration=BRIAR_WAIT_STEP_PAUSE)
    super(world, transition_duration)
  end

  # returns a query string that can be used by +trait+ method to create a
  # query string based on the mark
  #
  # accepts the following options:
  #     +:ui_class+ - defaults to <tt>'view'</tt>
  #     +:is_custom_class+ - defaults to +false+
  #
  # raises an exception if +:is_custom+ is +true+ and +:ui_class+ is
  # <tt>'view'</tt> - set the +:ui_class+ to your custom class name
  def qstr_for_trait(mark, opts={})
    default_opts = {:ui_class => 'view',
                    :is_custom => false}
    opts = default_opts.merge(opts)

    ui_class = opts[:ui_class]
    is_custom = opts[:is_custom]

    if is_custom and ui_class.eql?('view')
      raise "if is_custom is 'true' than ui_class should not be '#{view}'"
    end

    if opts[:is_custom]
      view = "view:'#{opts[:is_custom]}'"
    else
      view = ui_class
    end

    "#{view} marked:'#{mark}'"
  end

  # returns the mark for this page
  #
  # raises an exception if subclass does not implement
  def mark
    raise "subclasses must implement the 'mark' method"
  end

  def page_visible?
    view_exists?(mark)
  end

end
