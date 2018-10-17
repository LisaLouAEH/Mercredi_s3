require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'pp'

class Scrapper
    attr_accessor :hash_scrap, :email, :tab_email, :box
    def initialize(url)
        @box = travesti(Nokogiri::HTML(open(url)))
    end

    def get_email(page)
        @email = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
        #return @email
    end

    def travesti(pages)
        tab_url = []
        tab_name = []
        tab_email = []
        hash_city = Hash.new
        hash_email = Hash.new
        #------------------------------------------------------------------------------------------------
        #tab_name récup tout les nom de villes
        pages.css('a.lientxt').each do |node|
            tab_name << node.text
        end
        #puts tab_name
        #------------------------------------------------------------------------------------------------
        #tab_url recupere tout les urls des pages qui contiennents les adresses emails
        pages.css('//@href').grep(/34/).each do |node|
            tab_url << node.to_s.gsub("./", "http://annuaire-des-mairies.com/")
        end
        
        #------------------------------------------------------------------------------------------------
        #tab-email recupere toute les adresses emails depuis le tableau d'url
        tab_url.each do |url|
            tab_email << get_email(Nokogiri::HTML(open("#{url}")))
        end
        #-----------------------------------------------------------------------------------------------
        # range dans un hash_city clef =  ville N°x, valeur =  nom de la ville
        i= 0
        while i < tab_name.size
            hash_city.store("Ville #{i}", tab_name[i])
            i += 1
        end
        #-----------------------------------------------------------------------------------------------
        # range dans un hash_ emailclef =  email ,   valeur = truc@email.com
        i= 0
        while i < tab_email.size
            hash_email.store("Email #{i}", tab_email[i])
            i += 1
        end
        #----------------------------------------------------------------------------------------------
        # fusionne les hash_emails et hash_city
        hash_scrap = Hash[hash_city.zip(hash_email)]
        
        return hash_scrap
    end
    
end

