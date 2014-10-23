# NOTE: ORGANIZATION IS AT THE BOTTOM, UNDER THE __END__

# a tree structure to make it easier to parse the text file
TabTree = Struct.new :value, :parent, :children do
  def initialize(value, parent, children=[])
    super
  end

  def root?
    !parent
  end

  def leaf?
    children.empty?
  end

  def add_child(value)
    if value.start_with? "\t"
      child = children.last || raise("Check indentation for #{value.inspect}")
      child.add_child value[1..-1]
    else
      children << TabTree.new(value, self)
    end
  end

  def ancestry
    return [] if root? || parent.root?
    [parent, *parent.ancestry]
  end
end

# load lib
root_dir = File.expand_path '..', __FILE__
$LOAD_PATH.unshift "#{root_dir}/lib"
require 'standards'

# translate indentation to tree structure
root = TabTree.new nil, nil
DATA.each_line
    .reject { |line| line == "\n" }
    .each_with_object(root)
    .each { |line, root| root.add_child line.chomp }

# translate tree structure to standards structure
def add_standards(structure, timeline, tree)
  if tree.leaf? && !tree.root?
    standard = structure.add_standard standard: tree.value, tags: tree.ancestry.map(&:value)
    event = Standards::Timeline::Event.new \
      scope: :standard,
      type:  :add,
      time:  Time.now,
      data:  standard
    timeline << event
  end
  tree.children.each { |child| add_standards structure, timeline, child }
end
structure = Standards::Structure.new
timeline  = []
add_standards structure, timeline, root

# overwrite standards.json with new standards
Standards::Persistence.dump "#{root_dir}/standards.json", timeline

# print out the hierarchy
def print_hierarchy(tree)
  return if tree.leaf?
  puts "  " * tree.ancestry.size + tree.value unless tree.root?
  tree.children.each { |child| print_hierarchy child }
end
print_hierarchy root



# >> Languages
# >>   Ruby
# >>     Basics
# >>       Strings
# >>       Blocks
# >>       Arrays
# >>       Hashes
# >>       Conditionals
# >>       Classes
# >>       Writing Methods
# >>     Enumerable Methods
# >>     Gems
# >>   HTML/CSS
# >> Tools
# >>   Git
# >>   HTTP, APIs, JSON
# >>   DevOps
# >>   Databases
# >>     No SQL
# >> Web Applications
# >>   Security
# >>   Uploads
# >>   Frameworks
# >>     Sinatra
# >> Software Design
# >>   Testing
# >>     In design
# >>     In practice
# >>       Ruby
# >>         Minitest
# >>   OOP
# >> Processes
# >>   Agile
# >>   Thinking & Learning
__END__
####### ADD STANDARDS FOR JOSH'S OBJECT MODEL LESSON


Languages
	Ruby
		Basics
			Setup
				Understand Ruby's load path and ways of requiring files (REVISE)
			Run a Ruby program from the command line.
			Assign an object to a variable.
			Call a method on an object.
			Demonstrate that Ruby's primitives are actually objects.
			Open an interactive prompt using Pry.
			Load a file into Pry.
			Demonstrate that all methods return a value either implicitly or explicitly.
			Demonstrate that Ruby expressions are evaluated from right to left.
			Appropriately name variables in Ruby.
			Explain and demonstrate the difference between assignment (=) and equality (==).
			Explain the difference between nil, 0, [], and "".
			Define truthy and falsy, and identify falsy values.
			Strings
				Access a substring from a string using a range.
				Interpolate Ruby expressions into strings.
				Demonstrate the difference between single- and double-quotes in Ruby.
				Demonstrate the correct use of positive and negative index numbers in both strings and arrays.
				Explain the difference between symbols and strings in Ruby.
			Blocks
				Explain how a block works.
				Specify and use block parameters.
			Arrays
				Use an array to hold a collection of objects.
				Access elements of an array using #first, #last, or index numbers inside of [].
				Add elements to an array using #push or <<.
			Hashes
				Explain the purpose, structure, and syntax of a hash.
				Define key and value as they relate to hashes.
				Write and recognize hashes with both hash-rocket syntax and JSON-style syntax.
				Access values in a hash using the syntax hash[key].
				Access all of the keys (hash.keys) or all of the values (hash.values) of a hash.
			Conditionals
				Explain the purpose of a conditional statement.
				Use conditional operators >, <, <=, >=, ==, != to return true or false.
				Write if/elsif/else statements using correct syntax (one if, one or more elsif, one else).
				Write ternary statements.
				Write one-line if statements.
				Explain the execution flow of a conditional statement.
			Classes
				Explain the purpose of a class.
				Define a class with correct syntax.
				Define attributes for instances of a class.
				Access and/or change attributes using attr_accessor, attr_writer, and attr_reader.
				Explain what attr_accessor, attr_writer, and attr_reader are shorthand for.
				Create an instance of a class and assign attributes to that instance.
			Methods
				Define an instance method using correct syntax.
				Define a class method using correct syntax.
				Define methods that accept arguments.
				Overwrite inherited methods. 
				Explain purpose of predicate and destructive methods. 
				Explain purpose of and difference between command and query methods.

		Enumerable Methods
			Explain that enumerable methods traverse and search through collections
			Know that #each is the base for enumerable methods and iterate through a collection of objects using #each.
			Use #map/#collect to iterate through a collection and return a mutated array.
			Use #reduce/#inject to return a single value from the objects of a collection.
			Use #sort_by to sort objects by specified criteria.
			Use #select to return an array of objects that meet a specified criteria.
			Shuffle the order of elementts in an array using #shuffle.
			Sort an array numerically or alphabetically using #sort.
			Use #detect/#find to return the first object that meets a specified criteria.
			Use #min and #max to return the object with a minimum or maximum value.
			Use #reject to return an array where objects that meet a specified criteria are discarded.
			Use #find/#detect to return the first element that meets a specified criteria.
			Use #count to return the number of objects that meet a specified criteria.
			Use #zip to produce a 2D array.
			Use #group_by to return a hash of grouped objects.
		Gems
			Install a gem.
		Libraries
			CSV
				Read from and write to CSV files.
			JSON
				Read from and write to JSON files.
			XML
				Read from and write to XML files.
	HTML/CSS
		Write HTML forms using type, name, and value attributes.
		Build a basic HTML page using common tags.
		Describe the difference between a `class` and `id` in HTML.
		Define the difference between block and inline elements in HTML.
		Use CSS selectors to target specific elements.
		Lay out page elements using CSS.
		Style HTML markup using CSS.
		Explain rule specificity in CSS.
		Use pseudo selectors to target specific elements on a page.
		Demonstrate an understanding of the box model in CSS.
		Use vendor prefixes for non-standardized CSS properties.
		Animate elements using CSS transitions and transformations.
		Implement responsive design using media-queries and breakpoints.
		Use SASS to compile CSS.
		Demonstrate the basic structure of an HTML document.
		Explain that <head></head> contains information about scripts, stylesheets, the document title, meta information, etc.
		Explain that <body></body> contains the content of the page.
	JavaScript

