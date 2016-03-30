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
end
