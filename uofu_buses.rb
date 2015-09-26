# uofu_buses.rb
# Basically a script that goes and grabs info from the U of U buses page.

require 'selenium-webdriver'

### Class that grabs information from the UOfUBuses page
class UOfUBuses

  def initialize()
  	@driver = Selenium::WebDriver.for(:firefox)
  	@driver.navigate.to('http://www.uofubus.com')
  end

  ## Gets all the routes currently on the page
  def get_routes()
  	@routes = {}

    @driver.find_elements(:class, 'route').each do |route|
      # Get the route name and the route ID, and store them in a BusRoute object
      route_name = route.find_element(:class, 'title').text
      route_id = route.attribute('id').to_s

      if(route_name == '')
      	next
      end

      @routes[route_name] = BusRoute.new(route_name, route_id)
  	end
  end

  ## Gets all the stops for the route requested
  def get_stop_times(route)
  	if(!@routes[route])
  	  raise RuntimeError, "Cannot find the route '#{route}'"
  	end

  	route = @routes[route]
  	stops = {}

  	@driver.find_element(:id, route.get_id).find_element(:class, 'detailsBtn').click
  	sleep(0.5)

  	@driver.find_element(:id, route.get_id).find_elements(:tag_name, 'tr').each do |stop|
  	  stop_name = stop.find_element(:tag_name, 'span').text
  	  if(stop_name.downcase.include?('bus'))
  	  	next
  	  end

  	  time = stop.find_element(:class, 'time').text.gsub(/\wmin/, '').to_i

  	  stops[stop_name] = time
  	end

  	stops
  end

  def close
  	@driver.close
  end

  private

  class BusRoute
	  def initialize(route, route_id)
	  	@route = route
	  	@route_id = route_id
	  end

	  def get_id
	  	@route_id
	  end

	  def get_route
	  	@route
	  end
  end
end

var = UOfUBuses.new()
var.get_routes
puts var.get_stop_times('Green')

var.close


