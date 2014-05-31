class PagesController < ApplicationController
  def download
    @characters = JSON.parse(params[:characters], :symbolize_names => true)
    # render text: @characters[1][:paths]
    
    path = "#{Rails.root}/bin/font.ttx"
    font = render_to_string partial: "pages/download", locals: {characters: @characters}
    file = File.open(path, 'w') do |f|
      f.write font
    end
    
    font = `ttx #{path}`
    File.open(path.gsub('ttx', 'ttf')) do |f|
      File.rename(f, 'bin/font.otf')
    end
    
    
    send_file 'bin/font.otf'
  end
end
