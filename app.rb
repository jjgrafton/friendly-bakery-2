require 'sinatra'
require 'sendgrid-ruby'
require './products.rb'

get "/" do
    @page_title = "Friendly Bakery"
    erb :index
end

get "/bread" do
    @page_title = "Friendly Bakery: Bread"
    @rustica = Bread.new("Cabernet Rustica", "Crusty on the outside, soft and airy inside. Made with Cabernet starter from Long Island vineyard.")
    @miche = Bread.new("Chardonnay Miche", "A customer favorite. Dark wheat-based wine bread. Made with Chardonnay starter from Long Island vineyard.")
    @levain = Bread.new("Levain Locale", "The ultimate French table bread. Flavorful and chewy crust, dense interior with faint sour note.")
    bread_array = [@rustica, @miche, @levain]
    erb :bread
end

get "/cookies" do
    @page_title = "Friendly Bakery: Cookies"
    @black_and_white = Cookies.new("Black and White Cookie", "An iconic, timeless and delicious treat, loved by generations of New Yorkers.")
    @rugelach = Cookies.new("Rugelach", "An old-world treat. Buttery cookies rolled with nuts, fruit preserves and chocolate.")
    @donuts = Cookies.new("Jelly Donuts", "Tender, airy donuts dusted with sugar and custom-filled with upstate NY fruit preserves.")
    cookies_array = [@black_and_white, @rugelach, @donuts]
    erb :cookies
end

get "/cakes" do
    @page_title = "Friendly Bakery: Cakes"
    @blackout = Cakes.new("Brooklyn Blackout", "The Brooklyn Blackout Cake was named for its deep dark chocolate, nearly black appearance.  The cake was first created in Brooklyn and it referenced the blackout drills performed at the time by the Civilian Defense Corps during World War II. Our Brooklyn Blackout Cake is three layers of chocolate cake, sandwiching a dark chocolate pastry cream & wrapped in decadent chocolate silk frosting and chocolate cake crumbs.")
    @red_velvet = Cakes.new("Red Velvet Cake", "Our version of an old Southern recipe; made with a little cocoa, red food color and a lot of butter to create a taste that's unique. A dark red cake dramatically framed with smooth and creamy white Swiss meringue buttercream frosting. Special requests for our Cream Cheese Icing are also gladly accommodated.")
    cakes_array = [@blackout, @red_velvet]
    erb :cakes
end

get "/muffins" do
    @page_title = "Friendly Bakery: Muffins"
    @blueberry = Muffins.new("Blueberry Muffins", "One of our best-sellers. Buttermilk muffins filled with plump, juicy blueberries.")
    @banana_nut = Muffins.new("Banana Nut Mini Loaves", "A breakfast favorite made with ripe bananas and chopped pecans.")
    @cheddar_biscuit = Muffins.new("Cheddar Biscuits", "Light and buttery biscuits laced with sharp cheddar cheese.")
    muffins_array = [@blueberry, @banana_nut, @cheddar_biscuit]
    erb :muffins
end

get "/about" do
    @page_title = "About Friendly Bakery"
    erb :about
end

get "/contact" do
    @page_title = "Contact Friendly Bakery"
    erb :contact
end


post "/recipe-email" do
  @email = params[:email]
  @recipes = (params :recipes)
  from = Email.new(email: 'jamiegrafton@gmail.com')
  to = Email.new(email: @email)
  subject = 'Friendly Bakery Recipes'
  content = Content.new(type: 'text/html', value: @recipes)
  mail = Mail.new(from, subject, to, content)
  sg = SendGrid::API.new(api_key: ENV['NEW_SENDGRID_API_KEY'])
  response = sg.client.mail._('send').post(request_body: mail.to_json)
  if response.status_code == 401
    error_hash = JSON.parse(response.body)
    @errors = error_hash["errors"]
  end 
  puts response.status_code
  puts response.body
  puts response.parsed_body
  puts response.headers
end 
  
