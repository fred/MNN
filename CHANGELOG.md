## October 8, 2012

  - Don't send welcome email to Twitter oauth users

## October 7, 2012

  - More effecient caching of sidebar.  
  - Added more Database Indexes
  - Added loading spinner to Turbolinks
  - Using Turbolinks on admin interface (trial testing)
  - Using turbo-sprockets gem

## October 5, 2012

  - Fixed redis-namespace
  - Added Reddit widget
  - Removed font-resizer on IE
  - Updated ActiveAdmin upstream
  - Updated gems
  - Admin/items filters
  - Reduce pagination items for admin
  - Un-hardcode links and use Settings.yml instead

## September 29, 2012

  - Frozen Twitter-Bootstrap-rails
  - Improved Bot detection, added 80legs
  - Tagged Rails logging
  - Enabled ExceptionNotifier

## September 28, 2012

  - Fixed Rolling back articles in admin interface
  - Updated Gems
  - Updated Twitter bootstrap with fix for IE7

## September 24, 2012

  - Updated Twitter Bootstrap to 2.1
  - Updated Modernizr to 2.6.2
  - Updated Gems
  - Improved JS and CSS files loading, merged JS files
  - Cleaned up and converted some JS to CoffeeScript
  - Changed Top Items to montly
  - Fixed Registration/Profile forms style
  - Limit the length of sidebar 'Popular Searches'

## September 22, 2012

  - Auto Share to Facebook Page

## September 20-21, 2012

  - Added oauth signin with Google Mail
  - Added Facebook Like icon
  - Updated Gems,
  - Better support for jRuby and Trinidad deployment
  - Change social icons to be more uniform
  - Fixed bug on gmail login
  - Improved social icons at bottom of article

## September 18, 2012

  - Release version 1.0.3

Architecture:

  - Partitioned Image IDs so that a folder won't have more than 9,999 Images

Improvements:

  - Upgraded ActiveAdmin to 0.5.0
  - Disabled ActiveAdmin body style to allow 3rd parties CSS to work
  - Cleaned up Gemfile


## September 15-17, 2012

  - Added Copy button to images/attachments
  - Allow iframe and src for pre-approved comments
  - Improved style for displaying comments (ul/ol)
  - Smaller dashboard
  - Updated Gems
  - Improved Bot Detection
  - Improved Security for comments
  - Added comments count for users
  - Allow html/iframe on comments editor
  - Auto convert links on comments editor

Bug Fix:

  - Fixed login issues for admin
  - Fix style for comments
  - Fixed sidebar translations

Performance:

  - Improved performance by 20% from caching more fragments
  - App can handle now 8-12 req/sec per worker
  - Reduced Database preasure


## September 11, 2012

  - Added Popular Searches on the sidebar
  - Updated TinyMCE to 3.5.6
  - Updated Sidekiq and Celluloid
  - Removed Postmark gem


## September 10, 2012

Security:

  - User Account will be locked if failed authentication after 6 atempts
  - User Account will be auto-unlocked after 1 hour
  - Increased minimum password requirement to 7 characters
  - Tightened security for comments preview on admin
  - Improved suspicious comments detection


## September 9, 2012

Security:

  - Authors are not allowed to Edit or Delete Live Articles
  - Only Editors can manage already live articles
  - Hide Edit/Delete buttons if user doesn't have the priviledges

Bug Fix:

  - Improved used Menu, always shows "Submit Article" link for authors
  - Improved Test Suit


## September 8, 2012

Security:

  - Detect and prevent user escalation on registration
  - Protect users from adding roles on registration


## September 4, 2012

Performance:

  - Don't Load TinyMCE for non logged in users, page will load faster
  - Modularized Stylesheets for better organization
  - More Caching for search engines
  - Refractored Caching/Headers control

Improvements:

  - Arranged Tags in order: General, Region, Country
  - Added Categoy to top of the Article in list box
  - Allow image to become a popup by adding the class: "image-popup"

## September 2, 2012

  - Allow Users to Edit their own comments
  - Completed Full site translations
  - Fully Translated NL (Quoriana)
  - Partially Translated PT and ES (Fred)

