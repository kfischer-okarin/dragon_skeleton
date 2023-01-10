module DragonSkeleton
  class << self
    def add_to_top_level_namespace(*modules)
      modules = modules.empty? ? constants : modules
      modules.each do |module_name|
        Object.const_set module_name, const_get(module_name)
      end
    end
  end
end
