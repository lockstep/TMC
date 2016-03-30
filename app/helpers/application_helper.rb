module ApplicationHelper
  include SocialsHelper::MetaTags

  def current_full_url
    "#{request.base_url}#{request.original_fullpath}"
  end
end
