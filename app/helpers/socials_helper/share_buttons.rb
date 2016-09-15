module SocialsHelper::ShareButtons
  def pin_it(url: current_full_url, image:, icon: 'pinterest_button',
             description: '')
    <<-PIN.html_safe
      <a data-pin-do="buttonPin"
         data-pin-custom="true"
         data-pin-url="#{url}"
         data-pin-description="#{cleanup(description)}"
         data-pin-media="#{image}"
         href="https://www.pinterest.com/pin/create/button/">
        #{image_tag(icon, alt: 'Pinterest button', class: 'icon')}
      </a>
    PIN
  end

  def tweet(text:, icon: 'twitter_button', url: current_full_url)
    hashtags = "montessori,handmade,teaching,education,learning"
    helpers.link_to("https://twitter.com/share?url=#{url}&text=#{text}&" \
                    "hashtags=#{hashtags}", target: '_blank') do
      helpers.image_tag(icon, alt: 'Twitter button', class: 'icon')
    end
  end

  def facebook_like(icon: 'facebook_button')
    helpers.image_tag(icon, alt: 'Facebook button',
                     class: 'facebook-button icon')
  end

  private

  def helpers
    ActionController::Base.helpers
  end

  def cleanup(text)
    strip_tags(text).gsub('"', "&#34;")
  end
end
