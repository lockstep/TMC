module Admin
  class ImagesController < Admin::ApplicationController
    def create
      image = Image.new(adjusted_params)
      image.save
      redirect_to admin_image_path(image)
    end

    def update
      image = Image.find(params[:id])
      image.update(adjusted_params)
      redirect_to admin_image_path(image)
    end

    private

    def image_params
      params.require(:image).permit(:product_id, :primary, :caption, :image)
    end

    def adjusted_params
      modified_params = image_params
      modified_params[:imageable_id] = modified_params.delete(:product_id)
      modified_params[:imageable_type] = 'Product'
      modified_params
    end
  end
end
