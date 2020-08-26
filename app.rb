require './config/environment'

class App < Roda
  plugin :all_verbs
  plugin :json_parser
  plugin :error_handler

  error do |e|
    if e.is_a?(ActiveRecord::RecordNotFound)
      response.status = 404
    elsif e.is_a?(ActiveRecord::RecordInvalid)
      response.status = 422
    end
    puts e
    puts e.backtrace
    {error: e.message}.to_json
  end

  route do |r|
    r.root do
      <<-HTML
      <html>
        <head>
        <title>Hello this is RodaGram :-)</title>
        </head>
        <body> 
          <h1>Hello this is RodaGram :-)</h1>
          <ul>
             <li><a href="/top/100">Top 100 posts</a></li>
             <li><a href="/addresses">Addresses statistics</a></li>
             <li><a href="/random">Random post</a></li>
          </ul>
        </body>
      </html>
      HTML
    end

    r.on 'posts' do

      # POST /posts/create
      # curl -d "login=ivanovii&title=HellowWorldTitle&body=HellowWorldBody&creator_ip=127.0.0.1" -X POST http://localhost:3000/posts/create
      r.post 'create' do
        @user = User.find_or_create_by!(login: r.params['login'])
        Post.create!(title: r.params['title'],
                            body: r.params['body'],
                            user: @user,
                            creator_ip: r.params['creator_ip']).to_json
      end
    end

    r.on 'post', Integer do |id|
      @post = Post.find(id)

      # GET /post/:id
      # curl http://localhost:3000/post/123
      r.get do
        @post.to_json
      end

      # POST /post/:id/rate
      # curl -d "value=5" -X POST http://localhost:3000/post/123/rate
      r.post 'rate' do
        @rate = @post.rates.create!(value: r.params['value'])
        @post.to_json(only: [:id, :average_rating, :sum_rating, :rates_count])
      end
    end

    r.on 'top', Integer do |num|

      # GET /top/:num
      # curl http://localhost:3000/top/500
      r.get do
        Post.top(num)
      end
    end

    r.on 'addresses' do

      # GET /addresses
      # curl http://localhost:3000/addresses
      r.get do
        UserAddress.statictics
      end
    end

    r.on 'random' do

      # GET /random
      # curl http://localhost:3000/random
      r.get do
        {id: Post.random}.to_json
      end
    end
  end
end
