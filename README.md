# README

To run the application locally

* Install Ruby version 3.1.1

* Clone the repository

* Run command `bundle install` to install all the Gems.

* Run all the unit tests before testing the endpoints manually by running `bundle exec rspec`.

* Run command `bundle exec rails s` to start server on localhost:3000

* Make a curl request for smoke testing:
  `curl -X GET \
  -H "Authorization: Basic Zm9vOmJhcg==" \
  "http://localhost:3000/sorted_data?sort_by=population&order_by=desc&page=1&per=15"
`
