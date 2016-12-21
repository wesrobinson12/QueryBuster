# QueryBuster

A light version of Active Record

## Functionality

The `AttrAccessorObject` class creates setter and getter methods for each column in the database.  This is similar to the `finalize!` class method within the `SQLObject` class, except with the `finalize!` method it is unnecessary to explicitly name the columns.  Instead, all of the table columns are created as setter and getter methods, as shown below.

```ruby
def self.finalize!
  columns.each do |column|
    define_method("#{column}=") do |arg = nil|
      attributes[column] = arg
    end
    define_method("#{column}") do
      attributes[column]
    end
  end
end
```
