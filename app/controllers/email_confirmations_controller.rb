class EmailConfirmationsController < ApplicationController
  def confirm
    @user = User.find_by(confirmation_token: params[:token])

    if @user.nil?
      flash[:alert] = '無効な確認リンクです。'
      redirect_to login_path
      return
    end

    if @user.confirmation_expired?
      flash[:alert] = '確認リンクの有効期限が切れています。新しい確認メールを送信してください。'
      redirect_to resend_confirmation_path
      return
    end

    if @user.confirmed?
      flash[:notice] = 'メールアドレスは既に確認済みです。'
      redirect_to login_path
      return
    end

    @user.confirm_email!
    flash[:notice] = 'メールアドレスの確認が完了しました。ログインしてください。'
    redirect_to login_path
  end

  def resend
    if request.post?
      user = User.find_by(email: params[:email])

      if user.nil?
        flash[:alert] = 'このメールアドレスで登録されたユーザーが見つかりません。'
        render :resend
        return
      end

      if user.confirmed?
        flash[:notice] = 'このメールアドレスは既に確認済みです。'
        redirect_to login_path
        return
      end

      if user.confirmation_sent_at.present? && user.confirmation_sent_at > 1.hour.ago
        flash[:alert] = '確認メールは1時間に1回まで送信できます。しばらく待ってから再試行してください。'
        render :resend
        return
      end

      user.send_confirmation_email
      flash[:notice] = '確認メールを再送信しました。メールボックスを確認してください。'
      redirect_to login_path
    end
  end
end
