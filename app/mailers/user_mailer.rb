class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    @confirmation_url = confirm_email_url(token: user.confirmation_token)

    mail(
      from: 'TuneBox <noreply@tunebox.jp>',
      to: @user.email,
      subject: 'TuneBox - メールアドレスの確認'
    )
  end

  def password_reset_email(user)
    @user = user
    @reset_url = reset_password_url(token: user.reset_password_token)

    mail(
      from: 'TuneBox <noreply@tunebox.jp>',
      to: @user.email,
      subject: 'TuneBox - パスワードリセット'
    )
  end
end
