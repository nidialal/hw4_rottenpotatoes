# Add a declarative step here for populating the DB with movies.

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  inx_e1 = page.body.index(e1)
  #debugger
  inx_e2 = page.body.index(e2)
  inx_e1.should < inx_e2
  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  #debugger
  @arr = rating_list.split(',')
  if uncheck.nil?
    #debugger
    @arr.each do |rating|
      #debugger
      name="ratings_"+rating
      check(name)
    end
  end
  if uncheck=='un'
    #debugger
    @arr.each do |rating|
      name="ratings_"+rating
      uncheck(name)
    end
  end
end

Then /I should see all of the movies/ do
  #debugger
  value = Movie.count
  rows = all("table#movies tbody tr").count
  rows.should == value
end
