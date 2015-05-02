class Profiles::EmailsController < Profiles::ApplicationController
  def index
    @primary = current_user.email
    @public_email = current_user.public_email
    @emails = current_user.emails
  end

  def create
    @email = current_user.emails.new(email_params)

    flash[:alert] = @email.errors.full_messages.first unless @email.save

    redirect_to profile_emails_url
  end

  def destroy
    @email = current_user.emails.find(params[:id])
    @email.destroy

    current_user.set_notification_email
    current_user.set_public_email
    current_user.save if current_user.notification_email_changed? or current_user.public_email_changed?

    respond_to do |format|
      format.html { redirect_to profile_emails_url }
      format.js { render nothing: true }
    end
  end

  private

  def email_params
    params.require(:email).permit(:email)
  end
end
