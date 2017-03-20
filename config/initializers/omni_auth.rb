OmniAuth.config.on_failure = Proc.new do |env|
  # Not sure why this doesn't work properly. Meant to fix
  # https://herokuapp47609268herokucom.airbrake.io/projects/120717/groups/1909764826733272840?tab=notice-detail
  # env['devise.mapping'] = Devise::Mapping.find_by_path!(
  #   env['PATH_INFO'], :path
  # )
  env['devise.mapping'] = Devise::Mapping.find_by_path!('/users', :path)
  controller_name = ActiveSupport::Inflector.camelize(
    env['devise.mapping'].controllers[:omniauth_callbacks]
  )
  controller_klass = ActiveSupport::Inflector.constantize(
    "#{controller_name}Controller"
  )
  controller_klass.action(:failure).call(env)
end
