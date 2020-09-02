# README
最終課題研修を実施するにあたり使用する雛形アプリです。

実装時に必要にとなるビューファイルが用意してあります。

このREADMEは編集せず、DB設計は**DATABASE.md**に記載して下さい。

## 用意されているビューファイル

|URI|controller#action|機能|
|:-:|:-:|:-:|
|/|items#index|トップページ(商品一覧)|
|users/sign_in|users/sessions#new|ログイン画面|
|users/select|users/registrations#select|新規登録方法の選択|
|users/sign_up|users/regisrations#new|新規登録フォーム(email)|
|users/confirm_phone|users/registrations#confirm_phone|新規登録フォーム(電話番号認証)|
|users/new_address|users/registrations#new_address|新規登録フォーム(住所)|
|users/completed|users/registrations#completed|新規登録フォーム(登録完了)|
|users/:id|users#show|マイページ|
|items|items#index|商品一覧|
|items/new|items#new|商品出品フォーム|
|items/:id/edit|items#edit|商品編集フォーム|
|items/:id|items#show|商品詳細|
|items/:id/purchase_confirmation|items#purchase_confirmation|購入確認|
|items/search|items#search|商品検索|
|categories|categories#index|カテゴリ一覧|
|categories/:id|categories#show|各カテゴリの商品一覧|
|cards|cards#index|クレジットカードの一覧|
|cards/new|categories#show|クレジットカードの登録フォーム|