Tools
	Environment
	Git
		Explain the purpose of git and Github.
		Manipulate git configuration (user.name, user.email, alias.--, github.user, github.token) from both the command line and from .gitconfig file.
		Initialize a new git repository.
		Move files to staging area with `git add .`, `git add -A`, and `git add <filename/directory>`.
		Commit files and directories using `git commit -m <message>` or `git commit`.
		Check the status of the working directory and staging area with `git status` and interpret the output.
		View previous commits with `git log`.
		Create and checkout a new branch with `git checkout -b <branchname>`.
		Switch between branches with `git checkout <branchname>`.
		Merge local branches to local master with `git merge <branchname>`.
		Create a remote on Github and push a repository.
		Clone a git repository.
		Create .gitignore file and add relevant files and directories.
		Fork a repo on Github.
		Employ best practices for working collaboratively on software projects using Git and GitHub.
		Set up workflows for peer-reviewing code in pull requests.
		Create, track, and manage issues, bugs, and features.
		Refactor commit history using `git rebase`.
	HTTP, APIs, JSON
		List and define the purpose of each of the verbs used in HTTP requests.
		Define what makes HTTP a stateless protocol.
		Dissect a URL into protocol, server, and path.
		Describe the difference between an HTTP request and response.
		Describe the difference between client-side and server-side code.
		Test HTTP responses in web applications.
	Process tools (guard, rake, use of libraries)
	DevOps
		Cron
	Databases
		SQL
		No SQL
			Redis

Web Applications
	Security
		Sanitizing input
	Authorization & Authentication
	Uploads
		Images
		Files
	Frameworks
		Sinatra
			Set up a web app using Sinatra.
			Route requests using HTTP verbs.
			Pass data from controller to views in the form of local and instance variables.
			Write HTML with embedded ruby code (ERB).
			Access data passed through forms and URLs from the params hash.
		Rails
		Ember
	Pub/Sub

Software Design
	Testing
		In design
			Explain and demonstrate TDD workflow (red-green-refactor, etc.)
		In practice
			Ruby
				Minitest
					Design, implement, and run a Minitest suite.
					Write assertions in Minitest (assert, assert_equal, assert_respond_to, assert_instance_of).
					Read, interpret, and fix error messages, such as LoadError, NameError, ArgumentError, NoMethodError, and SyntaxError.
					Read, interpret, and fix failure messages.
					Use mocks to fake out method calls during testing.
	OOP
		Design Patterns
		MVC
		Separation of Responsibilties
			Create objects that interact with each other.
			Understand what is meant by "responsibility".
			Characterize the responsibilities encompassed within a class.
			Extract responsibilities from one class into separate classes.
			Break a conceptual program into components each with a responsibility.
		SOLID
	Service-Oriented Architecture
	Performance

Processes
	Agile
		User Stories
	User Experience
	Workflow
	Thinking & Learning
		Ask questions to both gain knowledge and clarify understanding.
		Know how to get help (Google, peers, instructors, mentors).
		Be comfortable being uncomfortable.
		Make mistakes without feeling incompetent.
	Professional Competencies

Computer Science
	Demonstrate how algorithms are used to solve problems. 
