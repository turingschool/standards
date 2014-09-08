# NOTE: ORGANIZATION IS AT THE BOTTOM, UNDER THE __END__

# a tree structure to make it easier to parse the text file
TabTree = Struct.new :value, :parent, :children do  # => Struct
  def initialize(value, parent, children=[])
    super                                           # => nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
  end

  def root?
    !parent  # => false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, true, false, ...
  end

  def leaf?
    children.empty?  # => false, false, false, false, true, true, true, true, true, true, true, true, true, true, true, true, false, true, true, true, true, true, false, true, true, false, true, true, true, false, true, true, true, true, true, false, true, true, true, true, true, true, false, true, true, true, true, true, true, false, true, true, true, false, true, true, true, true, true, false, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, true, true, true, true, true, true, true, false, true, false, true, false, true, false, false, true, true, false, true, true, false, false, true, true, true, true, true, true, true, true, false, false, false, true, false, false, false, true, true, true, true, false, true, true, true, true, true, true, false, false, true, true, true, false, ...
  end

  def add_child(value)
    if value.start_with? "\t"                                                   # => false, true, false, true, true, false, true, true, true, false, true, true, true, false, true, true, true, false, true, true, true, false, true, true, true, false, true, true, true, false, true, true, true, false, true, true, true, false, true, true, true, false, true, true, true, false, true, true, true, false, true, true, true, false, true, true, true, false, true, true, true, true, false, true, true, true, true, false, true, true, true, true, false, true, true, true, true, false, true, true, true, true, false, true, true, true, false, true, true, true, true, false, true, true, true, true, false, true, true, true, false, true, true, true, true, false, true, true, true, true, false, true, true, true, true, false, true, true, true, false, true, true, true, true, false, true, true, true, true, false, true, true, true, true, false, true, true, true, true, false, true, true, true, true, false, true, tr...
      child = children.last || raise("Check indentation for #{value.inspect}")  # => #<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[]>, #<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[#<struct TabTree value="Ruby", parent=#<struct TabTree:...>, children=[]>]>, #<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[#<struct TabTree:...>]>, children=[]>, #<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[#<struct TabTree value="Ruby", parent=#<struct TabTree:...>, children=[#<struct TabTree value="Basics", parent=#<struct TabTree:...>, children=[]>]>]>, #<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct ...
      child.add_child value[1..-1]                                              # => [#<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[...]>, children=[]>], [#<struct TabTree value="Basics", parent=#<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[#<struct TabTree:...>]>, children=[...]>, children=[]>], [#<struct TabTree value="Basics", parent=#<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[#<struct TabTree:...>]>, children=[...]>, children=[]>], [#<struct TabTree value="Run a Ruby program from the command line.", parent=#<struct TabTree value="Basics", parent=#<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", paren...
    else
      children << TabTree.new(value, self)                                      # => [#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[...]>, children=[]>], [#<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[...]>, children=[]>], [#<struct TabTree value="Basics", parent=#<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[#<struct TabTree:...>]>, children=[...]>, children=[]>], [#<struct TabTree value="Run a Ruby program from the command line.", parent=#<struct TabTree value="Basics", parent=#<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[#<struct TabTree:...>]>, children=[#<struct TabTree:...>]>, c...
    end                                                                         # => [#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[...]>, children=[]>], [#<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[...]>, children=[]>], [#<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[...]>, children=[]>], [#<struct TabTree value="Basics", parent=#<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>]>, children=[#<struct TabTree:...>]>, children=[...]>, children=[]>], [#<struct TabTree value="Basics", parent=#<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, pare...
  end

  def ancestry
    return [] if root? || parent.root?  # => false, false, false, true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true, false, false, fa...
    [parent, *parent.ancestry]          # => [#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>, #<struct TabTree value="Tools", parent=#<struct TabTree:...>, children=[#<struct TabTree value="Environment", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Git", parent=#<struct TabTree:...>, children=[#<struct TabTree value="Explain the purpose of git and Github.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Manipulate git configuration (user.name, user.email, alias.--, github.user, github.token) from both the command line and from .gitconfig file.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Initialize a new git repository.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Move files to staging area with `git add .`, `git add -A`, and `git add <filename/directory>`.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree valu...
  end
end                                     # => TabTree

