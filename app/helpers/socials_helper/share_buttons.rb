module SocialsHelper::ShareButtons
  def pin_it(url: current_full_url, image:, description: '')
    <<-PIN.html_safe
      <a data-pin-do="buttonPin"
         data-pin-custom="true"
         data-pin-url="#{url}"
         data-pin-description="#{description}"
         data-pin-media="#{image}"
         href="https://www.pinterest.com/pin/create/button/">
        #{image_tag('pinterest_button', alt: 'Pinterest button')}
      </a>
    PIN
  end

  def tweet(text:, url: current_full_url)
    hashtags = "montessori,handmade,teaching,education,learning"
    helpers.link_to("https://twitter.com/share?url=#{url}&text=#{text}&" \
                    "hashtags=#{hashtags}", target: '_blank') do
      helpers.image_tag('twitter_button', alt: 'Twitter button')
    end
  end

  def facebook_like
    helpers.image_tag('facebook_button', alt: 'Facebook button',
                     id: 'facebook-button')
  end

  private

  def helpers
    ActionController::Base.helpers
  end
end
