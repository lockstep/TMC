module SocialsHelper::ShareButtons
  def pin_it(url: current_full_url, image:, description: '')
    <<-PIN.html_safe
      <div id="pin-it"></div>
      <a data-pin-do="buttonPin"
         data-pin-color="red"
         href="https://www.pinterest.com/pin/create/button/?url=#{url}
               &media=#{image}&description=#{description}">
      </a>
    PIN
  end

  def facebook_like(url: current_full_url)
    <<-LIKE.html_safe
      <div class="fb-like"
        data-href="#{url}"
        data-layout="standard"
        data-action="like"
        data-show-faces="true">
      </div>
    LIKE
  end

  def tweet(text:, url: current_full_url, size: 'small')
    <<-TWEET.html_safe
      <a class="twitter-share-button"
        href="https://twitter.com/intent/tweet"
        data-text=#{text}
        data-url=#{url}
        data-via=#{SocialsHelper::TWITTER_ACCOUNT}
        data-size="#{size}">
        Tweet
      </a>
    TWEET
  end
end