# load lib
root_dir = File.expand_path '..', __FILE__  # => "/Users/josh/code/jsl/standard"
$LOAD_PATH.unshift "#{root_dir}/lib"        # => ["/Users/josh/code/jsl/standard/lib", "/Users/josh/.gem/ruby/2.1.2/gems/seeing_is_believing-2.1.4/lib", "/Users/josh/.rubies/ruby-2.1.2/lib/ruby/site_ruby/2.1.0", "/Users/josh/.rubies/ruby-2.1.2/lib/ruby/site_ruby/2.1.0/x86_64-darwin13.0", "/Users/josh/.rubies/ruby-2.1.2/lib/ruby/site_ruby", "/Users/josh/.rubies/ruby-2.1.2/lib/ruby/vendor_ruby/2.1.0", "/Users/josh/.rubies/ruby-2.1.2/lib/ruby/vendor_ruby/2.1.0/x86_64-darwin13.0", "/Users/josh/.rubies/ruby-2.1.2/lib/ruby/vendor_ruby", "/Users/josh/.rubies/ruby-2.1.2/lib/ruby/2.1.0", "/Users/josh/.rubies/ruby-2.1.2/lib/ruby/2.1.0/x86_64-darwin13.0"]
require 'standards'                         # => true

# translate indentation to tree structure
root = TabTree.new nil, nil                           # => #<struct TabTree value=nil, parent=nil, children=[]>
DATA.each_line                                        # => #<Enumerator: #<File:/Users/josh/code/jsl/standard/standards_organization.rb>:each_line>
    .reject { |line| line == "\n" }                   # => ["Languages\n", "\tRuby\n", "\t\tBasics\n", "\t\t\tRun a Ruby program from the command line.\n", "\t\t\tAssign an object to a variable.\n", "\t\t\tCall a method on an object.\n", "\t\t\tDemonstrate that Ruby's primitives are actually objects.\n", "\t\t\tOpen an interactive prompt using Pry.\n", "\t\t\tLoad a file into Pry.\n", "\t\t\tDemonstrate that all methods return a value either implicitly or explicitly.\n", "\t\t\tDemonstrate that Ruby expressions are evaluated from right to left.\n", "\t\t\tAppropriately name variables in Ruby.\n", "\t\t\tExplain and demonstrate the difference between assignment (=) and equality (==).\n", "\t\t\tExplain the difference between nil, 0, [], and \"\".\n", "\t\t\tDefine truthy and falsy, and identify falsy values.\n", "\t\t\tStrings\n", "\t\t\t\tAccess a substring from a string using a range.\n", "\t\t\t\tInterpolate Ruby expressions into strings.\n", "\t\t\t\tDemonstrate the difference be...
    .each_with_object(root)                           # => #<Enumerator: ["Languages\n", "\tRuby\n", "\t\tBasics\n", "\t\t\tRun a Ruby program from the command line.\n", "\t\t\tAssign an object to a variable.\n", "\t\t\tCall a method on an object.\n", "\t\t\tDemonstrate that Ruby's primitives are actually objects.\n", "\t\t\tOpen an interactive prompt using Pry.\n", "\t\t\tLoad a file into Pry.\n", "\t\t\tDemonstrate that all methods return a value either implicitly or explicitly.\n", "\t\t\tDemonstrate that Ruby expressions are evaluated from right to left.\n", "\t\t\tAppropriately name variables in Ruby.\n", "\t\t\tExplain and demonstrate the difference between assignment (=) and equality (==).\n", "\t\t\tExplain the difference between nil, 0, [], and \"\".\n", "\t\t\tDefine truthy and falsy, and identify falsy values.\n", "\t\t\tStrings\n", "\t\t\t\tAccess a substring from a string using a range.\n", "\t\t\t\tInterpolate Ruby expressions into strings.\n", "\t\t\t\tDemonstrate the...
    .each { |line, root| root.add_child line.chomp }  # => #<struct TabTree value=nil, parent=nil, children=[#<struct TabTree value="Languages", parent=#<struct TabTree:...>, children=[#<struct TabTree value="Ruby", parent=#<struct TabTree:...>, children=[#<struct TabTree value="Basics", parent=#<struct TabTree:...>, children=[#<struct TabTree value="Run a Ruby program from the command line.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Assign an object to a variable.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Call a method on an object.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Demonstrate that Ruby's primitives are actually objects.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Open an interactive prompt using Pry.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Load a file into Pry.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Demon...

