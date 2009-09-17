#!/usr/bin/env ruby
# encoding: utf-8

BEGIN {
	require 'pathname'
	basedir = Pathname.new( __FILE__ ).dirname.parent.parent
	
	libdir = basedir + 'lib'
	extdir = basedir + 'ext'
	
	$LOAD_PATH.unshift( libdir ) unless $LOAD_PATH.include?( libdir )
	$LOAD_PATH.unshift( extdir ) unless $LOAD_PATH.include?( extdir )
}

require 'spec'
require 'bluecloth'

require 'spec/lib/helpers'
require 'spec/lib/constants'
require 'spec/lib/matchers'


#####################################################################
###	C O N T E X T S
#####################################################################

describe BlueCloth, "horizontal rules" do
	include BlueCloth::TestConstants,
	        BlueCloth::Matchers

	# Hrule -- three asterisks
	it "produces a horizontal rule tag from three asterisks on a line by themselves" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		***
		---
		<hr />
		---
	end

	# Hrule -- three spaced-out asterisks
	it "produces a horizontal rule tag from three asterisks with intervening spaces on a line " +
	   " by themselves" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		* * *
		---
		<hr />
		---
	end

	# Indented Hrule -- three spaced-out asterisks
	it "produces a horizontal rule tag from three asterisks with intervening spaces on a line " +
	   " by themselves, even if they're indented less than 4 spaces" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		   * * *
		---
		<hr />
		---
	end

	# Hrule -- more than three asterisks
	it "produces a horizontal rule tag from more than three asterisks on a line by themselves" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		*****
		---
		<hr />
		---
	end

	# Hrule -- a line of dashes
	it "produces a horizontal rule tag from three dashes on a line by themselves" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		---------------------------------------
		---
		<hr />
		---
	end

	# Hrule -- three spaced-out dashes
	it "produces a horizontal rule tag from three dashes with intervening spaces on a line " +
	   " by themselves" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		- - -
		---
		<hr />
		---
	end

end


