# app/helpers/meta_tags_helper.rb
module MetaTagsHelper
  def meta_title
    content_for?(:meta_title) ? content_for(:meta_title) : "Nihongo Hero"
  end

  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : "Level up your Japanese through classic RPG fun!"
  end

  def meta_image
    meta_image = (content_for?(:meta_image) ? content_for(:meta_image) : DEFAULT_META["meta_image"])
    # little twist to make it work equally with an asset or a url
    meta_image.starts_with?("http") ? meta_image : asset_url(meta_image)
  end
end
