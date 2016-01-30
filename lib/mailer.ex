defmodule OtziSpace.Mailer do
  @config domain: Application.get_env(:otzi_space, :mailgun_domain),
  key: Application.get_env(:otzi_space, :mailgun_key)
  use Mailgun.Client, @config

  @from "robot@otzi.space"

  def send_welcome_text_email(user, confirmation_link) do
        send_email to: user.email,
                   from: @from,
                   subject: "hello!",
                   text: "Welcome, #{user.email}! Please confirm your account following the link #{confirmation_link}"
  end

  def send_welcome_html_email(user, confirmation_link) do
        send_email to: user.email,
                    from: @from,
                    subject: "hello!",
                    html: "<strong>Welcome, #{user.email}!</strong>
                    Please <a href=\"#{confirmation_link}\">confirm your account</a>."
  end
end
