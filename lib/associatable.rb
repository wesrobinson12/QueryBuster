require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options.keys.include?(:foreign_key) ?
      options[:foreign_key] : "#{name}_id".to_sym
    @primary_key = options.keys.include?(:primary_key) ?
      options[:primary_key] : :id
    @class_name = options.keys.include?(:class_name) ?
      options[:class_name] : name.to_s.camelcase
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options.keys.include?(:foreign_key) ?
      options[:foreign_key] : "#{self_class_name.downcase.underscore}_id".to_sym
    @primary_key = options.keys.include?(:primary_key) ?
      options[:primary_key] : :id
    @class_name = options.keys.include?(:class_name) ?
      options[:class_name] : name.to_s.singularize.camelcase
  end
end

module Associatable
  def belongs_to(name, options = {})
    self.assoc_options[name] = BelongsToOptions.new(name, options)

    define_method(name) do
      options = self.class.assoc_options[name]

      foreign_key_val = self.send(options.foreign_key)
      options
        .model_class
        .where(options.primary_key => foreign_key_val)
        .first
    end
  end

  def has_many(name, options = {})
    self.assoc_options[name] = HasManyOptions.new(name, self.name, options)

    define_method(name) do
      options = self.class.assoc_options[name]

      primary_key_val = self.send(options.primary_key)
      options
        .model_class
        .where(options.foreign_key => primary_key_val)
    end
  end

  def has_one_through(name, through_name, source_name)

    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      through_prim_key = through_options.primary_key
      through_for_key = through_options.foreign_key
      through_table = through_options.table_name

      source_options = through_options.model_class.assoc_options[source_name]
      source_prim_key = source_options.primary_key
      source_for_key = source_options.foreign_key
      source_table = source_options.table_name

      val = self.send(through_for_key)
      results = DBConnection.execute(<<-SQL, val)
        SELECT
          #{source_table}.*
        FROM
          #{through_table}
        JOIN
          #{source_table}
        ON
          #{through_table}.#{source_for_key} = #{source_table}.#{source_prim_key}
        WHERE
          #{through_table}.#{through_prim_key} = ?
      SQL

      source_options.model_class.parse_all(results).first
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
