require "pathname"

module SchemaHelper
  def schema_named(name)
    File.read(Pathname(GEM_ROOT) / "schemas" / "#{name}.schema.json")
  end
end
