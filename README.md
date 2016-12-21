# QueryBuster

A light version of Active Record

## Functionality

The `AttrAccessorObject` class creates setter and getter methods for each column in the database.  This is similar to the `::finalize!` class method within the `SQLObject` class, except with the `::finalize!` method it is unnecessary to explicitly name the columns.  Instead, all of the table columns are created as setter and getter methods.

The `SQLObject` class holds the bulk of the functionality, including the `#initialize`, `#update`, `#insert`, and `#save` instance methods, and the `::find` and  `::all` class methods.

Within the `Searchable` module, you can find the `#where` function which allows you to search a database by some specific criteria.

Last but not least, you are able to create `#has_many`, `#belongs_to`, and `#has_one_through` associations.  

## Demo

To run the demo, navigate to the **`\lib`** folder and run **`ruby comments.rb`**.

Within the demo, three classes are created, with associations, as shown below.

```ruby
  class Comment < SQLObject
    belongs_to :post

    has_one_through :user, :post, :user
  end
```
After classes are created, `attr_accessor` methods are created using `::finalize!`.

```ruby
  Comment.finalize!
```

Once the demo has begun, the user is prompted with a menu in the console.  Feel free to poke around and view or create comments, posts, or users!
