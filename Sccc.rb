#подключение библиотек
require 'pp'
require 'nokogiri'
require 'curb'
require 'csv'
require 'choice'
#входные данные
Choice.options do
  option :file do
    short '-f'
    long '--file=petsonic.csv'
    default 'petsonic.csv'
  end
  option :seed do
    short '-s'
    long '--seed=URL'
    default 'https://www.petsonic.com/snacks-huesos-para-perros/'
  end
end
HOST = Choice[:seed]
SEED = "#{HOST}?p="
PRODUCT_LINK = "//a[contains(@class,'product_img_link product-list-category-img')]/@href"
PAGES = "//li[@id='pagination_next_bottom']/preceding-sibling::li[1]//span/text()"
IMAGE_LINK = "//img[@id='bigpic']/@src"
PRODUCT_NAME = "//h1[@itemprop='name']/text()"
PRODUCT_WEIGHT = ".//span[@class='radio_label']/text()"
PRODUCT_PRICE = ".//span[@class='price_comb']/text()"
BLOCK_WEIGHT_PRICE = "//ul[@class='attribute_radio_list']/li"
#качаем страницу и получаем Nokogiri дерево
def get_doc(url)
  #выводим страницу которую качаем
  puts url ||= HOST
  c = Curl.get(url)
  Nokogiri::HTML(c.body_str)
end

#циклом получаем ссылку на каждый продукт
def get_link(node)
  node.xpath(PRODUCT_LINK).map(&:text).map do |smth|
    "#{smth}"
  end
end

#получаем номер последней страницы
def get_links(node)
  node.xpath(PAGES).text.to_i
end

object_nokogiri = get_doc(nil)
puts page_result = get_links(object_nokogiri)
link_on_page = get_link(object_nokogiri)
#показываю адресс продукта
puts link_on_page
puts page_result
#открываем файл сsv для записи
CSV.open("petsonic.csv", "w") do |csv|
  csv << ["prod_name_and_weight", "price", "logo"]
  link_on_page.each do |go_to_link|
    object_nokogiri = get_doc(go_to_link)
    #получаем неизменные переменные нашего продукта имя и ссылку на картинку
    product = [object_nokogiri.xpath(PRODUCT_NAME).text.strip, object_nokogiri.xpath(IMAGE_LINK).text]
    #циклом получаем вес и цену нашего продукта
    object_nokogiri.xpath(BLOCK_WEIGHT_PRICE).each do |comp|
      comp = [
          comp.xpath(PRODUCT_WEIGHT).text,
          comp.xpath(PRODUCT_PRICE).text.gsub(/[^0-9\.]/, '')
      ]
      #дублируем данные
      const_prod = product.dup
      #указываем порядок записи в файл csv
      product = [const_prod[0] + " " + comp[0], comp[1], const_prod[1]]
      const_prod.join(" ")
      #записываем в csv файл
      csv << const_prod
    end
  end
  # #циклом получаем адресс новой страницы и отправляем её адресс на скачивание и получения Nokogiri дерева
  # (2..page_result).each do |url|
  #   object_nokogiri = get_doc("#{SEED}#{url}")
  #   link_on_page = get_link(object_nokogiri)
  #   link_on_page.each do |go_to_link|
  #     link_on_page.each do |go_to_link|
  #       object_nokogiri = get_doc(go_to_link)
  #       product = [object_nokogiri.xpath(PRODUCT_NAME).text.strip, object_nokogiri.xpath(IMAGE_LINK).text]
  #
  #       object_nokogiri.xpath(BLOCK_WEIGHT_PRICE).each do |comp|
  #         comp = [
  #             comp.xpath(PRODUCT_WEIGHT).text,
  #             comp.xpath(PRODUCT_PRICE).text.gsub(/[^0-9\.]/, '')
  #         ]
  #
  #         const_prod = product.dup
  #         const_prod = [const_prod[0] + " " + comp[0], comp[1], const_prod[1]]
  #         const_prod.join(" ")
  #
  #         csv << const_prod
  #
  #       end
  #     end
   # end
  #end
end

