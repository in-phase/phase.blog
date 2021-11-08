require "file_utils"

PARTIAL = File.read(Path[__DIR__] / "_header.html")
RAW_API_DOCS = (Path[__DIR__] / "../api_docs_raw").normalize
OUTPUT_DIR = (Path[__DIR__] / "../docs/api").normalize

process_all(RAW_API_DOCS, OUTPUT_DIR)
# FileUtils.cp("./phase_logo.svg", OUTPUT_DIR)

def check_directory(dir)
  raise "Directory #{dir.inspect} does not exist." unless Dir.exists?(dir)
end

def process_all(input_dir : Path, output_dir : Path)
  check_directory(input_dir)
  if Dir.exists?(output_dir)
    loop do
      puts("Delete current contents of #{output_dir}? (YN):")

      case gets
      when /^y$/i
        FileUtils.rm_rf(output_dir)
        break
      when /^n$/i
        break
      else
        puts "Not a valid answer."
      end
    end
  end

  FileUtils.cp_r(input_dir, output_dir)

  process_all!(output_dir)
end

def process_all!(doc_dir : Path)
  check_directory(doc_dir)
  
  files = Dir.glob(doc_dir / "**/*.html")
  files.each do |filename|
    process!(filename)
  end
end

def process!(filename : String)
  data = File.read(filename)
  head, tail = data.split("<body>")
  content = head + "<body>" + PARTIAL + tail
  outfile = File.write(filename, content)
end
