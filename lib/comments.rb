require_relative 'associatable'

class Comment < SQLObject
  belongs_to :post

  has_one_through :user, :post, :user
end

class Post < SQLObject
  belongs_to :user

  has_many :comments
end

class User < SQLObject
  has_many :posts
end

Comment.finalize!
Post.finalize!
User.finalize!

class Information
  def initialize
    @comments = Comment.all
    @posts = Post.all
    @users = User.all
  end

  def go!
    done = false

    puts "Welcome to the site that has users and posts and comments!"

    until done
      choice = menu
      if choice == '7'
        done = true
      else
        menu_options(choice)
      end
    end

    puts "Goodbye!"
  end

  def menu
    puts "Choose an option:"
    puts "1 - View Comments"
    puts "2 - View Posts"
    puts "3 - View Users"
    puts "4 - Create comment"
    puts "5 - Create Post"
    puts "6 - Create User"
    puts "7 - Quit"
    answer = gets.chomp
  end

  def menu_options(choice)

    case choice
    when '1'
      comment_menu
    when '2'
      post_menu
    when '3'
      user_menu
    when '4'
      add_comment
    when '5'
      add_post
    when '6'
      add_user
    else
      puts "Please choose a valid option"
    end
  end

  def comment_menu
    puts
    if @posts.empty?
      puts "There are no posts, which means no comments!"
      puts
      sleep(1)
    else
      puts "Please choose a post #: "
      @posts.each do |post|
        puts "#{post.id} - #{post.title}"
      end

      id = gets.chomp.to_i
      post = Post.find(id)

      puts
      if post.comments.empty?
        puts "No comments on this post!"
      else
        puts "Comments: "
        post.comments.each do |comment|
          puts "- #{comment.body}"
          puts "by: #{comment.user.username}"
        end
      end
    end
    puts
  end

  def post_menu
    puts
    if @users.empty?
      puts "There are no users, which means there are no posts!"
      puts
      sleep(1)
    else
      puts "Please choose a user: "
      @users.each do |user|
        puts "#{user.id} - #{user.username}"
      end

      id = gets.chomp.to_i
      user = User.find(id)

      puts
      if user.posts.empty?
        "This user has no posts!"
      else
        puts "Posts: "
        user.posts.each do |post|
          puts "- #{post.title}"
        end
      end
    end
    puts
  end

  def user_menu
    puts
    if @users.empty?
      puts "No users!"
      puts
      sleep(1)
    else
      puts "Users: "
      @users.each do |user|
        puts "- #{user.username}"
      end
    end
    puts
  end

  def add_user
    puts
    puts "Please enter username: "
    username = gets.chomp

    user = User.new({ username: username })
    user.save

    @users = User.all
    puts
  end

  def add_post
    puts
    puts "Please enter title: "
    title = gets.chomp

    puts "Please choose a user from the following users: "
    @users.each do |user|
      puts "#{user.id} - #{user.username}"
    end
    user_id = gets.chomp

    post = Post.new({ title: title, user_id: user_id })
    post.save

    @posts = Post.all
    puts
  end

  def add_comment
    puts
    puts "Please choose a post from the following posts: "
    @posts.each do |post|
      puts "#{post.id} - #{post.title}"
    end
    post_id = gets.chomp

    puts "Please enter a comment: "
    comment = gets.chomp

    comment = Comment.new({ body: comment, post_id: post_id })
    comment.save

    @comments = Comment.all
    puts
  end

end

info = Information.new
info.go!
