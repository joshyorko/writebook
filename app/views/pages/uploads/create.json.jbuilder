json.message "File uploaded successfully"
json.fileName @attachment.file.filename.to_s
json.mimetype @attachment.file.content_type
json.filePath attachment_url(@attachment.slug)
