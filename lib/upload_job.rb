class UploadJob <Struct.new(:uploadall,:uploadrel,:temp_release)
     def perform
         Checkman.upload_to_database(uploadall,uploadrel,temp_release)
     end
end