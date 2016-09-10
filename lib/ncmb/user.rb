module NCMB
  class User < NCMB::Object
    include NCMB
    
    def initialize(params = {})
      super('users', params)
    end
    
    def signUp
      begin
        result = @@client.post path, @fields
      rescue => e
        @@last_error = e
        return false
      end
      @fields.merge!(result)
      @@current_user = self
      self
    end
    
    def base_path
      path = "/#{@@client.api_version}/#{@name}"
    end
    
    def put
      params = @fields
      session_key = params[:sessionToken]
      [:objectId, :createDate, :updateDate, :sessionToken, :password].each do |name|
        params.delete name
      end
      result = @@client.put path, params, session_key
      @fields[:updateDate] = result[:updateDate]
      self
    end
    alias :update :put
    
    def delete
      response = @@client.delete path, {}, @fields[:sessionToken]
      if response == true
        @@current_user = nil
        return true
      else
        @@last_error = response
        return false
      end
    end
    
    def self.login(userid_or_email, password, authType = :id)
      params = {password: password}
      case authType.to_sym
      when :id
        params[:userName] = userid_or_email
      when :email
        params[:mailAddres] = userid_or_email
      else
        raise NCMB::APIError.new("No support #{authType} authentication. We support only id or email.")
      end
      begin
        path = "/#{@@client.api_version}/login"
        result = @@client.get path, params
      rescue => e
        @@last_error = e
        return false
      end
      @@current_user = NCMB::User.new(result)
    end
  end
end