Bugfix

  - Don't overwrite password if user re-authenticate with Oauth

Technical

  - Added Devise Locales
  - Rspec Tests using new syntax 'expect'
  - Updated Rspec to 2.11.0
  - Improved Tests

## September 1st, 2012

  - Improved css for embedded iframes
  - Added Dynamic GooglePlus share badge under article
  - Improved Social Icons on left sidebar
  - Added more Opengraph tags
  - Increased size of image for opengraph

## August 31, 2012

  - Added Links page
  - Increased history versions to keep to 300
  - Multiple Image uploading on admin interface

## August 30, 2012

  - Added Comment Subscription
  - Users can receive email after new comments for subscribed article
  - Added page for users to manage subscriptions (/subscriptions)

## August 28, 2012

  - Saving of site Searches by non-bots
  - Updated Gems

## August 21, 2012

Bugfix:

  - Fixed Youtube videos

## August 19, 2012

  - Longer Caching
  - Full page caching for bots
  - Full cache for RSS/ATOM formats

## August 17, 2012

  - Add Ability to preview/rollback previous versions
  - Nicer CSS for related items list
  - Added Password strength meter on registration form
  - Upgraded jquery to 1.8.0
  - Updated Gems

## August 12, 2012

  - Improved Admin interface
  - Improved Serch results
  - Searching scoped on site language

## August 10, 2012

Bugfixes

  - Fix Bug that un-published items shows on similar items
  - Fixed youtube video Javascript loading
  - Fixed bug that Authors did not see 'New Item' link

Features

  - Full JRuby support
  - Added some translations, ie. Dutch
  - Improved performance of /admin pages
  - Cleaned up ActiveAdmin filters/sidebar
  - Visual improvements in admin Images

## August 8, 2012

  - Change to rmagick from mini_magick
  - Several SQL performance improvements
  - Improved SQL Joins
  - Better caching on sidebar and navbar
  - Allow target, rel and rev tags in comment links

## August 4, 2012

  - Fixed Sitemap
  - Added languages to Sitemap
  - Improved HTTP caching headers

## August 3, 2012

  - Big performance improvements
  - Added indexex to some tables
  - Added caching to RSS and ATOM feed
  - Added Cannonical links to articles for google
  - Added rel/rev to links
  - Increased caching time

## August 1, 2012

  - Improved registration and login forms
  - Fixed caching with languages Locale

## July 31, 2012

  - Updated to rails 3.2.7
  - Using larger image for opengraph (G+,Twitter)
  - Added more tests

## July 29, 2012

  - Added Multi-language site with subdomains
  - Added Flags to language menu
  - Improved Admin interface
  - Improved Error Alerts with Twitter-bootstrap
  - Better Error Pages
  - Updated google plus link
  - Updated Gems

## July 24, 2012

  - Fixed bug on comments RSS
  - Added rel, rev, and title tags to links
  - Improved SEO
  - Updated Zocial css and fonts

## July 18, 2012

  - Improved hints on new item form
  - Minor CSS improvements for item
  - Updated Sidekiq/Celluloid gems
  - Updated Assets

## July 17, 2012

  - Updated Twitter Gem
  - Moved SOLR to new instance

## July 16, 2012

  - Updated Dalli fixing "key too long" error

## July 12, 2012

  - Changed sidebar from 3 to 5 Top items
  - Fixed RSS error on comments RSS

## July 9, 2012

  - Allow Quote and italic tags on comments
  - Updated Gems

## July 7, 2012

  - Allows to delete Emails Deliveries properly
  - Added record locking to avoid duplicated updates
  - Added Custom Youtube resolution
  - Removed most commented from Sidebar
  - Updated Gems

## July 1-5, 2012

  - Fixed Wrong ATOM feed time on article, bug #6
  - Added global Comments page: /comments
  - Global comments RSS: /comments.rss
  - Improved admin interface
  - Added number of days since items on categories
  - fixed google indexing
  - removed user email
  - better registration form
  - removed all references of the user's email address
  - Forcing HTTPS always for admin users
  - original author links improved
  - twitter queue delete links
  - minor bug fixes
  - updated many gemfiles

