BattlefieldTimer::Application.routes.draw do
  root to: "home#index"
  post "broadcast", to: "home#broadcast"
end
