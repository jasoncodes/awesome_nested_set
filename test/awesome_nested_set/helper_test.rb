require 'test_helper'

module CollectiveIdea
  module Acts #:nodoc:
    module NestedSet #:nodoc:
      class AwesomeNestedSetTest < TestCaseClass
        include Helper
        fixtures :categories
        
        def test_nested_set_options_without_level
          expected = [
            [" Top Level", 1],
            ["- Child 1", 2],
            ['- Child 2', 3],
            ['-- Child 2.1', 4],
            ['- Child 3', 5],
            [" Top Level 2", 6]
          ]
          actual = nested_set_options(Category) do |c|
            "#{'-' * c.level} #{c.name}"
          end
          assert_equal expected, actual
        end
        
        def test_nested_set_options_with_level
          expected = [
            [" Top Level", 1],
            ["- Child 1", 2],
            ['- Child 2', 3],
            ['-- Child 2.1', 4],
            ['- Child 3', 5],
            [" Top Level 2", 6]
          ]
          actual = nested_set_options(Category) do |c, level|
            "#{'-' * level} #{c.name}"
          end
          assert_equal expected, actual
        end
        
        def test_nested_set_options_for_branch
          expected = [
            ['- Child 2', 3],
            ['-- Child 2.1', 4]
          ]
          actual = nested_set_options(categories(:child_2)) do |c, level|
            "#{'-' * level} #{c.name}"
          end
          assert_equal expected, actual
        end
        
        def test_nested_set_options_without_root
          expected = [
            ["- Child 1", 2],
            ['- Child 2', 3],
            ['-- Child 2.1', 4],
            ['- Child 3', 5]
          ]
          actual = nested_set_options(categories(:top_level), nil, :include_root => false) do |c, level|
            "#{'-' * level} #{c.name}"
          end
          assert_equal expected, actual
        end
        
        def test_nested_set_options_with_mover
          expected = [
            [" Top Level", 1],
            ["- Child 1", 2],
            ['- Child 3', 5],
            [" Top Level 2", 6]
          ]
          actual = nested_set_options(Category, categories(:child_2)) do |c, level|
            "#{'-' * level} #{c.name}"
          end
          assert_equal expected, actual
        end
        
      end
    end
  end
end