## June 24, 2012

  - Improved Original Author links
  - Fixed original author link on emails
  - Allow Admins to delete Twitter queue jobs
  - Updated Gems
  - Bundled AnyTime into a Gem

## June 23, 2012

  - Improved meta tags based on google webmaster info
  - Added Site Links to top menu
  - Changed from H2 to H1 on landing page
  - Addded H1 header on tag/language pages
  - Code cleanup
  - Rspec tests added

## June 22, 2012

  - Added Authors to top menu
  - Added poll_interval to sidekiq
  - Improved CSS for comments
  - Updated Gems
  - Fix modernizr on ipad
  - set default items_count to 0
  - Rearanged Asset files into vendor
  - Serving twitter widgets.js from own domain

## June 22, 2012

  - Added registration reason to edit profil
  - Updated Gems
  - Tuned postgresql.conf

## June 20, 2012

  - Added WindowsLive connect
  - Improved Admin interface for users/admin_users
  - re-aranged Admin Dashboard
  - Added links to admin (WIP)
  - Updated Gems

## June 19, 2012

  - Improved Welcome Email

## June 18, 2012

  - Updated robots.txt
  - Updated Gems
  - fixed missing font errors
  - Welcome Email (testing)
  - updated Rspec Tests

## June 17, 2012

  - Updated URL to have item ID i.e. "123-headline-big-news"
  - Improved ipad portrait mode

## June 16, 2012

  - Add ability to upload documents
  - Fixed bug on attachments page
  - Updated robots.txt to ignore some bots and paths
  - Lots of improvements for small mobile screens
  - Improved iphone 3g/3gs, android, blackberry support
  - Updated Gems

## June 15, 2012

  - Updated Rails and Sunspot SOLR
  - Security Update
  - Updated gems
  - font size fixed for highlights on CCS3 browsers
  - Added Item title to posterous share button

## June 14, 2012

  - Fixed blockquote font color, was too light
  - Added time ago for published items
  - Updated gems
  - Updated Twitter Bootstrap

## June 12-13, 2012

  - made font slightly darker
  - Improved admin performance
  - Updated gems
  - Admin User must set the published date
  - Allow to reuse images on new items

## June 9, 2012

  - Added some nice filters to admin/items
  - updated gems
  - Added scopes for refractoring
  - added original ticker

## June 7, 2012

  - Fixed bug for opensearch.xml
  - Fixed bug: showing unpublished items on author page
  - refractored code
  - minor bug fixes

## June 3, 2012

  - Oauth with Twitter
  - Updated Rails to 3.2.5
  - Updated gems
  - Improved twitter links
  - Improved Admin interface
  - Fixed bug about draft items countdown
  - Added RSS feed for comments

## June 1, 2012

  - Several minor bug fixes
  - Added a few more rspec tests

## May 30, 2012

  - Added tinyMCE on comments
  - Changed order on sidebar

## May 29, 2012

  - Added more validation to item form
  - Removed check_for_suspicious on comments
  - Cleared unused Item columns
  - Improved new item form
  - Added 'original' checkbox to items (WIP)

## May 28, 2012

  - Fix page views bug
  - Fix bug for Recently Commented Articles
  - Added youtube image on sidebar
  - Gem update

## May 27, 2012

  - Added Recently Commented Articles to sidebar
  - Removed Language from Article page
  - Updated Twitter Bootstrap
  - Added iconification
  - Reduced sidebar caching from 10 minutes to 5 minutes

## May 26, 2012

  - Removed Recent comments from sidebar
  - Most Read items descreased from 90 to 15 days
  - Added Most Commented items in last 30 days
  - Added Popular Authors (sorted my most items)
  - Whole Sidebar is cached for 10 minutes
  - Added default image for users without image
  - Added Facebook Connect for new user registration
  - Use facebook image if user does not upload image
  - Sorting Categories by priority

## May 23, 2012

  - Process sitemap job after creation
  - Sitemap process time set for 3 minutes after published
  - Email Notification to admins on User registration

