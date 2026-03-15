class ApplicationMailer < ActionMailer::Base
  default from: "Dr Isara Khanjanasthiti <#{ENV.fetch("MAILER_SENDER", "noreply@example.com")}>"
  layout "mailer"
end
