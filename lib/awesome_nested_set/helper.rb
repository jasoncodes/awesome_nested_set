module CollectiveIdea #:nodoc:
  module Acts #:nodoc:
    module NestedSet #:nodoc:
      # This module provides some helpers for the model classes using acts_as_nested_set.
      # It is included by default in all views.
      #
      module Helper
        # Returns options for select.
        # You can exclude some items from the tree.
        # You can pass a block receiving an item and returning the string displayed in the select.
        #
        # == Params
        #  * +class_or_item+ - Class name or top level times
        #  * +mover+ - The item that is being move, used to exclude impossible moves
        #  * +options+ - hash of additional options
        #  * +&block+ - a block that will be used to display: { |item| ... item.name }
        #
        # == Options
        #  * +include_root+ - Include root object(s) in output. Default: true
        #
        # == Usage
        #
        #   <%= f.select :parent_id, nested_set_options(Category, @category) {|i, level|
        #       "#{'–' * level} #{i.name}"
        #     }) %>
        #
        def nested_set_options(class_or_item, mover = nil, options = {}, &block)
          class_or_item = class_or_item.roots if class_or_item.is_a?(Class)
          options.assert_valid_keys :include_root
          options.reverse_merge! :include_root => true
          items = Array(class_or_item)
          result = []
          items.each do |root|
            objects = options[:include_root] ? root.self_and_descendants : root.descendants
            result += root.class.map_with_level(objects) do |i, level|
              if mover.nil? || mover.new_record? || mover.move_possible?(i)
                [yield(*[i, level].first(block.arity)), i.id]
              end
            end.compact
          end
          result
        end  
        
      end
    end  
  end
end