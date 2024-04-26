module HouseHelper
  def house_field(name, content, **options)
    tag.house_md content, name: name, **options
  end

  def house_toolbar(**options, &block)
    tag.house_md_toolbar **options, &block
  end

  def house_toolbar_button(action, **options, &block)
    tag.button title: action.to_s.humanize, data: { "house-md-action": action }, **options, &block
  end

  def house_toolbar_file_upload_button(title = "Upload File", **options, &block)
    tag.label title: title, **options do
      safe_join [
        file_field_tag("test", data: { "house-md-toolbar-file-picker": true }, style: "display: none;"),
        capture(&block)
      ]
    end
  end
end
