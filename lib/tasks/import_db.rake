
namespace :db do

  desc "Imports the old data into the new PG database and cleans up data."

  task :import => :environment do

    ap articles =  Legacy.connection.select_all("select * from articles")

    articles.each do |article|

      title = article['title'].titleize
      description = article['description']
      url = article['url']
      category = article['category']
      category = category.singularize.parameterize unless category.nil?
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
