require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'sinatra/activerecord'
require './models/user.rb'

# 1. Webサーバを立ち上げてくださいは省略

# 2. GET / で hello world! を表示してください（指示があるまでerbは使わない）
# サーバがレスポンスを返すの意味がわかるはず
get '/' do
  'hello world!'
end
# 3. GET / で h1タグに囲まれた hello world! を表示してください
# 「サーバがHTMLを作って返す」の意味がわかるはず
get '/html' do
  '<h1>hello world!</h1>'
end

# 4. <html> や <head> や <body> も含まれるようにしてください
# 面倒くさくて辛いはず
get '/html-completed' do
  '<html><head></head><body><h1>hello world!</h1></body></html>'
end

# 5. erb ファイルを使って書き換えてください
# Viewのありがたみがわかるはず
get '/html-completed-erb' do
  erb :html_completed
end

# 6. link_to メソッドを自前で定義してください。それを erb ファイルの中で使って a タグを出力してください
# link_toは単にaタグを出力するための便利メソッドだったってことがわかるはず
get '/learn-link-to' do
  erb :learn_link_to
end

# 7. layout.erbを作り、<html><head>などを共通化してください
# レイアウトファイルのありがたみがわかるはず
get '/learn-layout' do
  erb :learn_layout
end

# 8. sqlite3を入れてデータベースからユーザーを取得してきてユーザーの一覧を表示してください
# データベースにアクセスしにいくという意味がわかるはず
get '/users' do
  db = SQLite3::Database.new 'sample.db'
  rs = db.execute('select * from users;')
  @users_hash = rs.map do |row|
    { id: row[0], name: row[1] }
  end
  erb :'users/index'
end

# 9. ユーザーの新規作成画面を作ってください。formを自分で作ってください。
# フォームとはなんぞやの意味がわかるはず
get '/users/new' do
  erb :'users/new'
end

# 10. ユーザーの登録処理を作ってください。作ったら/にリダイレクトさせてください。
# GETやPOSTとはなんぞやがわかるはず。リダイレクトとレンダーの違いがわかるはず。
post '/users' do
  db = SQLite3::Database.new 'sample.db'
  sql = 'insert into users(name) values(?);'
  stmt = db.prepare(sql)
  stmt.bind_params(params[:name])
  stmt.execute

  redirect to('/users')
end

# 11. sinatra-activerecordを使ってユーザー一覧画面を表示してください
# ActiveRecordの便利さがわかるはず
get '/ar/users' do
  @users = User.all
  erb :'ar/users/index'
end

# 12 sinatra-activerecordを使ってユーザー登録処理を作ってください
# ActiveRecordの便利さがわかるはず
get '/ar/users/new' do
  erb :'ar/users/new'
end

# ActiveRecordの便利さがわかるはず
post '/ar/users' do
  User.create(name: params[:name])
  redirect to('/ar/users')
end
