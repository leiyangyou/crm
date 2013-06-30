PDFKit.configure do |config|
  # config.wkhtmltopdf = '/path/to/wkhtmltopdf'
   config.default_options = {
     :page_size => 'A4',
     :print_media_type => true,
     :margin_left => '0',
     :margin_right => '0',
     :margin_top => '0',
     :margin_bottom => '0'
   }
  config.root_url = "" # Use only if your external hostname is unavailable on the server.
end