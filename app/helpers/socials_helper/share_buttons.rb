module SocialsHelper::ShareButtons
  def pin_it_on_images
    <<-PIN.html_safe
      <script async
              defer
              data-pin-hover='true'
              src='//assets.pinterest.com/js/pinit.js'>
      </script>
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
      #{tweet_script}
    TWEET
  end

  private

  def tweet_script
    <<-SCRIPT
      <script>
        !function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],
        p=/^http:/.test(d.location)?'http':'https';
        if(!d.getElementById(id)){js=d.createElement(s);
        js.id=id;js.src=p+'://platform.twitter.com/widgets.js';
        fjs.parentNode.insertBefore(js,fjs);
        }}(document, 'script', 'twitter-wjs');
      </script>
    SCRIPT
  end
end
