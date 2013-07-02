
namespace :db do

  desc "Imports the old data into the new PG database and cleans up data."

  task :import => :environment do

    articles = get_articles_from_old_database

    articles.each do |article|

      title = article['title'].titleize
      description = article['description']
      url = article['url']
      category = article['category'].to_s.singularize.parameterize
      tags = parse_tags(article['tags'])


      new_article = Article.create(title: title, description: description, url: url)
      
      new_category = Category.find_or_create_by_name(category)
      new_article.update_attribute(:category_id, new_category.id)
     
      if tags
        tags.each do |tag| 
          new_tag = Tag.find_or_create_by_name(tag)
          new_tag.articles << new_article
          new_tag.save
        end
      end

    end  

  end

end


def parse_tags(tag_string)
  return nil if tag_string.to_s.empty?
  tags = []
  tag_string.split(", ").each do |tag|
    tags << tag.singularize.parameterize
  end
  tags
end

def get_articles_from_old_database
    ActiveRecord::Base.establish_connection('old_database')
    connection = ActiveRecord::Base.connection

    articles =  connection.select_all("select * from articles")

    ActiveRecord::Base.establish_connection('development')
    articles
end