# translate tree structure to standards structure
def add_standards(structure, tree)
  if tree.leaf? && !tree.root?                                                     # => false, false, false, false, true, true, true, true, true, true, true, true, true, true, true, true, false, true, true, true, true, true, false, true, true, false, true, true, true, false, true, true, true, true, true, false, true, true, true, true, true, true, false, true, true, true, true, true, true, false, true, true, true, false, true, true, true, true, true, false, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, true, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, false, true, true, true, true, true, true, true, false, true, false, true, false, true, false, false, true, true, false, true, true, false, false, true, true, true, true, true, true, true, true, false, false, false, true, false, false, false, true, true, true, true, false, true, true, t...
    structure.add_standard standard: tree.value, tags: tree.ancestry.map(&:value)  # => #<Standards::Standard:0x007fa52a040bb0 @id=1, @standard="Run a Ruby program from the command line.", @tags=["Basics", "Ruby", "Languages"]>, #<Standards::Standard:0x007fa52a160338 @id=2, @standard="Assign an object to a variable.", @tags=["Basics", "Ruby", "Languages"]>, #<Standards::Standard:0x007fa52a089b80 @id=3, @standard="Call a method on an object.", @tags=["Basics", "Ruby", "Languages"]>, #<Standards::Standard:0x007fa5290e0300 @id=4, @standard="Demonstrate that Ruby's primitives are actually objects.", @tags=["Basics", "Ruby", "Languages"]>, #<Standards::Standard:0x007fa529071db0 @id=5, @standard="Open an interactive prompt using Pry.", @tags=["Basics", "Ruby", "Languages"]>, #<Standards::Standard:0x007fa52a0d1430 @id=6, @standard="Load a file into Pry.", @tags=["Basics", "Ruby", "Languages"]>, #<Standards::Standard:0x007fa529835380 @id=7, @standard="Demonstrate that all methods return a v...
  end                                                                              # => nil, nil, nil, nil, #<Standards::Standard:0x007fa52a040bb0 @id=1, @standard="Run a Ruby program from the command line.", @tags=["Basics", "Ruby", "Languages"]>, #<Standards::Standard:0x007fa52a160338 @id=2, @standard="Assign an object to a variable.", @tags=["Basics", "Ruby", "Languages"]>, #<Standards::Standard:0x007fa52a089b80 @id=3, @standard="Call a method on an object.", @tags=["Basics", "Ruby", "Languages"]>, #<Standards::Standard:0x007fa5290e0300 @id=4, @standard="Demonstrate that Ruby's primitives are actually objects.", @tags=["Basics", "Ruby", "Languages"]>, #<Standards::Standard:0x007fa529071db0 @id=5, @standard="Open an interactive prompt using Pry.", @tags=["Basics", "Ruby", "Languages"]>, #<Standards::Standard:0x007fa52a0d1430 @id=6, @standard="Load a file into Pry.", @tags=["Basics", "Ruby", "Languages"]>, #<Standards::Standard:0x007fa529835380 @id=7, @standard="Demonstrate that al...
  tree.children.each { |child| add_standards structure, child }                    # => [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [#<struct TabTree value="Access a substring from a string using a range.", parent=#<struct TabTree value="Strings", parent=#<struct TabTree value="Basics", parent=#<struct TabTree value="Ruby", parent=#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[#<struct TabTree:...>, #<struct TabTree value="Tools", parent=#<struct TabTree:...>, children=[#<struct TabTree value="Environment", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Git", parent=#<struct TabTree:...>, children=[#<struct TabTree value="Explain the purpose of git and Github.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Manipulate git configuration (user.name, user.email, alias.--, github.user, github.token) from both the command line and from .gitconfig file.", parent=#<struct TabTre...
end
structure = Standards::Structure.new                                               # => #<Standards::Structure:0x007fa529118520 @standards=[]>
add_standards structure, root                                                      # => [#<struct TabTree value="Languages", parent=#<struct TabTree value=nil, parent=nil, children=[...]>, children=[#<struct TabTree value="Ruby", parent=#<struct TabTree:...>, children=[#<struct TabTree value="Basics", parent=#<struct TabTree:...>, children=[#<struct TabTree value="Run a Ruby program from the command line.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Assign an object to a variable.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Call a method on an object.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Demonstrate that Ruby's primitives are actually objects.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Open an interactive prompt using Pry.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTree value="Load a file into Pry.", parent=#<struct TabTree:...>, children=[]>, #<struct TabTre...

# overwrite standards.json with new standards
Standards::Persistence.dump "#{root_dir}/standards.json", structure  # => 13680

__END__
Languages
	Ruby
		Basics
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
			Writing Methods
				Define an instance method using correct syntax.
				Define a class method using correct syntax.
				Define methods that accept arguments.
		Enumerable Methods
			Iterate through a collection of objects using #each.
			Iterate through a collection and return a new array using #map or #collect.
			Shuffle the order of elements in an array using #shuffle.
			Sort an array numerically or alphabetically using #sort.
			Sort an array by a characteristic using #sort_by.
		Gems
			Install a gem.
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
			Explain and demonstrate TDD workflow.
		In practice
			Ruby
				Minitest
					Create and run a Minitest suite.
					Write assertions in Minitest (assert, assert_equal, assert_respond_to, assert_instance_of).
					Read, interpret, and fix error messages.
					Read, interpret, and fix failure messages.
	OOP
		Design Patterns
		MVC
		Separation of Responsibilties
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
