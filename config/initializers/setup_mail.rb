ActionMailer::Base.smtp_settings = {
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => "ENV["GMAIL_USERNAME"]",
          :password             => "ENV["GMAIL_PASSWORD"]",
          :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
          :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
        }
        
ActionMailer::Base.default_url_options[:host] = "localhost:3000"