## May 20, 2012

  - Added 'edit' button for item on front end
  - Added 'new item' for user menu on front end
  - Updated Gems
  - Git push hook Email API

## May 19, 2012

  - Fixed Users/Admins Avatar bug
  - Allow Users to upload GPG keys
  - Fixed Comment notification
  - Fixed Forms for Twitter-Bootstrap 2.0.7
  - Unified Sidebar
  - ActiveAdmin fetched upstream master (4.0.4)
  - Added extra admin Links in User menu
  - Updated Gems

## May 16, 2012

  - Added sitemaps
  - Automatic generation of sitemaps in Resque
  - Improved Sitemap for news
  - Fixed SOLR Resque delete from index 

## May 14, 2012

  - Added time left in words for future items (in red color)
  - Changed Favicon
  - GPLv3 License
  - Version 1.0.1
  - Better sidebar with horizontal divider
  - Remember Selected Category on the Sidebar

## May 13, 2012 (PUBLIC LAUNCH)

  - Fixed font size and color for Blockquote
  - Made Logo a link to home page
  - Decreased box-shadows for a more suttle feeling
  - Bigger font on top-navbar
  - Removed google-plus dynamic share tracking
  - Improved Login modal box
  - using LetterOpener for better testing emails
  - Added "Submitted by: Author Name" to article emails
  - Comment body is set to required(html5)
  - Proper Email validation
  - Recent Comments added to sidebar
  - Top Items in last 90 days added to sidebar
  - Asking user registration reason on register page
  - minor bug fixes
  - more test coverage with Rspec
  - Updated TinyMCE
  - Updated gems
  - Releasing First Version 1.0.0
  - Attached License
  - added dynamic http_protocol for dev/prod envs

## May 8, 2012

  - Downgraded resque-scheduler to 1.9.9
  - fixed caching issue if a highlighted item not being first was updated.

## May 6, 2012

  - Upgraded to Twitter Bootstrap 2.0
  - Added Logo
  - Login Model Box

## May 5, 2012

  - Updated TinyMCE live editor
  - ruby1.9 syntax updates

## May 4, 2012

  - Caching Sidebar and Header for 2 hours
  - Converted hash syntax to ruby1.9
  - Global Caching Time increased from 1 to 2 hours
  - Improved true/false fields with html ticker and cross
  - Improved Suspicious/Spam Comments on dashboard
  - Added Red color to Spam Comments
  - Added Orange color to Suspicious Comments
  - Mark comments suspicious based on a few bad keywords

## May 2, 2012

  - Jobs History now in Descending order (latest first) [resque-history].
  - Clear History button in jobs history [resque-history].
  - Improved Roles Authorization code.
  - Added Rspec tests for Admin Authorization.
  - Added 'ref' to email links.

## Apr 29, 2012

  - Added Opensearch.xml (to search in Chrome url bar)
  - [OpenSearch 1.1 Draft 5] with rss, atom, and pagination
  - Greatly improved performance of Search and Indexes
  - Added eager loading joins to SQL search
  - Added RSS/Atom support for search
  - Upgraded Carrierwave to 0.6.2 
  - Upgraded other gems

## Apr 27, 2012

  - Improved Comments email
  - Improved the Roles Permissions for admin pages
  - Changed TinyMCE Editor to html5 mode (fix character encoding)
  - Emails now should be better formatted

## Apr 26, 2012

  - Rspec and Factory_Girl updated to latest
  - Updated all rspec tests for new versions of gem
  - Added Image Uploading specs for carrierwave
  - Adjusted Youtube image size to be 100px wide max

## Apr 25, 2012

  - Fix for Double submitting button on forms
  - Added Upgrade/Dowgrade option for Users/AdminUsers 
  - Roles are only apliable to Admin Users
  - Allow to create users/adminUsers on admin interface
  - Added email alert for new Comments /admin/comment_subscriptions
  - Added youtube image to email if it's a video
  - Youtube image bug fix on Highlights
  - Added a few Rspec tests
  - other various fixes and improvements
  - Updated Gems

## Apr 24, 2012

  - Fixed bug in mail links
  - Fixed Replacing of unwanted characters
  - Updated Gems
  - Added Alt tag to images

