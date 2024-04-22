module HouseHelper
  def house_field(name, content, **options)
    tag.house_md content, name: name, **options
  end

  def house_toolbar(**options, &block)
    tag.house_md_toolbar **options, &block
  end

  def house_button(action, **options, &block)
    tag.button title: action.to_s.humanize, data: { "house-md-action": action }, **options, &block
  end
end
