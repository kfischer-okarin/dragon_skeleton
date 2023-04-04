module DragonSkeleton
  # Mostly implements the Set class from the Ruby standard library.
  # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html
  class Set
    include Enumerable

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-c-5B-5D
    def self.[](*elements)
      new(elements)
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-c-new
    def initialize(elements = nil)
      @elements = (elements || []).map { |element| [element, true] }.to_h
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-union
    def union(other)
      self.class.new(to_a + other.to_a)
    end

    alias | union
    alias + union

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-intersection
    def intersection(other)
      self.class.new(select { |element| other.include?(element) })
    end

    alias & intersection

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-2D
    def -(other)
      self.class.new(select { |element| !other.include?(element) })
    end

    alias difference -

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-5E
    def ^(other)
      (self | other) - (self & other)
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-3C-3D-3E
    def <=>(other)
      return unless other.is_a?(Set)
      return 0 if self == other
      return -1 if subset?(other)
      return 1 if superset?(other)
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-3D-3D
    def ==(other)
      other.is_a?(Set) && @elements == other.instance_variable_get(:@elements)
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-size
    def size
      @elements.size
    end

    alias length size

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-empty-3F
    def empty?
      @elements.empty?
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-include-3F
    def include?(element)
      @elements.key?(element)
    end

    alias === include?
    alias member? include?

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-subset-3F
    def subset?(other)
      all? { |element| other.include?(element) }
    end

    alias <= subset?

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-proper_subset-3F
    def proper_subset?(other)
      subset?(other) && size < other.size
    end

    alias < proper_subset?

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-superset-3F
    def superset?(other)
      other.subset?(self)
    end

    alias >= superset?

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-proper_superset-3F
    def proper_superset?(other)
      superset?(other) && size > other.size
    end

    alias > proper_superset?

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-disjoint-3F
    def disjoint?(other)
      (self & other).empty?
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-intersect-3F
    def intersect?(other)
      !disjoint?(other)
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-add
    def add(element)
      @elements[element] = true
      self
    end

    alias << add

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-add-3F
    def add?(element)
      add(element) unless include?(element)
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-merge
    def merge(elements)
      elements.each { |element| add(element) }
      self
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-replace
    def replace(elements)
      @elements = elements.map { |element| [element, true] }.to_h
      self
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-clear
    def clear
      @elements.clear
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-delete
    def delete(element)
      @elements.delete(element)
      self
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-delete-3F
    def delete?(element)
      delete(element) if include?(element)
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-subtract
    def subtract(elements)
      elements.each { |element| delete(element) }
      self
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-delete_if
    def delete_if
      return enum_for(:delete_if) { size } unless block_given?

      each do |element|
        delete(element) if yield(element)
      end
      self
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-select-21
    def select!(&block)
      return enum_for(:select!) { size } unless block_given?

      size_before = size
      keep_if(&block)
      self if size_before != size
    end

    alias filter! select!

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-keep_if
    def keep_if
      return enum_for(:keep_if) { size } unless block_given?

      delete_if { |element| !yield(element) }
      self
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-reject-21
    def reject!
      return enum_for(:reject!) { size } unless block_given?

      size_before = size
      delete_if { |element| yield(element) }
      self if size_before != size
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-classify
    def classify
      return enum_for(:classify) { size } unless block_given?

      result = {}

      each do |element|
        key = yield(element)
        result[key] ||= self.class.new
        result[key].add(element)
      end

      result
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-collect-21
    def collect!
      return enum_for(:collect!) { size } unless block_given?

      @elements = map { |element| [yield(element), true] }.to_h
      self
    end

    alias map! collect!

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-divide
    def divide(&func)
      return enum_for(:divide) { size } unless block_given?

      case func.arity
      when 2
        set_by_representative = {}
        each do |element|
          representative = set_by_representative.keys.find { |key|
            yield(element, key)
          }
          representative ||= element
          set_by_representative[representative] ||= self.class.new
          set_by_representative[representative] << element
        end
        Set.new set_by_representative.values
      else
        set_by_value = {}
        each do |element|
          discriminator = yield(element)
          set_by_value[discriminator] ||= self.class.new
          set_by_value[discriminator] << element
        end
        Set.new set_by_value.values
      end
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-flatten
    def flatten
      result = []
      each do |element|
        if element.is_a?(Set)
          result += element.flatten
        else
          result << element
        end
      end
      Set.new result
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-flatten-21
    def flatten!
      elements_before = @elements
      @elements = flatten.instance_variable_get(:@elements)
      self if elements_before != @elements
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-to_s
    def inspect
      "#<Set: {#{to_a.join(', ')}}>"
    end

    alias to_s inspect

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-join
    def join(separator = nil)
      to_a.join(separator)
    end

    # See https://ruby-doc.org/3.2.2/stdlibs/set/Set.html#method-i-each
    def each
      return to_enum(:each) { size } unless block_given?

      @elements.keys.each do |element|
        yield element
      end
    end

    # These methods are needed to make Sets properly work as Hash keys.
    def hash # :nodoc:
      @elements.hash
    end

    def eql?(other) # :nodoc:
      other.is_a?(Set) && @elements.eql?(other.instance_variable_get(:@elements))
    end
  end
end
