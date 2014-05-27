# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert page.body.index(e1)<page.body.index(e2)
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  hr = rating_list.split(",")
  hr.each do |r|
    r.strip!
    if (uncheck)
      uncheck("ratings_#{r}")
    else
      check("ratings_#{r}")
    end
  end
end

Then /I should (not )?see the following ratings: (.*)/ do |should_not, rating_list|
  hr = rating_list.split(",")
  hr.each do |r|
    r.strip!
    if (should_not)
      page.all(:xpath, "//table[@id='movies']/tbody//td[2]") do |e|
        assert e.has_no_content?("#{r}")
      end
    else
      page.all(:xpath, "//table[@id='movies']/tbody//td[2]") do |e|
        assert e.has_content?("#{r}")
      end
    end
  end
end

Then /I should see all the movies/ do
  if page.respond_to? :should
    (page.all('table#movies tr').count - 1).should == Movie.all.count
  else
    assert (page.all('table#movies tr').count - 1) == Movie.all.count
  end
  # Make sure that all the movies in the app are visible in the table
end
