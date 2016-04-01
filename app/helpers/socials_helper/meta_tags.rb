module SocialsHelper::MetaTags

  def meta_tags(title:, url: current_full_url,
                image: SocialsHelper::DEFAULT_IMAGE,
                author: SocialsHelper::DEFAULT_AUTHOR,
                description: SocialsHelper::DEFAULT_DESCRIPTION)

    og(title: title, url: url, image: image,
       description: description, author: author
      ).concat(twitter(title: title, image: image, description: description)
              ).html_safe
  end

  def object_image(object)
    if object.images.empty?
      SocialsHelper::DEFAULT_IMAGE
    else
      object.primary_image.image.url
    end
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

      <meta property='article:author' content='#{SocialsHelper::FB_PAGE}' />

      <meta name='author' content='#{author}'/>
      <meta name='description' content='#{description}'/>
    META
  end

  def twitter(title:, type: 'summary_large_image', image:, description:)
    <<-META
      <meta name='twitter:card' content='#{type}'>
      <meta name='twitter:site' content='#{SocialsHelper::TWITTER_ACCOUNT}'>
      <meta name='twitter:creator' content='#{SocialsHelper::TWITTER_ACCOUNT}'>
      <meta name='twitter:title' content='#{title}'>
      <meta name='twitter:description' content='#{description}'>
      <meta name='twitter:image:src' content='#{image}'>
    META
  end
end
