class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  validates :nickname, :birthday, :first_name, :last_name, presence: true
  validates :first_name_reading, presence: true, format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: 'はカタカナで入力して下さい。'}
  validates :last_name_reading, presence: true, format: { with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: 'はカタカナで入力して下さい。'}
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[\w-]{8,128}+\z/i }

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  has_one :sns_credential, dependent: :destroy
  has_one :address, dependent: :destroy
  has_one :card,dependent: :destroy
  has_many :selling_items, class_name: "Item", foreign_key: "seller_id"
  has_many :bought_items, class_name: "Item", foreign_key: "buyer_id"


   def self.from_omniauth(auth_data)
    email = auth_data.info.email
    nickname = auth_data.info.name
    uid = auth_data.uid
    provider = auth_data.provider

    sns_credential = SnsCredential.where(uid: uid, provider: provider).first_or_initialize

    if sns_credential.user.present?
      return {user: sns_credential.user, sns_credential: sns_credential}
    else
      user = User.where(email: email).first_or_initialize
    end
    
    if user.persisted?
      ## ここにきた=D（メールで登録した）
      sns_credential.user_id = user.id
      sns_credential.save
    else
      ## ここにきた＝userもsns_credentialもヒットしなかった=A（ユーザー登録したことがない）
      user.nickname = nickname
    end

 
    return {user: user, sns_credential: sns_credential}
  end
end
