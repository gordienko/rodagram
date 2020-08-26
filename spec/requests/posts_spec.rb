RSpec.describe App, roda: :app do

  describe "Posts request" do

    describe "POST /posts/create" do

      post_params = { login: Faker::Internet.username(specifier: 5..8),
                      title: Faker::Lorem.sentence(word_count: 3, supplemental: true),
                      body: Faker::Lorem.paragraph_by_chars(number: 2048, supplemental: false),
                      creator_ip: Faker::Internet.ip_v4_address }

      it "return new post json" do
        post "/posts/create", post_params
        expect(last_response.status).to eq 200
        json = JSON.parse(last_response.body)
        expect(json['title']).to eq post_params[:title]
      end

      it "return login blank validation failed" do
        post "/posts/create", post_params.except(:login)
        expect(last_response.status).to eq 422
        json = JSON.parse(last_response.body)
        expect(json['error']).to eq "Validation failed: Login can't be blank"
      end

      it "return title blank validation failed" do
        post "/posts/create", post_params.except(:title)
        expect(last_response.status).to eq 422
        json = JSON.parse(last_response.body)
        expect(json['error']).to eq "Validation failed: Title can't be blank"
      end

      it "return body blank validation failed" do
        post "/posts/create", post_params.except(:body)
        expect(last_response.status).to eq 422
        json = JSON.parse(last_response.body)
        expect(json['error']).to eq "Validation failed: Body can't be blank"
      end

      it "return creator ip blank validation failed" do
        post "/posts/create", post_params.except(:creator_ip)
        expect(last_response.status).to eq 422
        json = JSON.parse(last_response.body)
        expect(json['error']).to eq "Validation failed: Creator ip is empty or in the wrong format"
      end

      it "return creator ip format validation failed" do
        post "/posts/create", post_params.merge(creator_ip: 'this_is_not_a_ip_address')
        expect(last_response.status).to eq 422
        json = JSON.parse(last_response.body)
        expect(json['error']).to eq "Validation failed: Creator ip is empty or in the wrong format"
      end

    end

    describe "POST /post/rate" do
      post_id = nil
      post_json = {}
      it "return ID of a random post" do
        get "/random"
        expect(last_response.status).to eq 200
        post_id = JSON.parse(last_response.body).dig('id')
        expect(post_id).to be_a_kind_of(Integer)
      end

      it "return post json before rate" do
        get "/post/#{post_id}"
        expect(last_response.status).to eq 200
        post_json = JSON.parse(last_response.body)
        expect(post_json.dig('id')).to eq(post_id)
      end

      rate_value = (1..5).to_a.sample
      it "return post json after rate" do
        post "/post/#{post_id}/rate", { value: rate_value}
        expect(last_response.status).to eq 200
        json = JSON.parse(last_response.body)
        expect(json.dig('rates_count')).to eq(post_json.dig('rates_count') + 1)
        expect(json.dig('sum_rating')).to eq(post_json.dig('sum_rating') + rate_value)
      end

      it "return rate < 1 validation failed" do
        post "/post/#{post_id}/rate", { value: 0}
        expect(last_response.status).to eq 422
        json = JSON.parse(last_response.body)
        expect(json['error']).to eq "Validation failed: Value must be greater than or equal to 1"
      end

      it "return 0 rate > 5 validation failed" do
        post "/post/#{post_id}/rate", { value: 6}
        expect(last_response.status).to eq 422
        json = JSON.parse(last_response.body)
        expect(json['error']).to eq "Validation failed: Value must be less than or equal to 5"
      end
    end

    describe "GET /top" do
      it "return top 100 posts" do
        get "/top/100"
        expect(last_response.status).to eq 200
        json = JSON.parse(last_response.body)
        expect(json.count).to eq(100)
      end

      it "return not found error on request without number" do
        get "/top"
        expect(last_response.status).to eq 404
      end
    end

    describe "GET /addresses" do
      it "return ip addresses statictics" do
        get "/addresses"
        expect(last_response.status).to eq 200
        json = JSON.parse(last_response.body)
        expect(json.last.dig('authors').count).to be > 1
      end

    end

  end

end