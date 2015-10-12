# uofu_buses.rb
# Basically a script that goes and grabs info from the U of U buses page.

require 'rubygems'
require 'headless'
require 'selenium-webdriver'

### Class that grabs information from the UOfUBuses page
class UOfUBuses

  def initialize
    @driver = Selenium::WebDriver.for :firefox
    @driver.navigate.to 'http://www.uofubus.com'
    sleep(5.0) # This lets the page catch up and show us the information we want

    @routes = {}
  end

  ### Gets the current bus routes
  def get_current_routes
    @driver.find_elements(:class, 'route').each do |route|
      name = route.find_element(:class, 'title').attribute('textContent').downcase.strip
      id = route.attribute('id').to_s

      @routes[name] = BusRoute.new(name, id)
    end
  end

  ### Prints all the current routes
  def print_current_routes
    @routes.each do |route_name, id|
      puts "#{route_name} => #{id}"
    end
  end

  private

  ### Class representing some bus route - basically a struct
  class BusRoute
    def initialize(route_name, route_id)
      @route_name = route_name
      @route_id = route_id
    end

    ### Returns the HTML id of this bus route
    def get_id
      @route_id
    end

    ### Returns the name of this bus route
    def get_name
      @route_name
    end

    ### Returns a string version of this Bus Route
    def to_s
      result = @route_name.to_s + ' ' + @route_id.to_s
      result
    end
  end
end

Headless.ly do
  buses = UOfUBuses.new
  buses.get_current_routes
  buses.print_current_routes
end
