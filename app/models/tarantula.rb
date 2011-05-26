class Tarantula

  attr_accessor :dropbox

  def initialize(dropbox_client)
    @dropbox = dropbox_client
  end

  def search_dropbox(keywords)
    final_file_list = []
    file_list = crawl_storage_structure
    file_list.each do |file|
      file_content = @dropbox.download(file.path)
      keywords.each do |keyword|
        if file_content.downcase.include?(keyword.downcase)
          final_file_list << file
          save_local_copy(file.path, file_content)
        end
      end
    end

    final_file_list.uniq
  end


  private

  def save_local_copy(file_path, content)
    filename = Pathname.new(file_path).basename
    open("downloads/"+ filename.to_s, "wb") { |file|
      file.write(content)
    }
  end

  
  def crawl_storage_structure
    file_list, directory_list = [] 
    listing_data = @dropbox.metadata("/")
    directory_list = listing_data.contents.select { |resource| resource.is_dir }
    file_list = listing_data.contents.select { |resource| !resource.is_dir }
    directory_list.each do |node|
      data = @dropbox.metadata(node.path)
      directory_list.concat(data.contents.select { |resource| resource.is_dir })
      file_list.concat(data.contents.select { |resource| !resource.is_dir })
    end

    file_list
  end

end
