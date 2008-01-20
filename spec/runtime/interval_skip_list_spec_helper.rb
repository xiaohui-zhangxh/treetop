module IntervalSkipListSpecHelper
  def contain_marker(marker)
    ContainMarkers.new(list, [marker])
  end

  def contain_markers(*markers)
    ContainMarkers.new(list, markers)
  end

  class ContainMarkers
    attr_reader :failure_message

    def initialize(list, expected_markers)
      @list = list
      @expected_markers = expected_markers
    end

    def matches?(target_range)
      @target_range = target_range

      @target_range.each do |i|
        markers = @list.containing(i)

        @expected_markers.each do |expected_marker|
          unless markers.include?(expected_marker)
            @failure_message = "Expected #{expected_marker.inspect} to contain #{i}, but it doesn't. #{i} is contained by: #{markers.inspect}."
            return false
          end
        end

        markers.each do |marker|
          unless @expected_markers.include?(marker)
            @failure_message = "Did not expect #{marker.inspect} to contain #{i}. Only expected #{@expected_markers.inspect}."
            return false
          end
        end
      end

      true
    end
  end

  def have_markers(*markers)
    HaveMarkers.new(markers)
  end

  def have_marker(marker)
    HaveMarkers.new([marker])
  end

  class HaveMarkers
    def initialize(expected_markers)
      @expected_markers = expected_markers
    end

    def matches?(target)
      @target = target
      return false unless @target.size == @expected_markers.size
      @expected_markers.each do |expected_marker|
        return false unless @target.include?(expected_marker)
      end
      true
    end

    def failure_message
      "Expected #{@target.inspect} to include only #{@expected_markers.inspect}"
    end
  end
end