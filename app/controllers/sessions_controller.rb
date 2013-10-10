class SessionsController < ApplicationController

  def new

  end



  def create
    @session = params[:session]
    @userName = params[:session][:username]

    @password = params[:session][:password]

    require 'net/http'
    require 'uri'
    uri = URI.parse('http://mango.microbitinfo.com/StarOR/User/UserHeader')
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Get.new(uri.request_uri,{'Content_Type' => 'application/json'})
    request.basic_auth(@userName, @password)
    response, data= http.request request
    render :text => "#{data}"
    data = response.body
    result = JSON.parse(data)
    #result1 =  ActiveSupport::JSON.decode(data)
    if result.has_key? 'Error'
      raise "GetUserHeader service error!"
    end

    if (response.code == "200")
      userId = JSON.parse(data)['Data']['UserId']
      firstName =   JSON.parse(data)['Data']['FirstName']
      lastName =   JSON.parse(data)['Data']['LastName']
      facility =   JSON.parse(data)['Data']['Facility']['FacilityName']
      degreeTitle =  JSON.parse(data)['Data']['DegreeTitleLookup']['Code']
      status = JSON.parse(data)['Status']

      flash.now[:notice] = "Welcome " + degreeTitle + " " + firstName + " " + lastName

    else
      flash[:notice] = "Invalid User Name or Password. Try Again."
     # render :action => :new
    end



    a = @userName
  end

  def destroy
  end
end
