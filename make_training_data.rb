require 'csv'

dictionary = Set.new

def tokens(text)
  set = Set.new
  text.gsub(/[!\?\.\"\',]/,'').downcase.split(/\s+/).each do |token|
    next if token =~ /^rt$/
    next if token =~ /http[s]?:\/\//
    set << token
  end
  set.to_a
end


CSV.foreach("./tweets.csv", :headers => true) do |row|
  dictionary += tokens(row['Text'])
end

File.open("training.data", "wb") do |f|
  current_index = 1
  CSV.foreach("./tweets.csv", :headers => true) do |row|
    text = row['Text']
    retweet = (text =~ /^RT/) ? 1 : 0
    
    d = tokens(text)
    vector = [0] * dictionary.length
    d.each do |v|
      vector[dictionary.to_a.index(v)] = 1
    end
    
    
    f.write("#{retweet} #{current_index} #{vector.join(' ')}\n")
    
    current_index += 1
  end
end