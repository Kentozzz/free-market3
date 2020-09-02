class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  prepend_before_action :check_recaptcha, only: [:create]
  before_action :session_has_not_user, only: [:confirm_phone, :new_address, :create_address]
  layout 'no_menu'

  def select
    session.delete(:"devise.sns_auth")
    @auth_text = "で登録する"
  end

  # GET /resource/sign_up
  def new
    @progress = 1  ## 追加
    if session["devise.sns_auth"]
      ## session["devise.sns_auth"]がある＝sns認証
      build_resource(session["devise.sns_auth"]["user"])
      @sns_auth = true
    else
      ## session["devise.sns_auth"]がない=sns認証ではない
      super
    end
  end

  # POST /resource
  def create
    if session["devise.sns_auth"]
      ## SNS認証でユーザー登録をしようとしている場合
      ## パスワードが未入力なのでランダムで生成する
      password = Devise.friendly_token[8,12] + "1a"
      ## 生成したパスワードをparamsに入れる
      params[:user][:password] = password
      params[:user][:password_confirmation] = password
    end
  
    build_resource(sign_up_params)  ## @user = User.new(user_params) をしているイメージ
    ## -----追加ここから-----
    unless resource.valid? ## 登録に失敗したとき
      ## 進捗バー用の@progressとflashメッセージをセットして戻る
      @progress = 1
      @sns_auth = true if session["devise.sns_auth"]
      flash.now[:alert] = resource.errors.full_messages
      render :new and return
    end
    session["devise.user_object"] = @user.attributes  ## sessionに@userを入れる
    session["devise.user_object"][:password] = params[:user][:password]  ## 暗号化前のパスワードをsessionに入れる
    respond_with resource, location: after_sign_up_path_for(resource)  ## リダイレクト
    end

  def confirm_phone
    @progress = 2
  end

  def new_address
    @progress = 3
    @address = Address.new 
  end

  def create_address
    @progress = 5
    @address = Address.new(address_params)
    if @address.invalid? ## バリデーションに引っかかる（save不可な）時
      redirect_to users_new_address_path, alert: @address.errors.full_messages
    end
    ## user,sns_credential,addressの登録とログインをする
    @progress = 5
    ## ↓@user = User.newをしているイメージ
    @user = build_resource(session["devise.user_object"])
    @user.build_sns_credential(session["devise.sns_auth"]["sns_credential"]) if session["devise.sns_auth"] ## sessionがあるとき＝sns認証でここまできたとき
    @user.address = @address
    if @user.save
      sign_up(resource_name, resource)  ## ログインさせる
    else
      redirect_to root_path, alert: @user.errors.full_messages
    end
  end

  def completed
  end

  def session_has_not_user
    redirect_to new_user_registration_path, alert: "会員情報を入力してください。" unless session["devise.user_object"].present?
  end

  private
  def check_recaptcha
    redirect_to new_user_registration_path unless verify_recaptcha(message: "reCAPTCHAを承認してください")
  end

  def after_sign_up_path_for(resource)
    users_confirm_phone_path  
  end

  def address_params
    params.require(:address).permit(
      :phone_number,
      :postal_code,
      :prefecture_id,
      :city,
      :house_number,
      :building_name,
      )
  end
end
