defmodule MyAppWeb.Guardian do
  use Guardian, otp_app: :my_app
  use SansPassword

  alias MyApp.Accounts

  @impl true
  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  @impl true
  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @impl true
  def deliver_magic_link(user, magic_token, _opts) do
    require Logger
    alias MyAppWeb.Endpoint
    import MyAppWeb.Router.Helpers

    Logger.info """

    Typically, we'd send an email here, but for the purposes of this
    demo, you can just click this link in your console:

        #{auth_url(Endpoint, :callback, magic_token)}

    """
    
    # Uncomment the following lines to send email, SMTP settings in config.exs
    # text = "Click this link to login #{auth_url(Endpoint, :callback, magic_token)}"
    # MyApp.Email.welcome_text_email(user.email, text) |> MyApp.Mailer.deliver_later
    
  end
end
