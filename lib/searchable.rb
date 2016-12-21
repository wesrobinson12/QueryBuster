require_relative 'db_connection'
require_relative 'sql_object'

module Searchable
  def where(params)
    where_line = params.map do |key, val|
      "#{key.to_s} = ?"
    end.join(" AND ")

    values = params.map do |_, val|
      val
    end

    DBConnection.execute(<<-SQL, *values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL
    .map { |result| self.new(result) }
  end
end

class SQLObject
  extend Searchable
end
