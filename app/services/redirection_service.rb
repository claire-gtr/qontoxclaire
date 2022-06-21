class RedirectionService
  include SlackHelper
  attr_accessor :router
  
  def initialize(router)
    # to be able to write routes and use get and redirect here,
    # we need to have access to the router from routes.rb
    self.router = router
  end

  def call
    draw(load_redirections)
  end

  private 

  def load_redirections
    begin
      YAML.load_file(Rails.root.join('config/redirections.yml'))
    rescue Psych::SyntaxError => error
      post_to_slack("Indentation error in routes YAML file, redirections not drawn", "seo")
      raise error
    rescue URI::InvalidURIError => error
      post_to_slack("Syntax error in routes YAML file, redirections not drawn", "seo")
      raise error
    end
  end

  def draw(redirections)
    # looping over each language
    redirections.each do |language, redirect_list|
      # looping over each redirection
      redirect_list.each do |path, redirect_object|
        new_path = sanitize(redirect_object["to"])
        # if there we'er rerouting to an external URL, 
        # don't prepend the language in the route
        new_path = "#{language}/#{new_path}" unless redirect_object["external_url"]

        router.get "#{language}/#{path}", to: router.redirect("#{new_path}", status: redirect_object["status"])
      end
    end
  end

  def sanitize(url)
    # sanitize new urls : remove the last / if need be
    url[-1] == "/" ? url.chop : url
  end
end
