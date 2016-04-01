module SocialsHelper::MetaTags
  DEFAULT_IMAGE = 'https://themontessori.com/default.jpg'
  DEFAULT_AUTHOR = 'The Montessori Company'
  DEFAULT_DESCRIPTION = 'default_description_here'

  FB_PAGE = 'fb_page_here'
  TWITTER_ACCOUNT = '@twitter_account'

  def meta_tags(title:, url: current_full_url,
                image: DEFAULT_IMAGE, author: DEFAULT_AUTHOR,
                description: DEFAULT_DESCRIPTION)

    og(title: title, url: url, image: image,
       description: description, author: author
      ).concat(twitter(title: title, image: image, description: description)
              ).html_safe
  end

  def object_image(object)
    object.images.empty? ? DEFAULT_IMAGE : object.primary_image.image.url
  end

  private

  def og(title:, url:, type: 'article', image:, description:, author:)
    <<-META
      <meta property='og:title' content='#{title}'/>
      <meta property='og:type' content='#{type}'/>
      <meta property='og:image' content='#{image}'/>
      <meta property='og:url' content='#{url}'/>

      <meta property='og:site_name' content='#{t(:site_name)}'/>
      <meta property='og:description' content='#{description}'/>

      <meta property='article:author' content='#{FB_PAGE}' />

      <meta name='author' content='#{author}'/>
      <meta name='description' content='#{description}'/>
    META
  end

  def twitter(title:, type: 'summary_large_image', image:, description:)
    <<-META
      <meta name='twitter:card' content='#{type}'>
      <meta name='twitter:site' content='#{TWITTER_ACCOUNT}'>
      <meta name='twitter:creator' content='#{TWITTER_ACCOUNT}'>
      <meta name='twitter:title' content='#{title}'>
      <meta name='twitter:description' content='#{description}'>
      <meta name='twitter:image:src' content='#{image}'>
    META
  end
end