## Apr 21, 2012

  - Added Resque Scheduler for Publication Date in items
  - Scheduling Twitter Status updates (resque-scheduler)
  - Scheduling Email Notifications
  - Updated RSPEC tests
  - Added Subscriptions and Alerts to /admin/
  - html boilerplate for emails [http://htmlemailboilerplate.com]

## Apr 20, 2012

  - Added CSS Style for Emails

## Apr 19, 2012

  - Added Email Subscriptions
  - Added PostmarkApp for sending emails
  - Changed Logging style
  - Added Rspec Tests for email subscriptions

## Apr 18, 2012

  - Improved Author Page
  - Added more Rspec Tests
  - fixed bug on author page with avatar
  - Added Category to admin/items index page
  - Added Youtube screenshot to admin/items
  - Added Youtube ID with link to admin/items
  - Thumbnail on admin/items opens the item itself
  - Added Video to item page in admin
  - Added Comments count under mini item divs
  - Increased padding in some parts for nicer look

## Apr 17, 2012

  - Added Site Settings
  - Resque-History
  - Added GA
  - Test job added

## Apr 16, 2012

  - Added Flattr
  - Removed Facebook
  - Added for testing jquery.wysiwyg Editor
  - Improved Comment style

## Apr 13, 2012

  - Internal Commenting System completed
  - Added avatar image to user profile
  - Reduced memcached caching to 2 hours
  - Moved solr similar items to cached fragment block
  - Added Comments to Admin interface

## Apr 10, 2012

  - Updated to Rails 3.2.3, fixed security vulnerabilities

## Apr 07, 2012

  - Removed twitter Javascript helper
  - Changed links from https to http for sharing icons
  - Added resque take task back
  - Added AddressBook
  - country-select gem

## Apr 06, 2012

  - Twitter updating is now using a Resque Queue
  - jQuery-rails 1.7.2 update
  - Back to using Resque

## Apr 01, 2012

  - Fixed caching bug if item Images were modified
  - Improved Item Cache Key to included last image timestamp
  - Improved Item cache key to use human readable timestamps
  - Revamped RSS/Atom Feeds
  - Added basic Rspec Tests for RSS/Atom feeds
  - Updated Feed Titles to match site name
  - Improved Attachments Admin interface (/admin/attachments/1234)
  - Improved performance of admin interface by adding Include joins sql queries.
  - Changed per_page from 40 to 24 for faster loading.
  - Upgraded ActiveAdmin to version 4.0.3
  - Removed jQuery-ui js and css, custom minimal Modernizr.js
  - Improved assets page loading time
  - CSS and JS decreased by 80K after gzip, 300K before gzip

## Mar 30, 2012

  - Added sticky highlight feature for articles
  - Updated Dalli gem to 2.0.1, fater memcached
  - Updated other Gems

## Mar 25, 2012

  - Fixed Author Link on article page
  - Fixed bug on editing user info
  - Disabled WaterMarking temporarily

## Mar 17, 2012

  - Fixed caching bug on the Category Boxes on main page

## Mar 14, 2012

  - Add Unique UID to the images path
  - Changed keywords examples to be more appropriate on admin site
  - Gems updated
  - Testing watermark on images

## Mar 12, 2012

  - Popup image bug fix

## Mar 11, 2012

  - Highly improved performance, from 1600ms to 220ms average (6-10x faster)
  - Using fragment cache with memcached
  - Upgraded Rails to 3.2.2
  - Updated Gems
  - Fix Font Color for item text, it was too light (CSS fix).

## Mar 6, 2012

  - Fixed HTML5 spec bugs. Main Index and Category Index with Zero errors
  - 100% passing the http://validator.w3.org/check test
  - Fixed bug on twitter sharing not respecting the checkbox
  - Added longer remember me for logged in users
  - Better live preview for TinyMCE item editor
  - Improved site performance
  - Rspec tests for twitter share


## Mar 2, 2012

  - Showing 2 columns on the Admin Dashboard instead of 3
  - Temporarily Removed comments from the Admin Dashboard
  - Improved SQL performance for index page
  - Improve layout for iPad
  - Added links to Version History lists (WIP for full Versioning system)
  - Disable caching for logged in users
  - Reduced Cache to 12 hour for Staled content
  - Reduced Cache to 10 minutes for Active content

## Feb 25, 2012

  - Youtube Video Helper:
  -   Auto embed video given the youtube video ID
  -   Auto adjust video size according to screen resolution
  -   Auto add Youtube screenshot to main article view
  - Slightly increased image size for article page
  - Slightly reduced image size for mobile view to fit on smaller devices
  - Added Captcha to registration page.
  - Show Youtube Video above item body if set by the user.
  - Show "Youtube Source" if the item is a youtube video.

## Feb 23, 2012

  - fixed date on item breadcrumb
  - auto Posting to Twitter stable
  - added Favicon
  - hopefully fixed forced logout issues
  - using Dalli as memcached server

## Feb 22, 2012

  - removed SOLR resque
  - changed SOLR to be local machine

## Feb 21, 2012

  - disabled Cloudfront for now

## Feb 20, 2012

  - fixed small bug on the new item form
  - updated Gems
  - unicorn on production server

## Feb 10, 2012

  - Larger image caption, up to 60 chars.
  - updated PG gem
  - removed tooltip and image gallery for touch screen devices
  - fixed bug of highlight items

## Feb 9, 2012

  - Added Font asjustment to items, can increase/decrease font size
  - Better Anti-alising for readability
  - slight larger font
  - More rspec tests for views

## Feb 7, 2012

  - Upgraded to Rails 3.2.1, Devise 2.0.1, and all gems
  - A lot of RSPEC Test

## Feb 6, 2012

  - Added Tooltip for items on main page boxes.
  - wrap text and make items fill the boxes.
  - darker font
  - added image caption and using <figure> tag for main item image
  - Main item image now shows on Safari Reader

## Feb 5, 2012

  - Implemented Roles, 75% completed.
  - Treat Admin Users as users on front end
  - Admin interface bug fixes and improvements
  - Pages bug fix

## Jan 30, 2012

  - Added item_stat to admin interface /admin/item_stats

## Jan 29, 2012

  - Remove Cropping for medium images on article page
  - Added Keyword field for searching related articles
  - Added word count to Headline and Abstract

## Jan 28, 2012

  - Added link to search for external author
  - Better CSS for tinyMCE text editor
  - Enforced SSL for "EVERY PAGE"
  - Added "Related Items" to the bottom of the article.
  An algorithm that uses tags to find related items based the body or title.

## Jan 27, 2012

  - Added IntenseDebate commenting system

## Jan 26, 2012

  - Added /feed page with description of all feeds
  - Added +1 google plus dynamic share

## Jan 25, 2012

  - Added TimePicker
  - Improved Timezone for users and article submissions
  - CSS improvements on desktop and mobile site

## Jan 24, 2012

  - Added static html Pages (/admin/pages)

## Jan 22, 2012

  - 100% Valid ATOM and RSS feeds

## Jan 21, 2012

  - All Items RSS Feeds - /rss or /atom
  - Languages RSS - /languages/english/items.rss
  - Tags RSS - /tags/war.rss
  - Categories RSS - /categories/politics.rss
  - Authors RSS - /authors/2.rss
  - Authors Page - /authors/2
  - Big icons on left for RSS and Social Media
  - Added RSS on /tags/ page for each tag

## Jan 20, 2012

  - Improved Twitter share, cut title + URL to fit on 140 chars
  no matter how long title, twitter share will always work
  - Improved Facebook share
  - Improved Slashdot sharing

## Jan 18, 2012

  - Share item icons/links for social media

## Jan 17, 2012

  - Bigger Fonts on Admin interface

## Jan 16, 2012

  - Added all social Icons for item
  - Showing 3 items on Latest NEws
  - Showing 1 Item on highlights 
  - better box size for highlights

## Jan 12, 2012

  - Site Searching with SOLR

## Jan 11, 2012

  - Languages Menu
  - Added Languages Pages /languages/english
  - added languages to breadcrumbs
