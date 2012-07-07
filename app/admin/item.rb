ActiveAdmin.register Item do
  controller.authorize_resource
  config.sort_order = "id_desc"

  scope :published
  scope :highlight
  scope :sticky
  scope :original
  scope :draft
  scope :with_comments
  scope :queued

  menu priority: 1, if: lambda{|tabs_renderer|
    controller.current_ability.can?(:read, Item)
  }
  sidebar :per_page, partial: "per_page", only: :index

  before_filter only: :index do
    if params[:per_page]
      @per_page = params[:per_page].to_i
    end
  end

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
          title: item.abstract,
        )
      elsif item.youtube_id && item.youtube_img
        link_to(
          image_tag("https://img.youtube.com/vi/#{item.youtube_id}/1.jpg",
            class:"youtube_mini"
          ),
          admin_item_path(item),
          title: "Youtube ID: #{item.youtube_id}"
        )
      end
    end
    column :user
    column "Title", sortable: :title do |item|
      link_to item.title, admin_item_path(item), title: item.abstract, class: "featured_#{item.featured}"
    end
    column :category, sortable: :category_id
    column :keywords
    column :tags do |item|
      item.tag_list(", ")
    end
    column "Youtube", :youtube_id, sortable: :youtube_id do |item|
      if item.youtube_id
        link_to(item.youtube_id,
          "http://www.youtube.com/watch?v=#{item.youtube_id}",
          title: "Open Youtube video page",
          target: "blank"
        )
      end
    end
    column "Views", sortable: false do |item|
      item.item_stat.views_counter if item.item_stat
    end
    column "Comments", :comments_count
    bool_column :draft
    bool_column :original
    column "Highlt", :featured, sortable: :featured do |item|
      bool_symbol(item.featured)
    end
    bool_column :sticky 
    column "Lang", :language, sortable: :language_id do |item|
      item.language.description if item.language
    end
    column "Updated", sortable: :updated_at do |item|
      item.updated_at.localtime.to_s(:short)
    end
    column "Live", sortable: :published_at do |item|
      if !item.draft? && item.published_at && item.published_at > Time.zone.now
        ("<span class='red bold'>" +
        time_ago_in_words(item.published_at) +
        " from now" +
        '</span>').html_safe
      elsif !item.draft? && item.published_at
        ("<span class='green bold'>" +
        time_ago_in_words(item.published_at) +
        " ago" +
        '</span>').html_safe
      else
        item.published_at.localtime.to_s(:short)
      end
    end
    column "Site", sortable: false do |item|
      link_to "Show", item
    end
    default_actions
  end
  form partial: "form"

  controller do

    def new
      authorize! :create, Item
      @item = Item.new
      @now = Time.zone.now
      @item.published_at = nil
      @item.expires_on = @now+10.years
      @item.draft = true
      @item.author_name = current_admin_user.title
      @item.author_email = current_admin_user.email
      @item.user_id = current_admin_user.id
    end

    def show
      @item = Item.find(params[:id])
      @related = @item.solr_similar(10)
      authorize! :read, @item
    end

    def edit
      @item = Item.find(params[:id])
      authorize! :edit, @item

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

    def update
      @item = Item.find(params[:id])
      authorize! :edit, @item
      if @item.update_attributes(params[:item])
        flash[:notice] = "Successfully updated Item."
        redirect_to @item
      else
        render action: 'edit'
      end

    rescue ActiveRecord::StaleObjectError
      correct_stale_record_version
      stale_record_recovery_action
    end

    def create
      @item = Item.new(params[:item])
      @item.user_id = current_admin_user.id
      authorize! :create, @item
      unless (current_admin_user.has_any_role?(:admin,:editor,:security))
        @item.draft = true
        @item.share_twitter = nil
        @item.send_emails = nil
      end
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

    def destroy
      @item = Item.find(params[:id])
      authorize! :destroy, @item
      if (current_admin_user.has_any_role?(:admin,:editor,:security)) or (current_admin_user.id == @item.user_id)
        @item.destroy
        flash[:notice]= "Item successfully deleted"
      else
        flash[:notice]= "You are not allowed to delete this Item"
      end
      respond_to do |format|
        format.html {redirect_to admin_items_path}
        format.js {render layout: false}
        format.json
        format.xml
      end
    end

    def correct_stale_record_version
      @item.reload
    end

    def stale_record_recovery_action
      flash[:error] = "Error: Another user has updated this record "+
         "since you accessed the edit form."
      render :edit, status: :conflict
   end

    def scoped_collection
       Item.includes(:language, :attachments, :tags, :user, :category, :item_stat)
    end
  end
end
