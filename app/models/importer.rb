class Importer
  require 'csv'
  require 'rexml/document'
  require 'json'

  def self.from_text(file)
    result = {books: [], authors: []}

    authors = []
    file.lines.each do |line|
      if line.start_with? 'author:'
        authors = []
        entries = line[7..-1].strip.split ','
        entries.each do |entry|
          parts = entry.strip.split
          first_name = parts.shift
          last_name = parts.pop
          other_names = parts.join(' ')
          author = Author.find_by(first_name: first_name, last_name: last_name, other_names: other_names)
          if author.nil?
            author = Author.create(first_name: first_name, last_name: last_name, other_names: other_names)
            result[:authors] << author.id
          end
          authors << author.id
        end
      else
        next if line.strip.empty?
        next unless Book.find_by(title: line.strip).nil?
        next if authors.empty?

        result[:books] << Book.create(title: line.strip, author_ids: authors).id
      end
    end

    result
  end

  def self.from_csv(file)
    csv = CSV.parse(file)
    result = {books: [], authors: []}
    csv.each do |entry|
      next if entry.empty?

      title = entry.shift.strip
      authors = []
      entry.each do |name|
        parts = name.split
        first_name = parts.shift
        last_name = parts.pop
        other_names = parts.join(' ')
        author = Author.find_by(first_name: first_name, last_name: last_name, other_names: other_names)
        if author.nil?
          author = Author.create(first_name: first_name, last_name: last_name, other_names: other_names)
          result[:authors] << author.id
        end
        authors << author.id
      end

      book = Book.find_by_title(title)
      if book.nil?
        book = Book.create(title: title, author_ids: authors)
        result[:books] << book.id
      end
    end
    result
  end

  def self.from_xml(content)
    include REXML

    doc = Document.new(content)
    result = {books: [], authors: []}

    node = doc.root_node.first
    until (node.node_type == :element) && node.has_name?('books')
      node = node.next_sibling
    end

    node.each_element do |child|
      next unless child.has_name? 'book'

      title = ''
      authors = []

      child.each_element do |data|
        case data.name
        when 'title'
          title = data.get_text
        when 'authors'
          data.each_element do |author|
            next unless author.has_name? 'author'

            authors << author.get_text
          end
        end
      end

      next if title.empty? || authors.empty?

      author_error = false
      author_ids = []
      authors.each do |name|
        parts = name.to_s.strip.split
        first_name = parts.shift
        last_name = parts.pop
        other_names = parts.join ' '
        if first_name.empty? || last_name.empty?
          author_error = true
          break
        end

        author = Author.find_by(first_name: first_name, last_name: last_name, other_names: other_names)
        if author.nil?
          author = Author.create(first_name: first_name, last_name: last_name, other_names: other_names)
          result[:authors] << author.id
        end
        author_ids << author.id
      end
      next if author_error
      next unless Book.find_by(title: title.to_s).nil?

      result[:books] << Book.create(title: title.to_s, author_ids: author_ids).id
    end

    result
  end

  def self.from_json(content)
    result = { books: 0, authors: 0 }
    json = JSON.parse content
    if json.is_a? Array
      json.each do |element|
        next unless element.is_a? Hash
        next unless %w[title author].all? { |k| element.key? k }
        next unless %w[title author].all? { |k| element[k].is_a? String }

        title = element['title']
        authors = element['author'].split /,| and /
        next if title.empty? || authors.empty?

        author_ids = []
        authors.each do |name|
          name = name.strip.split
          first_name = name.shift
          last_name = name.pop
          other_names = name.map(&:strip).join ' '
          author = Author.find_by first_name: first_name, last_name: last_name, other_names: other_names
          if author.nil?
            author = Author.create first_name: first_name, last_name: last_name, other_names: other_names
            result[:authors] << author.id
          end
          author_ids << author.id

          book = Book.find_by_title title
          if book.nil?
            result[:books] << Book.create(title: title, author_ids: author_ids).id
          end
        end
      end
    end
    result
  end
end
