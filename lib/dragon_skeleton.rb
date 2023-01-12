module DragonSkeleton # :nodoc:
  class << self
    # Adds the given submodules of DragonSkeleton to the top level namespace
    # for more convenient access.
    #
    # Optionally, you can pass in a list of module names (like :Animations) to add
    # only those.
    def add_to_top_level_namespace(*modules)
      modules = modules.empty? ? constants : modules
      modules.each do |module_name|
        Object.const_set module_name, const_get(module_name)
      end
    end
  end
end
