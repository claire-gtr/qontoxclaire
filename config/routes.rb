Rails.application.routes.draw do
  root to: 'pages#home'

  RedirectionService.new(self).call
end
