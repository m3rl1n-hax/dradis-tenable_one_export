Dradis::Plugins::TenableOneExport::Engine.routes.draw do
  resources :projects, only: [] do
    resource :report, only: [:create], path: '/export/tenable-one/reports'
  end
end
