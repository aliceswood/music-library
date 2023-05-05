require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context 'GET /albums/new' do
    it 'should return the form to complete and add a new album' do
      response = get('/albums/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')
    end
  end
  
  context 'POST /albums' do
    it 'should validate album parameters' do
      response = post(
        '/albums',
        invalid_artist_title: 'OK Computer',
        another_invalid_thing: 123
      )

      expect(response.status).to eq(400)
    end

    it 'should create a new album' do
      response = post(
        '/albums',
        title: 'Voyage',
        release_year: '2022',
        artist_id: '2'
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/albums')

      expect(response.body).to include('Voyage')
    end
  end

  # context 'GET /albums/:id' do
  #   it 'should return info about album 2' do
  #     response = get('/albums/2')
 
  #     expect(response.status).to eq(200)
  #     expect(response.body).to include('<h1>Surfer Rosa</h1>')
  #     expect(response.body).to include('Release year: 1988')
  #     expect(response.body).to include('Artist: Pixies')
  #   end
  # end

  context 'GET /albums' do
    it 'returns a list of albums and release years' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include('Surfer Rosa')
      expect(response.body).to include('Released: 1988')
    end
     
    it 'links album to corresponding /albums/2' do
      response = get('/albums')

      expect(response.status).to eq(200)
      expect(response.body).to include("href='/albums/2';")
      expect(response.body).to include('Surfer Rosa')
    end
  end

  context 'GET /artists' do
    it 'returns a list of the artists' do
      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include("Name: Pixies <br>")
    end
  end

  context 'POST /artists' do
    it 'should create a new artist' do
      response = post(
        '/artists',
        name: 'Wild nothing',
        genre: 'Indie'
      )

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')
      

      expect(response.status).to eq(200)
      expect(response.body).to include("Name: Wild nothing <br>")
    end
  end

  # context 'GET /artists/:id' do
  #   it 'should return info about artist 2' do
  #     response = get('/artists/2')
 
  #     expect(response.status).to eq(200)
  #     expect(response.body).to include('<h1>ABBA</h1>')
  #     expect(response.body).to include('Genre: Pop')
  #   end
  # end

  context 'GET /artists/new' do
    it 'should return a form to add a new artist' do
      response = get('artists/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/artists">')
      expect(response.body).to include('<input type="text" name="name"/>')
      expect(response.body).to include('<input type="text" name="genre"/>')
    end
  end
end
