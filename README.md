Для работы скрипта необходимо истановить bundler и скачать gem-ы :
gem 'nokogiri'
gem 'choice'
gem 'curb'
они находятся в файле Gemfile.

Name: 

Ruby - Интерпретируемый объектно-ориентированный язык программирования

SYNOPSIS
ruby [program_file] [argument ...] 

Команда для запуска скрипта из консоли : ruby Путь к файлу/ profitero.rb , например если файл на рабочем столе то команда запуска выглядит так : ruby Desktop/profitero.rb

Name: 

require  - подключение сторонней библиотеки

Choice.options

Choice - библиотека для определения анализа и параметра командной строки 

option - отдельная опция, их может быть несколько

option :file : опция для файла
 
    short '-f' : короткое название
    
    long '--file=petsonic.csv' : полное название
    
    default 'petsonic.cs' : значение по умолчанию
    
    
   option :seed  : опция для ссылки
   
    short '-s'   :короткое название
    
    long '--seed=URL' :полное название
    
    default 'https://www.petsonic.com/snacks-huesos-para-perros/' : значение по умолчанию
    




