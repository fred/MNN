ActiveAdmin.register Item do
  config.sort_order = "id_desc"
  menu :priority => 1
  show do
    render "show"
  end
  index do
    column :id
    column :image do |item|
      if !item.attachments.empty?
        link_to(
          image_tag(item.attachments.first.image.thumb.url), 
          admin_attachment_path(item.attachments.first),
          :title => item.abstract,
        ) 
      end
    end
    column :user
    column "Title", :sortable => :title do |item|
      link_to item.title, admin_item_path(item), :title => item.abstract, :class => "featured_#{item.featured}"
    end
    column :draft, :sortable => :draft do |item|
      bol_to_word(item.draft)
    end
    column "Feat.", :featured, :sortable => :featured do |item|
      bol_to_word(item.featured)
    end
    column :language, :sortable => :language_id do |item|
      item.language.description if item.language
    end
    column "Updated", :sortable => :updated_at do |item|
      item.updated_at.to_s(:short)
    end
    column "Published", :sortable => :published_at do |item|
      item.published_at.to_s(:short)
    end
    default_actions
  end
  form :partial => "form"
  controller do
    def new
      @item = Item.new
      @now = Time.zone.now
      @item.published_at = @now+3600
      @item.expires_on = @now+10.years
      @item.draft = true
      @item.author_name = current_admin_user.title
      @item.author_email = current_admin_user.email
      @item.user_id = current_admin_user.id
    end
  end
end
