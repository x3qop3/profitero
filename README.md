для работы скрипта необходимо истановить bundler и скачать gem-ы :
gem 'nokogiri'
gem 'choice'
gem 'curb'
они находятся в файле Gemfile
 задать входные данные : 
 Choice.options do
 # название файла куда записывать результат
  option :file do
    short '-f'
    long '--file=petsonic.csv'
    default 'petsonic.csv'
  end
  # начальный URL
  option :seed do
    short '-s'
    long '--seed=URL'
    default 'https://www.petsonic.com/snacks-huesos-para-perros/'
  end
