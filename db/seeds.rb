require 'benchmark'
require 'net/http'
require 'uri'

user_logins = 100.times.map { Faker::Internet.username(specifier: 5..8) }
ip_v4_addresses = 50.times.map { Faker::Internet.ip_v4_address }
rate_values = (1..5).to_a

create_uri = URI.parse("http://localhost:3000/posts/create")
random_uri = URI.parse("http://localhost:3000/random")

100.times do

  request = Net::HTTP::Post.new(create_uri)
  2000.times do
    time = Benchmark.realtime do
      request.set_form_data(title: Faker::Lorem.sentence(word_count: 3, supplemental: true),
                            body: Faker::Lorem.paragraph_by_chars(number: 2048, supplemental: false),
                            login: user_logins.sample, creator_ip: ip_v4_addresses.sample)
      response = Net::HTTP.start(create_uri.hostname, create_uri.port) do |http|
        http.request(request)
      end
      puts response.body
    end
    puts "Сreated a post in #{time * 1000} milliseconds"
  end

  100.times do
    response = Net::HTTP.get_response(random_uri)
    post_id = JSON.parse(response.body).dig("id")
    time = Benchmark.realtime do
      uri = URI.parse("http://localhost:3000/post/#{post_id}/rate")
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(value: rate_values.sample)
      response = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end
      puts response.body
    end
    puts "Сreated a rate in #{time * 1000} milliseconds"
  end
end
