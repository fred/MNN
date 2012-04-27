ActiveAdmin.register Item do
  controller.authorize_resource
  config.sort_order = "id_desc"
  
  menu :priority => 1, :if => lambda{|tabs_renderer|
    controller.current_ability.can?(:manage, Item)
  }

  show do
    render "show"
  end
  index do
    id_column
    column :image do |item|
      if item.has_image?
        link_to(
          image_tag(item.main_image.image.thumb.url),
          admin_item_path(item),
          :title => item.abstract,
        )
      elsif item.youtube_id && item.youtube_img
        link_to(
          image_tag("https://img.youtube.com/vi/#{item.youtube_id}/1.jpg",
            :class =>"youtube_mini"
          ),
          admin_item_path(item),
          :title => "Youtube ID: #{item.youtube_id}"
        )
      end
    end
    column :user
    column "Title", :sortable => :title do |item|
      link_to item.title, admin_item_path(item), :title => item.abstract, :class => "featured_#{item.featured}"
    end
    column :category, :sortable => :category_id
    column :keywords
    column :tags do |item|
      item.tag_list(", ")
    end
    column :draft, :sortable => :draft do |item|
      bol_to_word(item.draft)
    end
    column "Youtube", :youtube_id, :sortable => :youtube_id do |item|
      if item.youtube_id
        link_to(item.youtube_id,
          "http://www.youtube.com/watch?v=#{item.youtube_id}",
          :title => "Open Youtube video page",
          :target => "blank"
        )
      end
    end
    column "Highlt", :featured, :sortable => :featured do |item|
      bol_to_word(item.featured)
    end
    column "Stick", :sticky, :sortable => :sticky do |item|
      bol_to_word(item.sticky)
    end
    column "Lang", :language, :sortable => :language_id do |item|
      item.language.description if item.language
    end
    column "Updated", :sortable => :updated_at do |item|
      item.updated_at.localtime.to_s(:short)
    end
    column "Live", :sortable => :published_at do |item|
      item.published_at.localtime.to_s(:short) if item.published_at
    end
    column "Site", :sortable => false do |item|
      link_to "Show", item
    end
    default_actions
  end
  form :partial => "form"
  
  controller do
    cache_sweeper :item_sweeper
    def new
      @item = Item.new
      @now = Time.zone.now
      @item.published_at = @now+600
      @item.expires_on = @now+10.years
      @item.draft = true
      @item.author_name = current_admin_user.title
      @item.author_email = current_admin_user.email
      @item.user_id = current_admin_user.id
    end
    def show
      @item = Item.find(params[:id])
      @related = @item.solr_similar(10)
    end
    def edit
      @item = Item.find(params[:id])
      if @item.published_at
        @item.published_at = @item.published_at.localtime
      else
        @item.published_at = Time.zone.now
      end
      if @item.expires_on
        @item.expires_on = @item.expires_on.localtime
      else
        @item.expires_on = Time.zone.now+10.years
      end
    end
    def create
      @item = Item.new(params[:item])
      @item.user_id = current_admin_user.id
      respond_to do |format|
        if @item.save
          format.html { redirect_to admin_item_path(@item), notice: 'Item was successfully created.' }
          format.json { render json: @item, status: :created, location: @item }
        else
          format.html { render action: "new" }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end
    def scoped_collection
       Item.includes(:language, :attachments, :tags, :user, :category)
    end
  end
end
