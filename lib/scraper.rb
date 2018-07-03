require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students = []
    # card = doc.css("div.student-card")   
    # student_name = doc.css("div.card-text-container h4.student-name").text
    # location = doc.css("div.card-text-container p.student-location").text
    # profile =  doc.css("div.student-card a").first.attribute("href").value
    doc.css("div.roster-cards-container").each do |card|
    	card.css(".student-card a").each do |student|
				student_name = student.css(".student-name").text
				location = student.css(".student-location").text
				profile_link = "#{student.attr('href')}"
	  	
	  		students << {name: student_name, location: location, profile_url: profile_link}
    	end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    student = {}
    links = doc.css(".social-icon-container").children.css("a").map {|link_element| link_element.attribute("href").value}
    links.each do |link|
    	if link.include?("twitter")
    		student[:twitter] = link
    	elsif link.include?("github")
    		student[:github] = link
    	elsif link.include?("linkedin")
    		student[:linkedin] = link
    	else
    		student[:blog] = link
    	end
    end
    student[:profile_quote] = doc.css(".vitals-text-container .profile-quote").text
 		student[:bio] = doc.css(".details-container .description-holder p").text
		student  	
  end

	
end

# Scraper.scrape_profile_page('./fixtures/student-site/students/ryan-johnson.html')