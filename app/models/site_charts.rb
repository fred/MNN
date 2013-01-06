class SiteCharts

  def self.chart_for_item(item)
    @series = []
    item.queries.each do |query|
      @series << [query.created_at.to_i*1000, 1]
    end
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(
        { text: "Page views for this Article" }
      )
      f.chart(
        {
          defaultSeriesType: "spline",
          margin: [30, 30, 70, 30]
        }
      )
      f.legend(
        {
          floating: true,
          margin: 100
        }
      )
      f.plot_options(
        # areaspline: {
        #   pointInterval: 1.day,
        #   pointStart: 10.days.ago}
        # }
        column: {
          pointPadding: 0.2,
          borderWidth: 0
        }
      )
      f.xAxis(
        type: 'datetime',
        dateTimeLabelFormats: {
          month: '%e. %b',
          year: '%b'
        }
      )
      f.series(data: @series)
    end
  end

  def self.top_comment_users(min=10)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(
        { text: "Most Comments (+#{min})" }
      )
      f.chart(
        {
          defaultSeriesType: "column",
          margin: [30, 30, 70, 30]
        }
      )
      f.legend(
        {
          floating: true,
          margin: 100
        }
      )
      f.plot_options(
        column: {
          pointPadding: 0.2,
          borderWidth: 0
        }
      )
      Comment.top_users.each do |user|
        if user.comments_count >= min
          f.series(name: user.display_name, data: [user.comments_count] )
        end
      end
    end
  end

  def self.karma_comments(min=4)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(
        { text: "Comments Karma" }
      )
      f.chart(
        {
          defaultSeriesType: "column",
          margin: [30, 30, 70, 30]
        }
      )
      f.legend(
        {
          floating: true,
          margin: 100
        }
      )
      f.plot_options(
        column: {
          pointPadding: 0.2,
          borderWidth: 0
        }
      )
      Comment.top_users.each do |user|
        if user.comments_karma >= min
          f.series(name: user.display_name, data: [user.comments_karma] )
        end
      end
    end
  end

  def self.items_karma(min = 5)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(
        { text: "Articles Karma" }
      )
      f.chart(
        {
          defaultSeriesType: "column",
          margin: [30, 30, 70, 30]
        }
      )
      f.legend(
        {
          floating: true,
          margin: 100
        }
      )
      f.plot_options(
        column: {
          pointPadding: 0.2,
          borderWidth: 0
        }
      )
      User.order("id ASC").all.each do |user|
        if (user.original_items_karma + user.items_karma) >= min
          f.series(name: user.display_name, data: [user.items_karma + user.original_items_karma] )
        end
      end
    end
  end

  def self.top_users_karma(min = 5)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(
        { text: "Total Karma Score (Comments + Articles)" }
      )
      f.chart(
        {
          defaultSeriesType: "column",
          margin: [30, 30, 70, 30]
        }
      )
      f.legend(
        {
          floating: true,
          margin: 100
        }
      )
      f.plot_options(
        column: {
          pointPadding: 0.2,
          borderWidth: 0
        }
      )
      User.order("id ASC").all.each do |user|
        if user.full_karma >= min
          f.series(name: user.display_name, data: [user.full_karma] )
        end
      end
    end
  end


  def self.top_item_users(min=6, original=false)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(
        { text: "Submitted Articles" }
      )
      f.chart(
        {
          defaultSeriesType: "column",
          margin: [30, 30, 70, 30]
        }
      )
      f.legend(
        {
          floating: true,
          margin: 100
        }
      )
      f.plot_options(
        column: {
          pointPadding: 0.2,
          borderWidth: 0
        }
      )
      AdminUser.where("items_count > 0").order("id ASC").each do |user|
        if user.items_count >= min
          f.series(name: user.display_name, data: [user.items_count] )
        end
      end
    end
  end

  def self.top_original_item_users(min=1)
    LazyHighCharts::HighChart.new('graph') do |f|
      f.title(
        { text: "Original Articles" }
      )
      f.chart(
        {
          defaultSeriesType: "column",
          margin: [30, 30, 70, 30]
        }
      )
      f.legend(
        {
          floating: true,
          margin: 100
        }
      )
      f.plot_options(
        column: {
          pointPadding: 0.2,
          borderWidth: 0
        }
      )
      AdminUser.where("items_count > 0").order("id ASC").each do |user|
        if user.original_items_count >= min
          f.series(name: user.display_name, data: [user.original_items_count] )
        end
      end
    end
  end

end

